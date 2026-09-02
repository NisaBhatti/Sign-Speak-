import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../services/tflite_service.dart';

class RealtimeDetectionPage extends StatefulWidget {
  const RealtimeDetectionPage({Key? key}) : super(key: key);

  @override
  State<RealtimeDetectionPage> createState() => _RealtimeDetectionPageState();
}

class _RealtimeDetectionPageState extends State<RealtimeDetectionPage> {
  CameraController? _controller;
  DetectionResult _result = DetectionResult.empty();
  bool _isProcessing = false;
  bool _isModelLoaded = false;
  int _frameCount = 0;
  double _fps = 0.0;
  DateTime _lastFpsUpdate = DateTime.now();
  List<List<double>> _landmarks = [];
  
  // Model status
  bool _handModelLoaded = false;
  bool _alifModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Load models
    await TFLiteService.loadModels();
    
    // Get model status
    final status = TFLiteService.getModelStatus();
    _handModelLoaded = status['handModelLoaded'] ?? false;
    _alifModelLoaded = status['alifModelLoaded'] ?? false;
    _isModelLoaded = true;
    
    setState(() {});
    await _initializeCamera();
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
      print('Error initializing camera: $e');
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
  // PROCESS CAMERA IMAGE
  // ============================================
  void _processCameraImage(CameraImage image) {
    if (_isProcessing || !_isModelLoaded) return;
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
    
    _convertCameraImageToBytes(image).then((jpegBytes) {
      if (jpegBytes != null && mounted) {
        TFLiteService.predictFromImage(jpegBytes).then((result) {
          if (mounted) {
            setState(() {
              _result = result;
              _landmarks = result.landmarks;
            });
          }
          _isProcessing = false;
        }).catchError((e) {
          print('❌ Prediction error: $e');
          _isProcessing = false;
        });
      } else {
        _isProcessing = false;
      }
    }).catchError((e) {
      print('❌ Conversion error: $e');
      _isProcessing = false;
    });
  }

  // ============================================
  // DRAW LANDMARK OVERLAY
  // ============================================
  Widget _buildLandmarkOverlay() {
    if (_landmarks.isEmpty || !_result.hasHand) {
      return Container();
    }
    
    return CustomPaint(
      painter: LandmarkPainter(
        landmarks: _landmarks,
        viewWidth: MediaQuery.of(context).size.width,
        viewHeight: MediaQuery.of(context).size.height,
      ),
      size: Size.infinite,
    );
  }

  // ============================================
  // MODEL STATUS INDICATOR
  // ============================================
  Widget _buildModelStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (_handModelLoaded && _alifModelLoaded) ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            (_handModelLoaded && _alifModelLoaded) ? Icons.check_circle : Icons.warning,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            _handModelLoaded ? '✅ Hand' : '📌 Dummy',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          const SizedBox(width: 4),
          Text(
            _alifModelLoaded ? '✅ Alif' : '❌ Alif',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    TFLiteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          _buildModelStatus(),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),
          
          // Landmark Overlay
          _buildLandmarkOverlay(),
          
          // Status Bar (Top)
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _result.hasHand 
                        ? (_result.isAlif ? Icons.check_circle : Icons.cancel)
                        : Icons.handshake,
                    color: _result.hasHand 
                        ? (_result.isAlif ? Colors.green : Colors.red)
                        : Colors.grey,
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    _result.hasHand
                        ? (_result.isAlif 
                          ? '✅ ALIF ${(_result.confidence * 100).toStringAsFixed(0)}%'
                          : '❌ Not Alif ${(_result.confidence * 100).toStringAsFixed(0)}%')
                        : '👋 Show your hand',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Info
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
              child: Column(
                children: [
                  Text(
                    _result.message.isNotEmpty ? _result.message : 'Processing...',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'FPS: ${_fps.toStringAsFixed(1)} | Landmarks: ${_landmarks.length}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  if (_landmarks.isNotEmpty)
                    const Text(
                      '✅ Hand tracking active!',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (!_handModelLoaded && _landmarks.isNotEmpty)
                    const Text(
                      '📌 Using dummy landmarks (model not loaded)',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// LANDMARK PAINTER
// ============================================
class LandmarkPainter extends CustomPainter {
  final List<List<double>> landmarks;
  final double viewWidth;
  final double viewHeight;

  LandmarkPainter({
    required this.landmarks,
    required this.viewWidth,
    required this.viewHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;

    final paintLines = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final paintPoints = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final paintWrist = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Hand connections (same as MediaPipe)
    final connections = [
      // Thumb
      [0, 1], [1, 2], [2, 3], [3, 4],
      // Index
      [0, 5], [5, 6], [6, 7], [7, 8],
      // Middle
      [0, 9], [9, 10], [10, 11], [11, 12],
      // Ring
      [0, 13], [13, 14], [14, 15], [15, 16],
      // Pinky
      [0, 17], [17, 18], [18, 19], [19, 20],
    ];

    // Draw connections
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

    // Draw points
    for (int i = 0; i < landmarks.length && i < 21; i++) {
      final landmark = landmarks[i];
      if (landmark.length >= 2) {
        final x = landmark[0] * viewWidth;
        final y = landmark[1] * viewHeight;
        
        // Wrist (point 0) is red, others are green
        final paint = i == 0 ? paintWrist : paintPoints;
        
        // Draw circle
        canvas.drawCircle(Offset(x, y), 6, paint);
        
        // Draw index number
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$i',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x + 8, y - 8));
      }
    }

    // Draw legend
    _drawLegend(canvas);
  }

  void _drawLegend(Canvas canvas) {
    final legendPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Legend background
    final rect = Rect.fromLTWH(10, 10, 120, 60);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      legendPaint,
    );

    // Legend text
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );

    // Green dot
    canvas.drawCircle(const Offset(25, 25), 5, Paint()..color = Colors.green);
    _drawText(canvas, "Landmarks", const Offset(40, 28), textStyle);

    // Red dot
    canvas.drawCircle(const Offset(25, 45), 5, Paint()..color = Colors.red);
    _drawText(canvas, "Wrist", const Offset(40, 48), textStyle);

    // Yellow line
    canvas.drawLine(
      const Offset(20, 60),
      const Offset(30, 60),
      Paint()..color = Colors.yellow..strokeWidth = 2,
    );
    _drawText(canvas, "Connections", const Offset(40, 63), textStyle);
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}