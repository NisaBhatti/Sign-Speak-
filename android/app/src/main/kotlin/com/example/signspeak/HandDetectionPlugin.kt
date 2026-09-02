package com.example.signspeak

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import java.io.FileInputStream
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

class HandDetectionPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var handDetector: Interpreter? = null
    private var alifClassifier: Interpreter? = null
    private val executor: ExecutorService = Executors.newSingleThreadExecutor()
    private val isProcessing = AtomicBoolean(false)
    
    companion object {
        private const val TAG = "HandDetection"
        private const val HAND_MODEL = "models/hand_landmarker.tflite"
        private const val ALIF_MODEL = "models/alif_robust.tflite"
        private const val INPUT_SIZE = 224
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "hand_detection")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
        
        loadModels()
    }

    private fun loadModels() {
        try {
            // Load hand detection model
            val handBuffer = loadModelFile(HAND_MODEL)
            handDetector = Interpreter(handBuffer)
            Log.d(TAG, "✅ Hand detector loaded from: $HAND_MODEL")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Hand detector failed: ${e.message}")
        }

        try {
            // Load Alif classifier
            val alifBuffer = loadModelFile(ALIF_MODEL)
            alifClassifier = Interpreter(alifBuffer)
            Log.d(TAG, "✅ Alif classifier loaded from: $ALIF_MODEL")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Alif classifier failed: ${e.message}")
        }
    }

    private fun loadModelFile(path: String): MappedByteBuffer {
        try {
            val assetFileDescriptor = context.assets.openFd(path)
            val inputStream = FileInputStream(assetFileDescriptor.fileDescriptor)
            val fileChannel = inputStream.channel
            val startOffset = assetFileDescriptor.startOffset
            val declaredLength = assetFileDescriptor.declaredLength
            return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
        } catch (e: Exception) {
            Log.e(TAG, "Model not found: $path")
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
            "checkModels" -> {
                checkModels(result)
            }
            else -> result.notImplemented()
        }
    }

    private fun checkModels(result: Result) {
        val status = mapOf(
            "handDetectorLoaded" to (handDetector != null),
            "alifClassifierLoaded" to (alifClassifier != null)
        )
        result.success(status)
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

                // Step 1: Detect hand landmarks using TFLite
                val landmarks = detectHandLandmarks(bitmap)
                
                if (landmarks.isEmpty()) {
                    result.success(mapOf(
                        "isAlif" to false,
                        "confidence" to 0.0,
                        "hasHand" to false,
                        "landmarks" to emptyList<FloatArray>()
                    ))
                    isProcessing.set(false)
                    return@execute
                }

                // Step 2: Convert to 42 features
                val features = landmarksToFeatures(landmarks)
                
                // Step 3: Classify Alif
                val prediction = classifyAlif(features)
                
                result.success(mapOf(
                    "isAlif" to (prediction > 0.5f),
                    "confidence" to prediction.toDouble(),
                    "hasHand" to true,
                    "landmarks" to landmarks
                ))
                
            } catch (e: Exception) {
                Log.e(TAG, "Error: ${e.message}")
                result.error("PROCESSING_ERROR", e.message, null)
            } finally {
                isProcessing.set(false)
            }
        }
    }

    private fun detectHandLandmarks(bitmap: Bitmap): List<FloatArray> {
        val result = mutableListOf<FloatArray>()
        
        try {
            // Preprocess image
            val inputImage = TensorImage.fromBitmap(bitmap)
            val imageProcessor = ImageProcessor.Builder()
                .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeOp.ResizeMethod.BILINEAR))
                .add(NormalizeOp(127.5f, 127.5f))
                .build()
            
            val processedImage = imageProcessor.process(inputImage)
            val inputBuffer = processedImage.tensorBuffer.buffer
            val inputArray = arrayOf(inputBuffer)
            
            // Prepare output (21 landmarks x 3 coordinates)
            val outputArray = Array(1) { FloatArray(21 * 3) }
            
            // Run inference
            handDetector?.run(inputArray, outputArray)
            
            // Extract landmarks
            val landmarks = outputArray[0]
            for (i in 0 until 21) {
                val x = landmarks[i * 3]
                val y = landmarks[i * 3 + 1]
                result.add(floatArrayOf(x, y))
            }
            
            Log.d(TAG, "✅ Detected ${result.size} landmarks")
            
        } catch (e: Exception) {
            Log.e(TAG, "Hand detection error: ${e.message}")
        }
        
        return result
    }

    private fun landmarksToFeatures(landmarks: List<FloatArray>): FloatArray {
        val features = FloatArray(42)
        
        for (i in 0 until minOf(21, landmarks.size)) {
            val landmark = landmarks[i]
            if (landmark.size >= 2) {
                features[i * 2] = landmark[0]
                features[i * 2 + 1] = landmark[1]
            }
        }
        
        return features
    }

    private fun classifyAlif(features: FloatArray): Float {
        return try {
            alifClassifier?.let { interpreter ->
                val inputArray = arrayOf(features)
                val outputArray = Array(1) { FloatArray(1) }
                
                interpreter.run(inputArray, outputArray)
                outputArray[0][0]
            } ?: 0.0f
        } catch (e: Exception) {
            Log.e(TAG, "Alif classification error: ${e.message}")
            0.0f
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        handDetector?.close()
        alifClassifier?.close()
        executor.shutdown()
    }
}