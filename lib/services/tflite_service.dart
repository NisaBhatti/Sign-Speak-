import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  static Interpreter? _handLandmarker;
  static Interpreter? _alifClassifier;
  static bool _isLoaded = false;
  
  static Future<void> loadModels() async {
    if (_isLoaded) return;
    
    try {
      // Check if hand landmarker exists
      bool handExists = false;
      try {
        await Interpreter.fromAsset('assets/models/hand_landmarker.tflite');
        handExists = true;
      } catch (e) {
        print('⚠️ hand_landmarker.tflite not found');
      }
      
      if (handExists) {
        print('🔄 Loading hand landmarker...');
        _handLandmarker = await Interpreter.fromAsset('assets/models/hand_landmarker.tflite');
        print('✅ Hand landmarker loaded!');
        
        if (_handLandmarker != null) {
          print('📊 Hand Input shape: ${_handLandmarker!.getInputTensor(0).shape}');
          print('📊 Hand Output shape: ${_handLandmarker!.getOutputTensor(0).shape}');
        }
      } else {
        print('⚠️ Hand landmarker not available - using dummy landmarks');
      }
      
      print('🔄 Loading Alif classifier...');
      _alifClassifier = await Interpreter.fromAsset('assets/models/alif_robust.tflite');
      print('✅ Alif classifier loaded!');
      
      if (_alifClassifier != null) {
        print('📊 Alif Input shape: ${_alifClassifier!.getInputTensor(0).shape}');
        print('📊 Alif Output shape: ${_alifClassifier!.getOutputTensor(0).shape}');
      }
      
      _isLoaded = true;
    } catch (e) {
      print('❌ Failed to load models: $e');
      _isLoaded = false;
    }
  }
  
  // ============================================
  // DETECT HAND LANDMARKS (WITH FALLBACK)
  // ============================================
  static Future<List<List<double>>> detectHandLandmarks(Uint8List imageBytes) async {
    // If hand landmarker is not loaded, use dummy landmarks
    if (_handLandmarker == null) {
      print('⚠️ Using dummy landmarks (hand landmarker not loaded)');
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
      
      final resized = img.copyResize(image, width: 224, height: 224);
      print('📷 Resized: ${resized.width}x${resized.height}');
      
      final input = _imageToFloatArray(resized);
      
      final outputShape = _handLandmarker!.getOutputTensor(0).shape;
      print('📊 Output shape: $outputShape');
      
      final output = List.generate(
        1, 
        (_) => List.filled(21 * 3, 0.0)
      );
      
      print('🔄 Running inference...');
      _handLandmarker!.run(input, output);
      
      final landmarks = <List<double>>[];
      final raw = output[0] as List<dynamic>;
      
      print('📊 Raw output length: ${raw.length}');
      
      bool hasLandmarks = false;
      for (int i = 0; i < 21 && i * 3 + 1 < raw.length; i++) {
        final x = (raw[i * 3] as num).toDouble();
        final y = (raw[i * 3 + 1] as num).toDouble();
        landmarks.add([x, y]);
        
        if (x != 0 || y != 0) {
          hasLandmarks = true;
        }
      }
      
      if (!hasLandmarks) {
        print('⚠️ No valid landmarks detected - using dummy');
        return _generateDummyLandmarks();
      }
      
      print('✅ Detected ${landmarks.length} landmarks');
      return landmarks;
      
    } catch (e) {
      print('❌ Hand detection error: $e');
      print('⚠️ Using dummy landmarks as fallback');
      return _generateDummyLandmarks();
    }
  }
  
  // ============================================
  // GENERATE DUMMY LANDMARKS FOR TESTING
  // ============================================
  static List<List<double>> _generateDummyLandmarks() {
    print('🔄 Generating dummy landmarks for testing');
    final landmarks = <List<double>>[];
    
    // Generate 21 landmarks in a circular pattern
    for (int i = 0; i < 21; i++) {
      final angle = (i / 21) * 2 * 3.14159;
      final x = 0.5 + 0.4 * (i / 20);  // Spread from left to right
      final y = 0.3 + 0.3 * (i / 20);  // Spread from top to bottom
      landmarks.add([x, y]);
    }
    
    return landmarks;
  }
  
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
    if (_alifClassifier == null || !_isLoaded) {
      await loadModels();
    }
    if (_alifClassifier == null) return 0.0;
    
    try {
      final input = features.map((e) => e.toDouble()).toList();
      final output = List.filled(1, 0.0);
      _alifClassifier!.run(input, output);
      return output[0];
    } catch (e) {
      print('❌ Alif error: $e');
      return 0.0;
    }
  }
  
  static Future<DetectionResult> predictFromImage(Uint8List imageBytes) async {
    if (!_isLoaded) await loadModels();
    
    print('=' * 50);
    print('🔍 Processing image...');
    
    final landmarks = await detectHandLandmarks(imageBytes);
    
    if (landmarks.isEmpty) {
      return DetectionResult(
        hasHand: false,
        isAlif: false,
        confidence: 0.0,
        message: 'No hand detected',
      );
    }
    
    final features = landmarksToFeatures(landmarks);
    final prediction = await classifyAlif(features);
    
    print('📊 Final: isAlif=${prediction > 0.5}, confidence=$prediction');
    print('=' * 50);
    
    return DetectionResult(
      hasHand: true,
      isAlif: prediction > 0.5,
      confidence: prediction,
      message: 'Landmarks: ${landmarks.length}',
      featuresCount: features.length,
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
    );
  }
  
  static void close() {
    _handLandmarker?.close();
    _alifClassifier?.close();
    _isLoaded = false;
  }
}

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