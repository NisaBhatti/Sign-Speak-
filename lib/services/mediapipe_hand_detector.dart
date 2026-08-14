import 'dart:ui';
import 'dart:typed_data';
import 'package:mediapipe/mediapipe.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class MediaPipeHandDetector {
  static final MediaPipeHandDetector _instance = MediaPipeHandDetector._internal();
  factory MediaPipeHandDetector() => _instance;
  MediaPipeHandDetector._internal();

  HandLandmarkDetector? _detector;
  bool _isInitialized = false;
  
  // Cache for landmarks
  List<List<Offset>> _landmarks = [];
  
  // Callback for detection results
  Function(List<List<Offset>> landmarks)? onDetection;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize MediaPipe Hand Landmark Detector
      final options = HandLandmarkDetectorOptions(
        modelAssetPath: 'assets/models/hand_landmark.task', // You'll need this model file
        numHands: 2,
        minDetectionConfidence: 0.5,
        minTrackingConfidence: 0.5,
      );
      
      _detector = await HandLandmarkDetector.create(options: options);
      _isInitialized = true;
      
      print('MediaPipe Hand Detector initialized successfully!');
    } catch (e) {
      print('Error initializing MediaPipe: $e');
      rethrow;
    }
  }

  Future<List<List<Offset>>> detectHandLandmarks(CameraImage cameraImage) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Convert CameraImage to Image
      final image = _convertCameraImageToImage(cameraImage);
      if (image == null) return [];

      // Run detection
      final results = await _detector?.detect(
        image,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      if (results == null || results.isEmpty) {
        _landmarks = [];
        return [];
      }

      // Extract landmarks
      final detectedLandmarks = <List<Offset>>[];
      
      for (final result in results) {
        final landmarks = result.landmarks;
        final normalizedLandmarks = landmarks.map((point) {
          return Offset(
            point.x, // Normalized x (0-1)
            point.y, // Normalized y (0-1)
          );
        }).toList();
        
        detectedLandmarks.add(normalizedLandmarks);
      }

      _landmarks = detectedLandmarks;
      
      // Callback if set
      onDetection?.call(_landmarks);
      
      return _landmarks;
      
    } catch (e) {
      print('Error detecting hand landmarks: $e');
      return [];
    }
  }

  // Convert CameraImage to img.Image
  img.Image? _convertCameraImageToImage(CameraImage cameraImage) {
    try {
      // Get image dimensions
      final width = cameraImage.width;
      final height = cameraImage.height;
      
      // For YUV_420_888 format (most common with CameraX)
      if (cameraImage.format.group == ImageFormatGroup.yuv420) {
        final yuv = _convertYUV420ToImage(cameraImage);
        return yuv;
      }
      
      // For other formats, try to convert
      return _convertOtherFormat(cameraImage);
      
    } catch (e) {
      print('Error converting camera image: $e');
      return null;
    }
  }

  // Convert YUV420 to RGB
  img.Image? _convertYUV420ToImage(CameraImage cameraImage) {
    try {
      final width = cameraImage.width;
      final height = cameraImage.height;
      
      // Extract YUV planes
      final yPlane = cameraImage.planes[0];
      final uPlane = cameraImage.planes[1];
      final vPlane = cameraImage.planes[2];
      
      final yBytes = yPlane.bytes;
      final uBytes = uPlane.bytes;
      final vBytes = vPlane.bytes;
      
      // Create image
      final image = img.Image(width: width, height: height);
      
      // Convert YUV to RGB
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final yIndex = y * yPlane.bytesPerRow + x;
          final uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2) * 2;
          
          final yValue = yBytes[yIndex] & 0xFF;
          final uValue = uBytes[uvIndex] & 0xFF;
          final vValue = vBytes[uvIndex] & 0xFF;
          
          // YUV to RGB conversion
          final r = (yValue + 1.402 * (vValue - 128)).toInt().clamp(0, 255);
          final g = (yValue - 0.344 * (uValue - 128) - 0.714 * (vValue - 128)).toInt().clamp(0, 255);
          final b = (yValue + 1.772 * (uValue - 128)).toInt().clamp(0, 255);
          
          image.setPixelRgb(x, y, r, g, b);
        }
      }
      
      return image;
      
    } catch (e) {
      print('Error converting YUV420: $e');
      return null;
    }
  }

  img.Image? _convertOtherFormat(CameraImage cameraImage) {
    // For RGB or other formats
    try {
      final width = cameraImage.width;
      final height = cameraImage.height;
      final image = img.Image(width: width, height: height);
      
      // Try to parse as RGB
      if (cameraImage.planes.length == 1) {
        final bytes = cameraImage.planes[0].bytes;
        for (int i = 0; i < bytes.length && i < width * height * 3; i += 3) {
          final x = (i ~/ 3) % width;
          final y = (i ~/ 3) ~/ width;
          if (y < height) {
            image.setPixelRgb(x, y, bytes[i], bytes[i + 1], bytes[i + 2]);
          }
        }
        return image;
      }
      
      return null;
      
    } catch (e) {
      print('Error converting other format: $e');
      return null;
    }
  }

  List<List<Offset>> get currentLandmarks => _landmarks;

  bool get isInitialized => _isInitialized;

  Future<void> dispose() async {
    await _detector?.close();
    _detector = null;
    _isInitialized = false;
    _landmarks = [];
  }

  // Force reload MediaPipe
  Future<bool> forceReload() async {
    try {
      await dispose();
      await initialize();
      return true;
    } catch (e) {
      print('Error reloading MediaPipe: $e');
      return false;
    }
  }
}