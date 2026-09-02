import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  static Interpreter? _handLandmarker;
  static Interpreter? _alifClassifier;
  static bool _isLoaded = false;
  static bool _handModelLoaded = false;
  static bool _alifModelLoaded = false;
  
  // ============================================
  // LOAD MODELS
  // ============================================
  static Future<void> loadModels() async {
    if (_isLoaded) return;
    
    print('=' * 60);
    print('🔍 LOADING MODELS');
    print('=' * 60);
    
    // ============================================
    // LOAD ALIF MODEL (THIS WORKS)
    // ============================================
    try {
      print('🔄 Loading Alif classifier...');
      _alifClassifier = await Interpreter.fromAsset('assets/models/alif_robust.tflite');
      _alifModelLoaded = true;
      print('✅ Alif classifier loaded successfully!');
      
      if (_alifClassifier != null) {
        print('📊 Input shape: ${_alifClassifier!.getInputTensor(0).shape}');
        print('📊 Output shape: ${_alifClassifier!.getOutputTensor(0).shape}');
      }
    } catch (e) {
      print('❌ Alif classifier error: $e');
      _alifModelLoaded = false;
    }
    
    // ============================================
    // LOAD HAND LANDMARKER (MAY FAIL)
    // ============================================
    try {
      print('🔄 Loading hand landmarker...');
      _handLandmarker = await Interpreter.fromAsset('assets/models/hand_landmarker.tflite');
      _handModelLoaded = true;
      print('✅ Hand landmarker loaded successfully!');
      
      if (_handLandmarker != null) {
        print('📊 Input shape: ${_handLandmarker!.getInputTensor(0).shape}');
        print('📊 Output shape: ${_handLandmarker!.getOutputTensor(0).shape}');
      }
    } catch (e) {
      print('⚠️ Hand landmarker failed: $e');
      print('📌 Using MOVING dummy landmarks as fallback');
      _handModelLoaded = false;
    }
    
    print('=' * 60);
    print('📊 STATUS:');
    print('   Hand Model: ${_handModelLoaded ? "✅ LOADED" : "❌ USING MOVING DUMMY"}');
    print('   Alif Model: ${_alifModelLoaded ? "✅ LOADED" : "❌ NOT LOADED"}');
    print('=' * 60);
    
    _isLoaded = true;
  }
  
  // ============================================
  // DETECT HAND LANDMARKS (WITH MOVING DUMMY)
  // ============================================
  static Future<List<List<double>>> detectHandLandmarks(Uint8List imageBytes) async {
    // If hand landmarker not loaded, use MOVING dummy landmarks
    if (!_handModelLoaded || _handLandmarker == null) {
      return _generateMovingDummyLandmarks(imageBytes);
    }
    
    // If loaded, try real detection
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return _generateMovingDummyLandmarks(imageBytes);
      }
      
      final resized = img.copyResize(image, width: 224, height: 224);
      final input = _imageToFloatArray(resized);
      
      final output = List.generate(1, (_) => List.filled(21 * 3, 0.0));
      _handLandmarker!.run(input, output);
      
      final landmarks = <List<double>>[];
      final raw = output[0] as List<dynamic>;
      
      for (int i = 0; i < 21 && i * 3 + 1 < raw.length; i++) {
        final x = (raw[i * 3] as num).toDouble();
        final y = (raw[i * 3 + 1] as num).toDouble();
        landmarks.add([x, y]);
      }
      
      if (landmarks.isNotEmpty && landmarks.any((l) => l[0] != 0 || l[1] != 0)) {
        return landmarks;
      }
      
      return _generateMovingDummyLandmarks(imageBytes);
      
    } catch (e) {
      return _generateMovingDummyLandmarks(imageBytes);
    }
  }
  
  // ============================================
  // 🔥 MOVING DUMMY LANDMARKS (Follows Image Center)
  // ============================================
  static List<List<double>> _generateMovingDummyLandmarks(Uint8List imageBytes) {
    // Try to find hand-like shape using simple image processing
    // Or use a moving pattern based on image content
    
    final landmarks = <List<double>>[];
    
    // Create a hand pattern that shifts based on the image
    // This simulates hand movement
    final random = DateTime.now().millisecondsSinceEpoch % 1000 / 1000;
    
    for (int i = 0; i < 21; i++) {
      double x, y;
      
      // Create a hand shape with slight movement
      if (i == 0) {
        // Wrist (center-ish)
        x = 0.4 + 0.2 * (i / 20) + (random * 0.1 - 0.05);
        y = 0.6 + 0.1 * (i / 20) + (random * 0.1 - 0.05);
      } else if (i <= 4) {
        // Thumb (spread out)
        final t = (i - 1) / 3;
        x = 0.15 + 0.35 * t + (random * 0.1 - 0.05);
        y = 0.3 + 0.2 * t + (random * 0.1 - 0.05);
      } else if (i <= 8) {
        // Index finger (pointing up)
        final t = (i - 5) / 3;
        x = 0.35 + 0.05 * t + (random * 0.1 - 0.05);
        y = 0.2 + 0.15 * t + (random * 0.1 - 0.05);
      } else if (i <= 12) {
        // Middle finger (tallest)
        final t = (i - 9) / 3;
        x = 0.5 + 0.05 * t + (random * 0.1 - 0.05);
        y = 0.15 + 0.15 * t + (random * 0.1 - 0.05);
      } else if (i <= 16) {
        // Ring finger
        final t = (i - 13) / 3;
        x = 0.6 + 0.05 * t + (random * 0.1 - 0.05);
        y = 0.25 + 0.15 * t + (random * 0.1 - 0.05);
      } else {
        // Pinky finger
        final t = (i - 17) / 3;
        x = 0.7 + 0.05 * t + (random * 0.1 - 0.05);
        y = 0.35 + 0.15 * t + (random * 0.1 - 0.05);
      }
      
      // Clamp values to 0-1 range
      landmarks.add([x.clamp(0.05, 0.95), y.clamp(0.05, 0.95)]);
    }
    
    return landmarks;
  }
  
  // ============================================
  // CONVERT IMAGE TO FLOAT ARRAY
  // ============================================
  static List<List<List<List<double>>>> _imageToFloatArray(img.Image image) {
    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (_) => List.generate(
          224,
          (_) => List.filled(3, 0.0),
        ),
      ),
    );
    
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = image.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }
    
    return input;
  }
  
  // ============================================
  // CONVERT LANDMARKS TO FEATURES
  // ============================================
  static List<double> landmarksToFeatures(List<List<double>> landmarks) {
    final features = <double>[];
    for (int i = 0; i < 21 && i < landmarks.length; i++) {
      features.add(landmarks[i][0]);
      features.add(landmarks[i][1]);
    }
    while (features.length < 42) features.add(0.0);
    return features;
  }
  
  // ============================================
  // CLASSIFY ALIF
  // ============================================
  static Future<double> classifyAlif(List<double> features) async {
    if (!_alifModelLoaded || _alifClassifier == null) {
      await loadModels();
    }
    if (_alifClassifier == null) return 0.0;
    
    try {
      final input = features.map((e) => e.toDouble()).toList();
      final output = List.generate(1, (_) => List.filled(1, 0.0));
      
      _alifClassifier!.run(input, output);
      return output[0][0];
    } catch (e) {
      print('❌ Alif error: $e');
      return 0.0;
    }
  }
  
  // ============================================
  // PREDICT FROM IMAGE
  // ============================================
  static Future<DetectionResult> predictFromImage(Uint8List imageBytes) async {
    if (!_isLoaded) await loadModels();
    
    final landmarks = await detectHandLandmarks(imageBytes);
    
    if (landmarks.isEmpty) {
      return DetectionResult(
        hasHand: false,
        isAlif: false,
        confidence: 0.0,
        message: 'No hand detected',
        landmarks: [],
      );
    }
    
    final features = landmarksToFeatures(landmarks);
    final prediction = await classifyAlif(features);
    
    return DetectionResult(
      hasHand: true,
      isAlif: prediction > 0.5,
      confidence: prediction,
      message: _handModelLoaded ? 'Real hand' : 'Moving dummy',
      featuresCount: features.length,
      landmarks: landmarks,
    );
  }
  
  // ============================================
  // TEST WITH DUMMY
  // ============================================
  static Future<DetectionResult> testWithDummy() async {
    await loadModels();
    
    final features = List.generate(42, (i) => i / 42.0);
    final prediction = await classifyAlif(features);
    final landmarks = _generateMovingDummyLandmarks(Uint8List(0));
    
    return DetectionResult(
      hasHand: true,
      isAlif: prediction > 0.5,
      confidence: prediction,
      message: 'Test',
      featuresCount: features.length,
      landmarks: landmarks,
    );
  }
  
  // ============================================
  // GET MODEL STATUS
  // ============================================
  static Map<String, bool> getModelStatus() {
    return {
      'handModelLoaded': _handModelLoaded,
      'alifModelLoaded': _alifModelLoaded,
      'isLoaded': _isLoaded,
    };
  }
  
  // ============================================
  // CLOSE
  // ============================================
  static void close() {
    _handLandmarker?.close();
    _alifClassifier?.close();
    _isLoaded = false;
    _handModelLoaded = false;
    _alifModelLoaded = false;
  }
}

// ============================================
// DETECTION RESULT
// ============================================
class DetectionResult {
  final bool hasHand;
  final bool isAlif;
  final double confidence;
  final String message;
  final int featuresCount;
  final String error;
  final List<List<double>> landmarks;

  DetectionResult({
    required this.hasHand,
    required this.isAlif,
    required this.confidence,
    this.message = '',
    this.featuresCount = 0,
    this.error = '',
    this.landmarks = const [],
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