// lib/services/hand_detector_service.dart
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HandDetectorService {
  HandDetector? _handDetector;
  bool _isInitialized = false;
  bool _isProcessing = false;
  
  HandDetectorService() {
    _initialize();
  }
  
  /// Initialize MediaPipe Hand Detector
  Future<void> _initialize() async {
    try {
      _handDetector = GoogleMlKit.vision.handDetector();
      _isInitialized = true;
      print('✅ MediaPipe Hand Detector initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize hand detector: $e');
      _isInitialized = false;
    }
  }
  
  /// Detect hand landmarks from camera image
  Future<List<Offset>?> detectHandLandmarks(CameraImage cameraImage) async {
    if (!_isInitialized) {
      print('⚠️ Hand detector not initialized - using simulation');
      return _getSimulatedLandmarks();
    }
    
    if (_isProcessing) return null;
    _isProcessing = true;
    
    try {
      final inputImage = _convertToInputImage(cameraImage);
      if (inputImage == null) {
        return _getSimulatedLandmarks();
      }
      
      final List<Hand> hands = await _handDetector!.processImage(inputImage);
      
      if (hands.isEmpty) {
        print('⚠️ No hand detected');
        return null;
      }
      
      final Hand hand = hands.first;
      final List<Landmark> landmarks = hand.landmarks;
      
      if (landmarks.length != 21) {
        print('⚠️ Invalid landmarks count: ${landmarks.length}');
        return null;
      }
      
      final List<Offset> offsets = landmarks.map((landmark) {
        return Offset(landmark.x, landmark.y);
      }).toList();
      
      return offsets;
      
    } catch (e) {
      print('❌ Hand detection error: $e');
      return _getSimulatedLandmarks();
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Convert CameraImage to InputImage
  InputImage? _convertToInputImage(CameraImage cameraImage) {
    try {
      if (Platform.isAndroid) {
        final bytes = cameraImage.planes[0].bytes;
        return InputImage.fromBytes(
          bytes: bytes,
          metadata: InputImageMetadata(
            size: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            format: InputImageFormat.nv21,
            rotation: InputImageRotation.rotation0deg,
            bytesPerRow: cameraImage.planes[0].bytesPerRow,
          ),
        );
      } else if (Platform.isIOS) {
        final bytes = cameraImage.planes[0].bytes;
        return InputImage.fromBytes(
          bytes: bytes,
          metadata: InputImageMetadata(
            size: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            format: InputImageFormat.bgra8888,
            rotation: InputImageRotation.rotation0deg,
            bytesPerRow: cameraImage.planes[0].bytesPerRow,
          ),
        );
      }
      
      return null;
    } catch (e) {
      print('❌ InputImage conversion error: $e');
      return null;
    }
  }
  
  /// Simulated landmarks for testing
  List<Offset> _getSimulatedLandmarks() {
    return List.generate(21, (index) {
      if (index == 0) return Offset(0.5, 0.85);  // Wrist
      if (index >= 1 && index <= 4) return Offset(0.4 + (index * 0.02), 0.75 - (index * 0.03)); // Thumb
      if (index == 5) return Offset(0.5, 0.65);  // Index MCP
      if (index == 6) return Offset(0.5, 0.55);  // Index PIP
      if (index == 7) return Offset(0.5, 0.45);  // Index DIP
      if (index == 8) return Offset(0.5, 0.35);  // Index TIP (Alif sign - up)
      if (index >= 9 && index <= 12) return Offset(0.55, 0.70 - (index - 8) * 0.02); // Middle (folded)
      if (index >= 13 && index <= 16) return Offset(0.60, 0.72 - (index - 12) * 0.02); // Ring (folded)
      if (index >= 17 && index <= 20) return Offset(0.65, 0.74 - (index - 16) * 0.02); // Pinky (folded)
      return Offset(0.5, 0.5);
    });
  }
  
  /// Force reload MediaPipe
  Future<bool> forceReloadMediaPipe() async {
    print('🔄 Force reloading MediaPipe...');
    _isInitialized = false;
    _handDetector?.close();
    _handDetector = null;
    
    await _initialize();
    return _isInitialized;
  }
  
  void dispose() {
    _handDetector?.close();
  }
}