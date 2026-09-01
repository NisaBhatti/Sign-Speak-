package com.example.signspeak

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import com.google.mediapipe.framework.AndroidAssetUtil
import com.google.mediapipe.framework.PacketGetter
import com.google.mediapipe.solutions.hands.HandLandmark
import com.google.mediapipe.solutions.hands.Hands
import com.google.mediapipe.solutions.hands.HandsOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

class HandDetectionPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var hands: Hands? = null
    private var tflite: Interpreter? = null
    private val executor: ExecutorService = Executors.newSingleThreadExecutor()
    private val isProcessing = AtomicBoolean(false)
    
    companion object {
        private const val TAG = "HandDetection"
        private const val MODEL_PATH = "models/alif_robust.tflite"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "hand_detection")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        
        // Initialize MediaPipe
        AndroidAssetUtil.initializeNativeAssetManager(context)
        initMediaPipe()
        
        // Load TFLite Model
        loadTFLiteModel()
    }

    private fun initMediaPipe() {
        try {
            hands = Hands.create(
                HandsOptions.builder()
                    .setStaticImageMode(false)
                    .setMaxNumHands(1)
                    .setMinDetectionConfidence(0.5)
                    .setMinTrackingConfidence(0.5)
                    .build()
            )
            Log.d(TAG, "✅ MediaPipe Hands initialized successfully")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to initialize MediaPipe: ${e.message}")
        }
    }

    private fun loadTFLiteModel() {
        try {
            val modelBuffer = loadModelFile()
            tflite = Interpreter(modelBuffer)
            Log.d(TAG, "✅ TFLite model loaded successfully from: $MODEL_PATH")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to load TFLite model: ${e.message}")
        }
    }

    private fun loadModelFile(): MappedByteBuffer {
        try {
            val assetFileDescriptor = context.assets.openFd(MODEL_PATH)
            val inputStream = FileInputStream(assetFileDescriptor.fileDescriptor)
            val fileChannel = inputStream.channel
            val startOffset = assetFileDescriptor.startOffset
            val declaredLength = assetFileDescriptor.declaredLength
            return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
        } catch (e: Exception) {
            Log.e(TAG, "Model file not found at: $MODEL_PATH, Error: ${e.message}")
            throw e
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "processFrame" -> {
                val imageBytes = call.argument<ByteArray>("imageBytes")
                if (imageBytes != null) {
                    processFrame(imageBytes, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image bytes are null", null)
                }
            }
            "detectLandmarks" -> {
                val imageBytes = call.argument<ByteArray>("imageBytes")
                if (imageBytes != null) {
                    detectLandmarksOnly(imageBytes, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image bytes are null", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun processFrame(imageBytes: ByteArray, result: Result) {
        if (isProcessing.get()) {
            result.success(null)
            return
        }
        
        isProcessing.set(true)
        
        executor.execute {
            try {
                val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                if (bitmap == null) {
                    result.error("DECODE_ERROR", "Failed to decode image", null)
                    isProcessing.set(false)
                    return@execute
                }

                // Detect hand landmarks using MediaPipe
                val landmarks = detectHandLandmarks(bitmap)
                
                if (landmarks.isEmpty()) {
                    result.success(createResponse(false, 0.0, false, emptyList()))
                    isProcessing.set(false)
                    return@execute
                }

                // Convert landmarks to 42 features (21 landmarks * 2)
                val features = landmarksToFeatures(landmarks)
                
                // Run TFLite inference
                val prediction = runInference(features)
                
                result.success(createResponse(prediction > 0.5f, prediction.toDouble(), true, landmarks))
                
            } catch (e: Exception) {
                Log.e(TAG, "Error processing frame: ${e.message}")
                result.error("PROCESSING_ERROR", e.message, null)
            } finally {
                isProcessing.set(false)
            }
        }
    }

    private fun detectLandmarksOnly(imageBytes: ByteArray, result: Result) {
        executor.execute {
            try {
                val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                val landmarks = detectHandLandmarks(bitmap)
                result.success(landmarks)
            } catch (e: Exception) {
                result.error("DETECTION_ERROR", e.message, null)
            }
        }
    }

    private fun detectHandLandmarks(bitmap: Bitmap): List<List<Float>> {
        val result = mutableListOf<List<Float>>()
        
        try {
            // Convert bitmap to MediaPipe Image
            val mpImage = convertBitmapToMPImage(bitmap)
            
            hands?.let { handsInstance ->
                val packet = handsInstance.process(mpImage)
                val output = packet.get(0)
                
                // Extract landmarks
                val landmarks = PacketGetter.getHandLandmarks(output)
                
                if (landmarks != null && landmarks.isNotEmpty()) {
                    for (landmark in landmarks[0]) {
                        result.add(listOf(landmark.x(), landmark.y()))
                    }
                }
                
                packet.release()
            }
            
            mpImage.release()
            
        } catch (e: Exception) {
            Log.e(TAG, "Error detecting hand: ${e.message}")
        }
        
        return result
    }

    private fun convertBitmapToMPImage(bitmap: Bitmap): com.google.mediapipe.framework.Image {
        return com.google.mediapipe.framework.Image.fromBitmap(bitmap)
    }

    private fun landmarksToFeatures(landmarks: List<List<Float>>): FloatArray {
        val features = FloatArray(42) // 21 landmarks * 2 (x, y)
        
        for (i in 0 until minOf(21, landmarks.size)) {
            val landmark = landmarks[i]
            if (landmark.size >= 2) {
                features[i * 2] = landmark[0] // x
                features[i * 2 + 1] = landmark[1] // y
            }
        }
        
        return features
    }

    private fun runInference(features: FloatArray): Float {
        return try {
            tflite?.let { interpreter ->
                val inputArray = arrayOf(features)
                val outputArray = Array(1) { FloatArray(1) }
                
                interpreter.run(inputArray, outputArray)
                outputArray[0][0]
            } ?: 0.0f
        } catch (e: Exception) {
            Log.e(TAG, "TFLite inference error: ${e.message}")
            0.0f
        }
    }

    private fun createResponse(
        isAlif: Boolean,
        confidence: Double,
        hasHand: Boolean,
        landmarks: List<List<Float>>
    ): Map<String, Any> {
        return mapOf(
            "isAlif" to isAlif,
            "confidence" to confidence,
            "hasHand" to hasHand,
            "landmarks" to landmarks
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        hands?.close()
        tflite?.close()
        executor.shutdown()
    }
}