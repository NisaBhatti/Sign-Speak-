import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  static Interpreter? _interpreter;
  static bool _isLoaded = false;
  
  // ============================================
  // LOAD MODEL
  // ============================================
  static Future<void> loadModel() async {
    if (_isLoaded) return;
    
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/alif_robust.tflite');
      _isLoaded = true;
      
      print('✅ TFLite model loaded successfully!');
      
      if (_interpreter != null) {
        print('📊 Input shape: ${_interpreter!.getInputTensor(0).shape}');
        print('📊 Output shape: ${_interpreter!.getOutputTensor(0).shape}');
      }
    } catch (e) {
      print('❌ Failed to load model: $e');
      _isLoaded = false;
    }
  }
  
  // ============================================
  // PREDICT FROM FEATURES (42 features)
  // ============================================
  static Future<double> predict(List<double> features) async {
    if (!_isLoaded) {
      await loadModel();
    }
    
    if (_interpreter == null || !_isLoaded) {
      return 0.0;
    }
    
    try {
      // ✅ FIX: Input should be 2D [1, 42]
      final input = Float32List.fromList(features.map((e) => e.toDouble()).toList());
      
      // ✅ FIX: Output should be 2D [1, 1]
      final output = Float32List(2); // [1, 1] flattened
      
      // Run inference
      _interpreter!.run(input, output);
      
      // Extract the prediction (first element)
      return output[0].toDouble();
    } catch (e) {
      print('❌ Prediction error: $e');
      return 0.0;
    }
  }
  
  // ============================================
  // PREDICT FROM IMAGE (Direct)
  // ============================================
  static Future<double> predictFromImage(Uint8List imageBytes) async {
    if (!_isLoaded) {
      await loadModel();
    }
    
    if (_interpreter == null || !_isLoaded) {
      return 0.0;
    }
    
    try {
      final features = await extractFeaturesFromImage(imageBytes);
      
      if (features.isEmpty) {
        return 0.0;
      }
      
      return await predict(features);
    } catch (e) {
      print('❌ Image prediction error: $e');
      return 0.0;
    }
  }
  
  // ============================================
  // TEST WITH DUMMY FEATURES
  // ============================================
  static Future<DetectionResult> testWithDummy() async {
    await loadModel();
    
    // Create dummy 42 features (21 landmarks * 2)
    final features = List.generate(42, (i) => i / 42.0);
    
    final prediction = await predict(features);
    
    return DetectionResult(
      hasHand: true,
      isAlif: prediction > 0.5,
      confidence: prediction,
      message: 'Dummy test',
      featuresCount: features.length,
    );
  }
  
  // ============================================
  // EXTRACT FEATURES FROM IMAGE (Placeholder)
  // ============================================
  static Future<List<double>> extractFeaturesFromImage(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        print('❌ Failed to decode image');
        return [];
      }
      
      // Resize
      final resized = img.copyResize(image, width: 224, height: 224);
      print('📊 Image processed: ${resized.width}x${resized.height}');
      
      // Return dummy 42 features for testing
      return List.generate(42, (i) => i / 42.0);
      
    } catch (e) {
      print('❌ Feature extraction error: $e');
      return [];
    }
  }
  
  // ============================================
  // CLOSE MODEL
  // ============================================
  static void close() {
    _interpreter?.close();
    _isLoaded = false;
    print('✅ TFLite model closed');
  }
}

// ============================================
// DETECTION RESULT CLASS
// ============================================
class DetectionResult {
  final bool hasHand;
  final bool isAlif;
  final double confidence;
  final String message;
  final int featuresCount;
  final String error;
  
  DetectionResult({
    required this.hasHand,
    required this.isAlif,
    required this.confidence,
    this.message = '',
    this.featuresCount = 0,
    this.error = '',
  });
  
  factory DetectionResult.error(String error) {
    return DetectionResult(
      hasHand: false,
      isAlif: false,
      confidence: 0.0,
      error: error,
    );
  }
  
  factory DetectionResult.empty() {
    return DetectionResult(
      hasHand: false,
      isAlif: false,
      confidence: 0.0,
    );
  }
  
  bool get isSuccess => error.isEmpty;
}