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
import java.io.FileInputStream
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

class HandDetectionPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
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
        
        // Load TFLite Model
        loadTFLiteModel()
    }

    private fun loadTFLiteModel() {
        try {
            val modelBuffer = loadModelFile()
            tflite = Interpreter(modelBuffer)
            Log.d(TAG, "✅ TFLite model loaded successfully")
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
            "predict" -> {
                val features = call.argument<DoubleArray>("features")
                if (features != null) {
                    predict(features, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Features are null", null)
                }
            }
            "getLandmarks" -> {
                val imageBytes = call.argument<ByteArray>("imageBytes")
                if (imageBytes != null) {
                    getLandmarks(imageBytes, result)
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

                // Here you would extract features from the image
                // For now, we'll return a placeholder result
                // You can implement hand detection using OpenCV or a custom model
                
                // Simulated response - replace with actual detection
                val features = getDummyFeatures()
                val prediction = runInference(features)
                
                result.success(createResponse(prediction > 0.5f, prediction.toDouble(), true))
                
            } catch (e: Exception) {
                Log.e(TAG, "Error processing frame: ${e.message}")
                result.error("PROCESSING_ERROR", e.message, null)
            } finally {
                isProcessing.set(false)
            }
        }
    }

    private fun predict(features: DoubleArray, result: Result) {
        executor.execute {
            try {
                val floatFeatures = features.map { it.toFloat() }.toFloatArray()
                val prediction = runInference(floatFeatures)
                result.success(prediction.toDouble())
            } catch (e: Exception) {
                result.error("PREDICTION_ERROR", e.message, null)
            }
        }
    }

    private fun getLandmarks(imageBytes: ByteArray, result: Result) {
        executor.execute {
            try {
                val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                if (bitmap == null) {
                    result.error("DECODE_ERROR", "Failed to decode image", null)
                    return@execute
                }

                // Placeholder - return dummy landmarks
                // In a real implementation, you'd use a hand detection model
                val landmarks = getDummyLandmarks()
                result.success(landmarks)
                
            } catch (e: Exception) {
                result.error("DETECTION_ERROR", e.message, null)
            }
        }
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

    private fun getDummyFeatures(): FloatArray {
        // Return dummy 42 features (21 landmarks * 2)
        val features = FloatArray(42)
        for (i in features.indices) {
            features[i] = (i / 42.0f)
        }
        return features
    }

    private fun getDummyLandmarks(): List<List<Float>> {
        // Return dummy 21 landmarks
        val landmarks = mutableListOf<List<Float>>()
        for (i in 0 until 21) {
            landmarks.add(listOf(i / 21.0f, i / 21.0f))
        }
        return landmarks
    }

    private fun createResponse(
        isAlif: Boolean,
        confidence: Double,
        hasHand: Boolean
    ): Map<String, Any> {
        return mapOf(
            "isAlif" to isAlif,
            "confidence" to confidence,
            "hasHand" to hasHand
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        tflite?.close()
        executor.shutdown()
    }
}