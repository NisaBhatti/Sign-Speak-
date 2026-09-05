import 'package:tflite_flutter/tflite_flutter.dart';

/// Alif Classifier - Takes 42 features (21 landmarks × 2) and returns ALIF/Not ALIF
class AlifClassifier {
  static Interpreter? _interpreter;
  static bool _isLoaded = false;

  /// Load the Alif classification TFLite model
  static Future<void> loadModel() async {
    if (_isLoaded) return;
    
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/alif_robust.tflite');
      _isLoaded = true;
      print('✅ Alif classifier loaded successfully!');
      print('📊 Input shape: ${_interpreter!.getInputTensor(0).shape}');
      print('📊 Output shape: ${_interpreter!.getOutputTensor(0).shape}');
    } catch (e) {
      print('❌ Failed to load Alif classifier: $e');
      _isLoaded = false;
      rethrow;
    }
  }

  /// Convert 21 landmarks to 42 features (like Python script)
  static List<double> landmarksToFeatures(List<List<double>> landmarks) {
    final features = <double>[];
    for (int i = 0; i < 21 && i < landmarks.length; i++) {
      features.add(landmarks[i][0]); // x
      features.add(landmarks[i][1]); // y
    }
    // Pad if less than 21 landmarks
    while (features.length < 42) {
      features.add(0.0);
    }
    return features;
  }

  /// Predict ALIF from 42 features
  static Future<double> predict(List<double> features) async {
    if (!_isLoaded) {
      await loadModel();
    }
    if (_interpreter == null || !_isLoaded) {
      return 0.0;
    }

    try {
      final input = features.map((e) => e.toDouble()).toList();
      final output = List.generate(1, (_) => List.filled(1, 0.0));
      
      _interpreter!.run(input, output);
      
      return output[0][0];
    } catch (e) {
      print('❌ Prediction error: $e');
      return 0.0;
    }
  }

  /// Complete classification: landmarks → features → prediction
  static Future<AlifResult> classify(List<List<double>> landmarks) async {
    if (landmarks.isEmpty) {
      return AlifResult(
        isAlif: false,
        confidence: 0.0,
        hasHand: false,
        landmarks: [],
      );
    }

    final features = landmarksToFeatures(landmarks);
    final prediction = await predict(features);
    final isAlif = prediction > 0.5;

    return AlifResult(
      isAlif: isAlif,
      confidence: prediction,
      hasHand: true,
      landmarks: landmarks,
    );
  }

  /// Close the model
  static void close() {
    _interpreter?.close();
    _isLoaded = false;
  }
}

/// Result class (like Python's return)
class AlifResult {
  final bool isAlif;
  final double confidence;
  final bool hasHand;
  final List<List<double>> landmarks;

  AlifResult({
    required this.isAlif,
    required this.confidence,
    required this.hasHand,
    required this.landmarks,
  });

  AlifResult.empty()
      : isAlif = false,
        confidence = 0.0,
        hasHand = false,
        landmarks = [];

  String get label {
    if (!hasHand) return '👋 No Hand';
    return isAlif ? '✅ ALIF (ا) - ${(confidence * 100).toStringAsFixed(1)}%' 
                   : '❌ Not Alif - ${(confidence * 100).toStringAsFixed(1)}%';
  }
}