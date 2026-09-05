import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// Hand Detector - Detects 21 hand landmarks from an image
class HandDetector {
  static Interpreter? _interpreter;
  static bool _isLoaded = false;
  static const int INPUT_SIZE = 224;
  static const int NUM_LANDMARKS = 21;
  
  // ✅ FIX: Your model outputs 67 values (21 landmarks × 3 + 4 bbox)
  static const int OUTPUT_SIZE = 67;

  /// Load the hand detection TFLite model
  static Future<void> loadModel() async {
    if (_isLoaded) return;
    
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/hand_detection.tflite');
      _isLoaded = true;
      print('✅ Hand detector loaded successfully!');
      print('📊 Input shape: ${_interpreter!.getInputTensor(0).shape}');
      print('📊 Output shape: ${_interpreter!.getOutputTensor(0).shape}');
    } catch (e) {
      print('❌ Failed to load hand detector: $e');
      _isLoaded = false;
      rethrow;
    }
  }

  /// Process image and return 21 landmarks (x, y)
  static Future<List<List<double>>> detectHand(Uint8List imageBytes) async {
    if (!_isLoaded) {
      await loadModel();
    }
    if (_interpreter == null || !_isLoaded) {
      return [];
    }

    try {
      // 1. Decode image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        print('❌ Failed to decode image');
        return [];
      }

      // 2. Resize to 224x224
      final resized = img.copyResize(image, width: INPUT_SIZE, height: INPUT_SIZE);
      
      // 3. Convert to float array [1, 224, 224, 3]
      final input = _imageToFloatArray(resized);
      
      // 4. ✅ FIX: Output shape [1, 67]
      final output = List.generate(1, (_) => List.filled(OUTPUT_SIZE, 0.0));
      
      final stopwatch = Stopwatch()..start();
      _interpreter!.run(input, output);
      stopwatch.stop();
      
      print('⏱️ Detection time: ${stopwatch.elapsedMilliseconds}ms');
      
      // 5. ✅ FIX: Extract 21 landmarks (x, y) from 67 values
      // Your model outputs: [x1, y1, z1, x2, y2, z2, ..., x21, y21, z21, bbox_x, bbox_y, bbox_w, bbox_h]
      // OR: [x1, y1, x2, y2, ..., x21, y21, bbox_x, bbox_y, bbox_w, bbox_h]
      final landmarks = <List<double>>[];
      final raw = output[0] as List<dynamic>;
      
      print('📊 Raw output length: ${raw.length}');
      print('📊 First 10 values: ${raw.take(10).toList()}');
      
      // Try to extract landmarks - check if output has 3 values per landmark (x, y, z)
      // or 2 values per landmark (x, y)
      final hasZ = raw.length >= 21 * 3 + 4;
      final valuesPerLandmark = hasZ ? 3 : 2;
      
      for (int i = 0; i < NUM_LANDMARKS; i++) {
        final idx = i * valuesPerLandmark;
        if (idx + 1 < raw.length) {
          final x = (raw[idx] as num).toDouble();
          final y = (raw[idx + 1] as num).toDouble();
          landmarks.add([x, y]);
        }
      }
      
      // Check if hand detected (not all zeros)
      final hasHand = landmarks.any((l) => l[0] != 0 || l[1] != 0);
      
      if (!hasHand) {
        print('❌ No hand detected (all landmarks zero)');
        return [];
      }
      
      print('✅ Detected ${landmarks.length} landmarks');
      print('📍 First landmark: (${landmarks[0][0].toStringAsFixed(3)}, ${landmarks[0][1].toStringAsFixed(3)})');
      print('📍 Last landmark: (${landmarks[20][0].toStringAsFixed(3)}, ${landmarks[20][1].toStringAsFixed(3)})');
      
      return landmarks;
      
    } catch (e) {
      print('❌ Detection error: $e');
      return [];
    }
  }

  /// Convert image to float array [1, 224, 224, 3]
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

  /// Close the model
  static void close() {
    _interpreter?.close();
    _isLoaded = false;
  }
}