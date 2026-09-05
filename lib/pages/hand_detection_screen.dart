import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../services/hand_detector.dart';
import '../services/alif_classifier.dart';

/// Main Screen - Like your Python script but in Flutter
class HandDetectionScreen extends StatefulWidget {
  const HandDetectionScreen({Key? key}) : super(key: key);

  @override
  State<HandDetectionScreen> createState() => _HandDetectionScreenState();
}

class _HandDetectionScreenState extends State<HandDetectionScreen> {
  CameraController? _controller;
  AlifResult _result = AlifResult.empty();
  bool _isProcessing = false;
  bool _isReady = false;
  int _frameCount = 0;
  double _fps = 0.0;
  DateTime _lastFpsUpdate = DateTime.now();
  List<List<double>> _landmarks = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Load both models (like Python script)
      await HandDetector.loadModel();
      await AlifClassifier.loadModel();
      _isReady = true;
      
      setState(() {});
      
      // Initialize camera
      await _initializeCamera();
    } catch (e) {
      print('❌ Initialization error: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras[0],
      );
      
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      
      await _controller!.initialize();
      
      if (mounted) {
        setState(() {});
        _controller!.startImageStream(_processCameraImage);
      }
    } catch (e) {
      print('❌ Camera error: $e');
    }
  }

  // ============================================
  // CONVERT CAMERA IMAGE TO BYTES
  // ============================================
  Future<Uint8List?> _convertCameraImageToBytes(CameraImage image) async {
    try {
      final width = image.width;
      final height = image.height;
      
      Uint8List rgbBytes = Uint8List(width * height * 3);
      
      if (image.format.group == ImageFormatGroup.yuv420) {
        final yPlane = image.planes[0];
        final uPlane = image.planes[1];
        final vPlane = image.planes[2];
        
        int rgbIndex = 0;
        
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            final yValue = yPlane.bytes[y * yPlane.bytesPerRow + x] & 0xFF;
            final uvX = x ~/ 2;
            final uvY = y ~/ 2;
            final uValue = uPlane.bytes[uvY * uPlane.bytesPerRow + uvX] & 0xFF;
            final vValue = vPlane.bytes[uvY * vPlane.bytesPerRow + uvX] & 0xFF;
            
            int r = (yValue + 1.402 * (vValue - 128)).round();
            int g = (yValue - 0.344 * (uValue - 128) - 0.714 * (vValue - 128)).round();
            int b = (yValue + 1.772 * (uValue - 128)).round();
            
            rgbBytes[rgbIndex++] = r.clamp(0, 255).toInt();
            rgbBytes[rgbIndex++] = g.clamp(0, 255).toInt();
            rgbBytes[rgbIndex++] = b.clamp(0, 255).toInt();
          }
        }
        
        final imgImage = img.Image.fromBytes(
          width: width,
          height: height,
          bytes: rgbBytes.buffer,
          numChannels: 3,
        );
        
        final jpegBytes = img.encodeJpg(imgImage);
        return Uint8List.fromList(jpegBytes);
      }
      
      return null;
      
    } catch (e) {
      print('❌ Image conversion error: $e');
      return null;
    }
  }

  // ============================================
  // PROCESS CAMERA IMAGE (Like Python's while loop)
  // ============================================
  void _processCameraImage(CameraImage image) {
    if (_isProcessing || !_isReady) return;
    _isProcessing = true;
    
    // Calculate FPS
    _frameCount++;
    final now = DateTime.now();
    if (now.difference(_lastFpsUpdate) > const Duration(seconds: 1)) {
      _fps = _frameCount.toDouble();
      _frameCount = 0;
      _lastFpsUpdate = now;
      if (mounted) setState(() {});
    }
    
    _convertCameraImageToBytes(image).then((jpegBytes) async {
      if (jpegBytes != null && mounted) {
        try {
          // Step 1: Detect hand landmarks (like MediaPipe)
          final landmarks = await HandDetector.detectHand(jpegBytes);
          
          if (landmarks.isEmpty) {
            setState(() {
              _result = AlifResult.empty();
              _landmarks = [];
            });
            _isProcessing = false;
            return;
          }
          
          // Step 2: Classify ALIF (like your Python model)
          final result = await AlifClassifier.classify(landmarks);
          
          if (mounted) {
            setState(() {
              _result = result;
              _landmarks = landmarks;
            });
          }
          
        } catch (e) {
          print('❌ Processing error: $e');
        }
      }
      _isProcessing = false;
    }).catchError((e) {
      print('❌ Conversion error: $e');
      _isProcessing = false;
    });
  }

  // ============================================
  // DRAW HAND LANDMARKS (Like MediaPipe's draw_landmarks)
  // ============================================
  Widget _buildHandOverlay() {
    if (_landmarks.isEmpty || !_result.hasHand) {
      return Container();
    }
    
    return CustomPaint(
      painter: HandLandmarkPainter(
        landmarks: _landmarks,
        isAlif: _result.isAlif,
        viewWidth: MediaQuery.of(context).size.width,
        viewHeight: MediaQuery.of(context).size.height,
      ),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    HandDetector.close();
    AlifClassifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isReady ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _isReady ? '✅ Ready' : '⏳ Loading',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview (like cv2.imshow)
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),
          
          // Hand Landmarks (like mp_drawing.draw_landmarks)
          _buildHandOverlay(),
          
          // Status Bar (like cv2.putText)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    _result.label,
                    style: TextStyle(
                      color: _result.hasHand
                          ? (_result.isAlif ? Colors.green : Colors.red)
                          : Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'FPS: ${_fps.toStringAsFixed(1)} | Landmarks: ${_landmarks.length}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom info (like Python's "Show your hand to camera")
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _result.hasHand
                    ? '✅ Hand detected - ${_landmarks.length} landmarks'
                    : '👋 Show your hand to camera',
                style: TextStyle(
                  color: _result.hasHand ? Colors.green : Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// HAND LANDMARK PAINTER (Like MediaPipe's draw_landmarks)
// ============================================
class HandLandmarkPainter extends CustomPainter {
  final List<List<double>> landmarks;
  final bool isAlif;
  final double viewWidth;
  final double viewHeight;

  HandLandmarkPainter({
    required this.landmarks,
    required this.isAlif,
    required this.viewWidth,
    required this.viewHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;

    // Colors (like MediaPipe styling)
    final color = isAlif ? Colors.green : Colors.red;
    
    final paintLines = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final paintPoints = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final paintWrist = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Hand connections (MediaPipe HAND_CONNECTIONS)
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4],
      [0, 5], [5, 6], [6, 7], [7, 8],
      [0, 9], [9, 10], [10, 11], [11, 12],
      [0, 13], [13, 14], [14, 15], [15, 16],
      [0, 17], [17, 18], [18, 19], [19, 20],
    ];

    // Draw connections (like MediaPipe)
    for (var connection in connections) {
      if (connection[0] < landmarks.length && connection[1] < landmarks.length) {
        final p1 = landmarks[connection[0]];
        final p2 = landmarks[connection[1]];
        
        if (p1.length >= 2 && p2.length >= 2) {
          final x1 = p1[0] * viewWidth;
          final y1 = p1[1] * viewHeight;
          final x2 = p2[0] * viewWidth;
          final y2 = p2[1] * viewHeight;
          
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paintLines);
        }
      }
    }

    // Draw landmarks (like MediaPipe)
    for (int i = 0; i < landmarks.length && i < 21; i++) {
      final landmark = landmarks[i];
      if (landmark.length >= 2) {
        final x = landmark[0] * viewWidth;
        final y = landmark[1] * viewHeight;
        
        final paint = i == 0 ? paintWrist : paintPoints;
        canvas.drawCircle(Offset(x, y), 6, paint);
      }
    }

    // Draw bounding box (like cv2.rectangle)
    _drawBoundingBox(canvas);
  }

  void _drawBoundingBox(Canvas canvas) {
    if (landmarks.isEmpty) return;

    // Calculate bounding box
    double minX = 1.0, minY = 1.0, maxX = 0.0, maxY = 0.0;
    
    for (var landmark in landmarks) {
      if (landmark.length >= 2) {
        if (landmark[0] < minX) minX = landmark[0];
        if (landmark[1] < minY) minY = landmark[1];
        if (landmark[0] > maxX) maxX = landmark[0];
        if (landmark[1] > maxY) maxY = landmark[1];
      }
    }
    
    // Add padding
    final paddingX = (maxX - minX) * 0.15;
    final paddingY = (maxY - minY) * 0.15;
    
    minX = (minX - paddingX).clamp(0.0, 1.0);
    minY = (minY - paddingY).clamp(0.0, 1.0);
    maxX = (maxX + paddingX).clamp(0.0, 1.0);
    maxY = (maxY + paddingY).clamp(0.0, 1.0);
    
    final rect = Rect.fromLTRB(
      minX * viewWidth,
      minY * viewHeight,
      maxX * viewWidth,
      maxY * viewHeight,
    );

    // Draw rectangle
    final borderPaint = Paint()
      ..color = isAlif ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}