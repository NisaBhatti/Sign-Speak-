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
  bool _handModelLoaded = false;
  bool _alifModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await TFLiteService.loadModels();
    
    final status = TFLiteService.getModelStatus();
    _handModelLoaded = status['handModelLoaded'] ?? false;
    _alifModelLoaded = status['alifModelLoaded'] ?? false;
    _isModelLoaded = true;
    
    print('📊 Hand Model: ${_handModelLoaded ? "✅ LOADED" : "❌ NOT LOADED"}');
    print('📊 Alif Model: ${_alifModelLoaded ? "✅ LOADED" : "❌ NOT LOADED"}');
    
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
      print('❌ Error initializing camera: $e');
    }
  }

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

  void _processCameraImage(CameraImage image) {
    if (_isProcessing || !_isModelLoaded) return;
    _isProcessing = true;
    
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
  // ✅ DRAW RECTANGLE AROUND HAND (NO DUMMY)
  // ============================================
  Widget _buildHandOverlay() {
    // Only show if hand is detected AND we have real landmarks
    if (!_result.hasHand || _landmarks.isEmpty || !_handModelLoaded) {
      return Container();
    }
    
    return CustomPaint(
      painter: HandRectanglePainter(
        landmarks: _landmarks,
        isAlif: _result.isAlif,
        confidence: _result.confidence,
        viewWidth: MediaQuery.of(context).size.width,
        viewHeight: MediaQuery.of(context).size.height,
      ),
      size: Size.infinite,
    );
  }

  Widget _buildModelStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            _handModelLoaded ? 'Hand✅' : 'Hand❌',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          const SizedBox(width: 2),
          Text(
            _alifModelLoaded ? 'Alif✅' : 'Alif❌',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Alif Detection'),
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
          
          // ✅ Hand Rectangle Overlay (NO DUMMY)
          _buildHandOverlay(),
          
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
                    _result.hasHand 
                        ? '✅ Hand Detected (${_landmarks.length} landmarks)' 
                        : '👋 No hand detected',
                    style: TextStyle(
                      color: _result.hasHand ? Colors.green : Colors.white70,
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
                  if (!_handModelLoaded && _result.hasHand)
                    const Text(
                      '⚠️ Using dummy landmarks - train model for real detection',
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
// ✅ CUSTOM PAINTER: RECTANGLE AROUND HAND
// ============================================
class HandRectanglePainter extends CustomPainter {
  final List<List<double>> landmarks;
  final bool isAlif;
  final double confidence;
  final double viewWidth;
  final double viewHeight;

  HandRectanglePainter({
    required this.landmarks,
    required this.isAlif,
    required this.confidence,
    required this.viewWidth,
    required this.viewHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;

    // ============================================
    // CALCULATE BOUNDING BOX FROM LANDMARKS
    // ============================================
    double minX = 1.0, minY = 1.0, maxX = 0.0, maxY = 0.0;
    
    for (var landmark in landmarks) {
      if (landmark.length >= 2) {
        final x = landmark[0];
        final y = landmark[1];
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }
    
    // Add padding (10% of size)
    final paddingX = (maxX - minX) * 0.15;
    final paddingY = (maxY - minY) * 0.15;
    
    minX = (minX - paddingX).clamp(0.0, 1.0);
    minY = (minY - paddingY).clamp(0.0, 1.0);
    maxX = (maxX + paddingX).clamp(0.0, 1.0);
    maxY = (maxY + paddingY).clamp(0.0, 1.0);
    
    // Convert to screen coordinates
    final rect = Rect.fromLTRB(
      minX * viewWidth,
      minY * viewHeight,
      maxX * viewWidth,
      maxY * viewHeight,
    );

    // ============================================
    // DRAW RECTANGLE WITH CORNERS
    // ============================================
    
    // Main rectangle border
    final borderColor = isAlif ? Colors.green : Colors.red;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(rect, borderPaint);

    // Glow effect (shadow)
    final glowPaint = Paint()
      ..color = borderColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawRect(rect, glowPaint);

    // ============================================
    // DRAW CORNER TABS
    // ============================================
    final cornerSize = 20.0;
    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Top-left corner
    canvas.drawLine(
      Offset(rect.left, rect.top + cornerSize),
      Offset(rect.left, rect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerSize, rect.top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(rect.right, rect.top + cornerSize),
      Offset(rect.right, rect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right - cornerSize, rect.top),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(rect.left, rect.bottom - cornerSize),
      Offset(rect.left, rect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerSize, rect.bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(rect.right, rect.bottom - cornerSize),
      Offset(rect.right, rect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right - cornerSize, rect.bottom),
      cornerPaint,
    );

    // ============================================
    // DRAW LABEL ON TOP OF RECTANGLE
    // ============================================
    final label = isAlif ? 'ALIF' : 'Not Alif';
    final labelColor = isAlif ? Colors.green : Colors.red;
    
    // Label background
    final labelPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final labelRect = Rect.fromLTWH(
      rect.left + 10,
      rect.top - 30,
      80,
      25,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(5)),
      labelPaint,
    );

    // Label text
    final textStyle = TextStyle(
      color: labelColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(text: label, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(rect.left + 15, rect.top - 28),
    );

    // ============================================
    // DRAW CONFIDENCE ON BOTTOM RIGHT
    // ============================================
    final confidenceText = '${(confidence * 100).toStringAsFixed(0)}%';
    final confidenceStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      background: Paint()..color = Colors.black.withOpacity(0.7),
    );

    final confSpan = TextSpan(text: confidenceText, style: confidenceStyle);
    final confPainter = TextPainter(
      text: confSpan,
      textDirection: TextDirection.ltr,
    );
    confPainter.layout();
    confPainter.paint(
      canvas,
      Offset(rect.right - 50, rect.bottom + 10),
    );

    // ============================================
    // DRAW LANDMARKS AS SMALL DOTS
    // ============================================
    final dotPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.fill;

    for (var landmark in landmarks) {
      if (landmark.length >= 2) {
        final x = landmark[0] * viewWidth;
        final y = landmark[1] * viewHeight;
        canvas.drawCircle(Offset(x, y), 4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}