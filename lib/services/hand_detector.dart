import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class HandDetector {
  static Interpreter? _interpreter;
  static bool _isLoaded = false;
  static const int INPUT_SIZE = 224;
  static const int NUM_LANDMARKS = 21;
  static const int OUTPUT_SIZE = 42;

  static Future<void> loadModel() async {
    if (_isLoaded) return;
    
    try {
      // Try to load hand detection model
      _interpreter = await Interpreter.fromAsset('assets/models/hand_detection.tflite');
      _isLoaded = true;
      print('✅ Hand detector loaded successfully!');
    } catch (e) {
      print('⚠️ Hand detector not found - using dummy landmarks');
      _isLoaded = false;
    }
  }

  /// Generate hand-like landmarks (for testing Alif model)
  static List<List<double>> generateHandLandmarks() {
    final landmarks = <List<double>>[];
    
    // Create a hand shape with 21 landmarks
    // 0: Wrist, 1-4: Thumb, 5-8: Index, 9-12: Middle, 13-16: Ring, 17-20: Pinky
    
    // Wrist
    landmarks.add([0.5, 0.75]);  // 0: Wrist
    
    // Thumb (curved)
    landmarks.add([0.4, 0.65]);  // 1: Thumb base
    landmarks.add([0.3, 0.55]);  // 2: Thumb middle
    landmarks.add([0.25, 0.45]); // 3: Thumb tip
    
    // Index finger
    landmarks.add([0.35, 0.40]); // 4: Index base
    landmarks.add([0.35, 0.30]); // 5: Index middle
    landmarks.add([0.35, 0.20]); // 6: Index tip
    
    // Middle finger (tallest)
    landmarks.add([0.50, 0.40]); // 7: Middle base
    landmarks.add([0.50, 0.25]); // 8: Middle middle
    landmarks.add([0.50, 0.15]); // 9: Middle tip
    
    // Ring finger
    landmarks.add([0.60, 0.42]); // 10: Ring base
    landmarks.add([0.60, 0.30]); // 11: Ring middle
    landmarks.add([0.60, 0.22]); // 12: Ring tip
    
    // Pinky finger
    landmarks.add([0.70, 0.45]); // 13: Pinky base
    landmarks.add([0.70, 0.38]); // 14: Pinky middle
    landmarks.add([0.70, 0.32]); // 15: Pinky tip
    
    // Fill remaining with dummy points
    while (landmarks.length < 21) {
      landmarks.add([0.5, 0.5]);
    }
    
    return landmarks;
  }

  static Future<List<List<double>>> detectHand(Uint8List imageBytes) async {
    // Always use dummy landmarks for now
    print('🔄 Using generated hand landmarks');
    return generateHandLandmarks();
  }

  static void close() {
    _interpreter?.close();
    _isLoaded = false;
  }
}