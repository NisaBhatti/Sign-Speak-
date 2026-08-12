// lib/services/hand_detector_service.dart
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HandDetectorService {
  final HandDetector _handDetector;
  bool _isProcessing = false;
  
  HandDetectorService() : _handDetector = GoogleMlKit.vision.handDetector();
  
  /// Detects hand landmarks from camera image
  Future<List<Offset>?> detectHandLandmarks(CameraImage cameraImage) async {
    if (_isProcessing) return null;
    
    _isProcessing = true;
    
    try {
      // Convert CameraImage to InputImage
      final inputImage = _convertToInputImage(cameraImage);
      if (inputImage == null) return null;
      
      // Detect hands
      final List<Hand> hands = await _handDetector.processImage(inputImage);
      
      if (hands.isEmpty) return null;
      
      // Get first hand's landmarks
      final hand = hands.first;
      final landmarks = hand.landmarks;
      
      if (landmarks.length < 21) return null;
      
      // Convert to Offset list (21 landmarks)
      return landmarks.map((landmark) {
        return Offset(landmark.x, landmark.y);
      }).toList();
      
    } catch (e) {
      print('❌ Hand detection error: $e');
      return null;
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Convert CameraImage to InputImage for MediaPipe
  InputImage? _convertToInputImage(CameraImage cameraImage) {
    try {
      // For Android
      if (Platform.isAndroid) {
        return InputImage.fromByteArray(
          bytes: cameraImage.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            format: InputImageFormat.nv21,
            rotation: InputImageRotation.rotation0deg,
            bytesPerRow: cameraImage.planes[0].bytesPerRow,
            width: cameraImage.width,
            height: cameraImage.height,
          ),
        );
      } 
      // For iOS
      else if (Platform.isIOS) {
        // iOS implementation
        return InputImage.fromByteArray(
          bytes: cameraImage.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            format: InputImageFormat.bgra8888,
            rotation: InputImageRotation.rotation0deg,
            bytesPerRow: cameraImage.planes[0].bytesPerRow,
            width: cameraImage.width,
            height: cameraImage.height,
          ),
        );
      }
      
      return null;
    } catch (e) {
      print('❌ InputImage conversion error: $e');
      return null;
    }
  }
  
  /// Get simulated landmarks for testing
  List<Offset> _getSimulatedLandmarks() {
    // Simulate Alif sign: index finger up, others folded
    List<Offset> landmarks = List.generate(21, (index) {
      // Index finger tip (landmark 8)
      if (index == 8) {
        return Offset(0.5, 0.3); // Higher position (finger up)
      } 
      // Other finger tips (landmarks 12, 16, 20)
      else if (index == 12 || index == 16 || index == 20) {
        return Offset(0.5, 0.7); // Lower position (folded)
      } 
      // Finger bases
      else if (index == 5 || index == 9 || index == 13 || index == 17) {
        return Offset(0.5, 0.45);
      }
      // Wrist
      else if (index == 0) {
        return Offset(0.5, 0.8);
      }
      // Other landmarks
      else {
        return Offset(0.5, 0.5);
      }
    });
    return landmarks;
  }
  
  /// For testing without actual camera
  Future<List<Offset>?> getSimulatedLandmarks() async {
    await Future.delayed(Duration(milliseconds: 100));
    return _getSimulatedLandmarks();
  }
  
  void dispose() {
    _handDetector.close();
  }
}