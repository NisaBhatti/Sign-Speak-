import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../services/mediapipe_service.dart';

class HandDetectionScreen extends StatefulWidget {
  const HandDetectionScreen({Key? key}) : super(key: key);

  @override
  State<HandDetectionScreen> createState() => _HandDetectionScreenState();
}

class _HandDetectionScreenState extends State<HandDetectionScreen> {
  CameraController? _controller;
  DetectionResult _result = DetectionResult.empty();
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
    // Check if plugin is working
    final connected = await MediaPipeService.ping();
    _isReady = connected;
    print('🔌 MediaPipe connected: $connected');
    
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
      print('❌ Camera error: $e');
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
      return null;
    }
  }

  void _processCameraImage(CameraImage image) {
    if (_isProcessing || !_isReady) return;
    _isProcessing = true;
    
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
          final result = await MediaPipeService.detectHand(jpegBytes);
          if (mounted) {
            setState(() {
              _result = result;
              _landmarks = result.landmarks;
            });
          }
        } catch (e) {
          print('❌ Error: $e');
        }
      }
      _isProcessing = false;
    }).catchError((e) {
      _isProcessing = false;
    });
  }

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
              _isReady ? '✅ MediaPipe' : '❌ Not Ready',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),
          
          _buildHandOverlay(),
          
          // Status Bar
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
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
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _result.hasHand
                        ? (_result.isAlif 
                          ? '✅ ALIF ${(_result.confidence * 100).toStringAsFixed(0)}%'
                          : '❌ Not Alif ${(_result.confidence * 100).toStringAsFixed(0)}%')
                        : '👋 Show your hand',
                    style: TextStyle(
                      color: _result.hasHand
                          ? (_result.isAlif ? Colors.green : Colors.red)
                          : Colors.grey,
                      fontSize: 16,
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'FPS: ${_fps.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    'Landmarks: ${_landmarks.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    'Conf: ${(_result.confidence * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _result.hasHand ? Colors.green : Colors.grey,
                      fontSize: 12,
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
// HAND LANDMARK PAINTER
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

    final color = isAlif ? Colors.green : Colors.red;

    // Connections
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4],
      [0, 5], [5, 6], [6, 7], [7, 8],
      [0, 9], [9, 10], [10, 11], [11, 12],
      [0, 13], [13, 14], [14, 15], [15, 16],
      [0, 17], [17, 18], [18, 19], [19, 20],
    ];

    final linePaint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var conn in connections) {
      if (conn[0] < landmarks.length && conn[1] < landmarks.length) {
        final p1 = landmarks[conn[0]];
        final p2 = landmarks[conn[1]];
        if (p1.length >= 2 && p2.length >= 2) {
          canvas.drawLine(
            Offset(p1[0] * viewWidth, p1[1] * viewHeight),
            Offset(p2[0] * viewWidth, p2[1] * viewHeight),
            linePaint,
          );
        }
      }
    }

    // Points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final wristPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (int i = 0; i < landmarks.length && i < 21; i++) {
      final l = landmarks[i];
      if (l.length >= 2) {
        final x = l[0] * viewWidth;
        final y = l[1] * viewHeight;
        
        final radius = i == 0 ? 4.0 : 3.0;
        final paint = i == 0 ? wristPaint : pointPaint;
        
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }

    // Bounding box
    _drawBoundingBox(canvas, color);
  }

  void _drawBoundingBox(Canvas canvas, Color color) {
    if (landmarks.isEmpty) return;

    double minX = 1.0, minY = 1.0, maxX = 0.0, maxY = 0.0;
    
    for (var l in landmarks) {
      if (l.length >= 2) {
        if (l[0] < minX) minX = l[0];
        if (l[1] < minY) minY = l[1];
        if (l[0] > maxX) maxX = l[0];
        if (l[1] > maxY) maxY = l[1];
      }
    }
    
    final padX = (maxX - minX) * 0.1;
    final padY = (maxY - minY) * 0.1;
    
    minX = (minX - padX).clamp(0.0, 1.0);
    minY = (minY - padY).clamp(0.0, 1.0);
    maxX = (maxX + padX).clamp(0.0, 1.0);
    maxY = (maxY + padY).clamp(0.0, 1.0);
    
    final rect = Rect.fromLTRB(
      minX * viewWidth,
      minY * viewHeight,
      maxX * viewWidth,
      maxY * viewHeight,
    );

    final borderPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}