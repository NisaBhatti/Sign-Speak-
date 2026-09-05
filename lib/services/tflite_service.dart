import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  static Interpreter? _handDetector;
  static Interpreter? _alifClassifier;
  static bool _isLoaded = false;
  static bool _handModelLoaded = false;
  static bool _alifModelLoaded = false;
  
  static const int INPUT_SIZE = 224;
  static const int NUM_LANDMARKS = 21;
  static const int NUM_KEYPOINTS = 42;
  
  static Future<void> loadModels() async {
    if (_isLoaded) return;
    
    print('=' * 60);
    print('🔍 LOADING MODELS');
    print('=' * 60);
    
    // ============================================
    // LOAD HAND DETECTION MODEL
    // ============================================
    try {
      print('🔄 Loading hand detection model...');
      _handDetector = await Interpreter.fromAsset('assets/models/hand_detection.tflite');
      _handModelLoaded = true;
      print('✅ Hand detection model loaded successfully!');
      
      if (_handDetector != null) {
        print('📊 Input shape: ${_handDetector!.getInputTensor(0).shape}');
        print('📊 Output shape: ${_handDetector!.getOutputTensor(0).shape}');
      }
    } catch (e) {
      print('❌ Hand detection model error: $e');
      print('   Expected: assets/models/hand_detection.tflite');
      _handModelLoaded = false;
    }
    
    // ============================================
    // LOAD ALIF CLASSIFIER
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
    
    print('=' * 60);
    print('📊 MODEL STATUS:');
    print('   Hand Detection: ${_handModelLoaded ? "✅ LOADED" : "❌ NOT LOADED (Using Dummy)"}');
    print('   Alif Classifier: ${_alifModelLoaded ? "✅ LOADED" : "❌ NOT LOADED"}');
    print('=' * 60);
    
    _isLoaded = true;
  }
  
  static Future<List<List<double>>> detectHandLandmarks(Uint8List imageBytes) async {
    if (!_handModelLoaded || _handDetector == null) {
      print('🔄 Using dummy landmarks (hand model not loaded)');
      return _generateDummyLandmarks();
    }
    
    try {
      print('📷 Processing image: ${imageBytes.length} bytes');
      
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        print('❌ Failed to decode image');
        return _generateDummyLandmarks();
      }
      
      print('📷 Original image: ${image.width}x${image.height}');
      
      // Resize to model input size
      final resized = img.copyResize(image, width: INPUT_SIZE, height: INPUT_SIZE);
      print('📷 Resized: ${resized.width}x${resized.height}');
      
      // Convert to float array [1, INPUT_SIZE, INPUT_SIZE, 3]
      final input = _imageToFloatArray(resized);
      
      // Get output shape from model
      final outputShape = _handDetector!.getOutputTensor(0).shape;
      print('📊 Output shape: $outputShape');
      
      // Create output based on model output shape
      final output = List.generate(1, (_) => List.filled(NUM_KEYPOINTS, 0.0));
      
      // Run inference
      print('🔄 Running inference on hand detection model...');
      final stopwatch = Stopwatch()..start();
      _handDetector!.run(input, output);
      stopwatch.stop();
      print('⏱️ Inference time: ${stopwatch.elapsedMilliseconds}ms');
      
      // Extract landmarks from output
      final landmarks = <List<double>>[];
      final raw = output[0] as List<dynamic>;
      
      print('📊 Raw output length: ${raw.length}');
      
      for (int i = 0; i < NUM_LANDMARKS && i * 2 + 1 < raw.length; i++) {
        final x = (raw[i * 2] as num).toDouble();
        final y = (raw[i * 2 + 1] as num).toDouble();
        landmarks.add([x, y]);
      }
      
      // Check if we got valid landmarks (not all zeros)
      bool hasValidLandmarks = landmarks.any((l) => l[0] != 0 || l[1] != 0);
      
      if (!hasValidLandmarks) {
        print('⚠️ No valid landmarks detected');
        return _generateDummyLandmarks();
      }
      
      print('✅ Detected ${landmarks.length} valid landmarks');
      return landmarks;
      
    } catch (e) {
      print('❌ Hand detection error: $e');
      print('🔄 Falling back to dummy landmarks');
      return _generateDummyLandmarks();
    }
  }
  
  static List<List<List<List<double>>>> _imageToFloatArray(img.Image image) {
    final input = List.generate(
      1,
      (_) => List.generate(
        INPUT_SIZE,
        (_) => List.generate(
          INPUT_SIZE,
          (_) => List.filled(3, 0.0),
        ),
      ),
    );
    
    for (int y = 0; y < INPUT_SIZE; y++) {
      for (int x = 0; x < INPUT_SIZE; x++) {
        final pixel = image.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }
    
    return input;
  }
  
  static List<List<double>> _generateDummyLandmarks() {
    final landmarks = <List<double>>[];
    
    for (int i = 0; i < 21; i++) {
      double x, y;
      if (i == 0) {
        x = 0.4 + 0.2 * (i / 20);
        y = 0.7 + 0.1 * (i / 20);
      } else if (i <= 4) {
        final t = (i - 1) / 3;
        x = 0.15 + 0.35 * t;
        y = 0.3 + 0.2 * t;
      } else if (i <= 8) {
        final t = (i - 5) / 3;
        x = 0.35 + 0.05 * t;
        y = 0.2 + 0.15 * t;
      } else if (i <= 12) {
        final t = (i - 9) / 3;
        x = 0.5 + 0.05 * t;
        y = 0.15 + 0.15 * t;
      } else if (i <= 16) {
        final t = (i - 13) / 3;
        x = 0.6 + 0.05 * t;
        y = 0.25 + 0.15 * t;
      } else {
        final t = (i - 17) / 3;
        x = 0.7 + 0.05 * t;
        y = 0.35 + 0.15 * t;
      }
      landmarks.add([x.clamp(0, 1), y.clamp(0, 1)]);
    }
    
    return landmarks;
  }
  
  static List<double> landmarksToFeatures(List<List<double>> landmarks) {
    final features = <double>[];
    for (int i = 0; i < 21 && i < landmarks.length; i++) {
      features.add(landmarks[i][0]);
      features.add(landmarks[i][1]);
    }
    while (features.length < 42) features.add(0.0);
    return features;
  }
  
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
      print('❌ Alif classification error: $e');
      return 0.0;
    }
  }
  
  static Future<DetectionResult> predictFromImage(Uint8List imageBytes) async {
    if (!_isLoaded) await loadModels();
    
    print('=' * 50);
    print('🔍 Processing image...');
    print('   Hand Model: ${_handModelLoaded ? "✅" : "❌ (Dummy)"}');
    print('   Alif Model: ${_alifModelLoaded ? "✅" : "❌"}');
    
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
    
    print('📊 Final: isAlif=${prediction > 0.5}, confidence=${prediction.toStringAsFixed(3)}');
    print('=' * 50);
    
    return DetectionResult(
      hasHand: true,
      isAlif: prediction > 0.5,
      confidence: prediction,
      message: _handModelLoaded ? 'Real hand detected' : 'Dummy landmarks',
      featuresCount: features.length,
      landmarks: landmarks,
    );
  }
  
  static Future<DetectionResult> testWithDummy() async {
    await loadModels();
    final features = List.generate(42, (i) => i / 42.0);
    final prediction = await classifyAlif(features);
    
    return DetectionResult(
      hasHand: true,
      isAlif: prediction > 0.5,
      confidence: prediction,
      message: 'Dummy test',
      featuresCount: features.length,
      landmarks: _generateDummyLandmarks(),
    );
  }
  
  static Map<String, bool> getModelStatus() {
    return {
      'handModelLoaded': _handModelLoaded,
      'alifModelLoaded': _alifModelLoaded,
      'isLoaded': _isLoaded,
    };
  }
  
  static void close() {
    _handDetector?.close();
    _alifClassifier?.close();
    _isLoaded = false;
    _handModelLoaded = false;
    _alifModelLoaded = false;
    print('✅ Models closed');
  }
}

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