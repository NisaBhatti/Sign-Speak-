import 'dart:ui';
import 'package:google_mlkit_hand_detection/google_mlkit_hand_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class HandDetectorService {
  HandDetector? _handDetector;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize hand detector with options
      final options = HandDetectorOptions(
        mode: DetectionMode.single,  // or .multiple for multiple hands
        enableTracking: true,
      );
      
      _handDetector = HandDetector(options: options);
      _isInitialized = true;
    } catch (e) {
      print('Error initializing hand detector: $e');
      rethrow;
    }
  }

  Future<List<Offset>> detectHandLandmarks(InputImage inputImage) async {
    if (_handDetector == null) {
      await initialize();
    }

    try {
      // Process the image
      final List<Hand> hands = await _handDetector!.processImage(inputImage);
      
      if (hands.isEmpty) {
        return [];
      }

      // Get landmarks from the first hand
      final Hand hand = hands.first;
      final List<HandLandmark> landmarks = hand.landmarks;
      
      // Convert to Offset list
      return landmarks.map((landmark) {
        return Offset(landmark.x, landmark.y);
      }).toList();
      
    } catch (e) {
      print('Error detecting hand landmarks: $e');
      return [];
    }
  }

  // Helper method to convert CameraImage to InputImage
  Future<InputImage> convertCameraImageToInputImage(CameraImage image) async {
    // Implementation depends on your camera setup
    // You can use InputImage.fromBytes or InputImage.fromFilePath
    // For now, return a placeholder
    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        format: InputImageFormat.nv21,
        rotation: InputImageRotation.rotation0deg,
      ),
    );
  }

  Future<void> dispose() async {
    await _handDetector?.close();
    _handDetector = null;
    _isInitialized = false;
  }

  // Force reload MediaPipe (if needed)
  Future<bool> forceReloadMediaPipe() async {
    try {
      await _handDetector?.close();
      _isInitialized = false;
      await initialize();
      return true;
    } catch (e) {
      print('Error reloading MediaPipe: $e');
      return false;
    }
  }
}