import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../services/hand_detector.dart';
import '../services/alif_classifier.dart';

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
  Timer? _dummyTimer;
  double _testConfidence = 0.5;

  @override
  void initState() {
    super.initState();
    _initialize();
    _startDummyLandmarkAnimation();
  }

  // ============================================
  // ANIMATE DUMMY LANDMARKS FOR TESTING
  // ============================================
  void _startDummyLandmarkAnimation() {
    _dummyTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      // Generate moving dummy landmarks
      final dummyLandmarks = _generateMovingDummyLandmarks();
      
      // Classify with dummy landmarks
      AlifClassifier.classify(dummyLandmarks).then((result) {
        if (mounted) {
          setState(() {
            _result = result;
            _landmarks = dummyLandmarks;
          });
        }
      });
    });
  }

  List<List<double>> _generateMovingDummyLandmarks() {
    final landmarks = <List<double>>[];
    final time = DateTime.now().millisecondsSinceEpoch / 1000;
    
    // ✅ FIXED: Use math.sin() properly
    final wave = sin(time * 0.5) * 0.05;
    
    for (int i = 0; i < 21; i++) {
      double x, y;
      
      if (i == 0) {
        x = 0.5 + wave * 0.5;
        y = 0.6 + wave * 0.3;
      } else if (i <= 4) {
        final t = (i - 1) / 3.0;
        x = 0.3 + 0.2 * t + wave * 0.3;
        y = 0.4 + 0.2 * t + wave * 0.2;
      } else if (i <= 8) {
        final t = (i - 5) / 3.0;
        x = 0.4 + 0.05 * t + wave * 0.2;
        y = 0.2 + 0.15 * t + wave * 0.1;
      } else if (i <= 12) {
        final t = (i - 9) / 3.0;
        x = 0.5 + 0.05 * t + wave * 0.2;
        y = 0.15 + 0.15 * t + wave * 0.1;
      } else if (i <= 16) {
        final t = (i - 13) / 3.0;
        x = 0.6 + 0.05 * t + wave * 0.2;
        y = 0.2 + 0.15 * t + wave * 0.1;
      } else {
        final t = (i - 17) / 3.0;
        x = 0.7 + 0.05 * t + wave * 0.2;
        y = 0.3 + 0.15 * t + wave * 0.1;
      }
      
      // ✅ FIXED: Use math.sin() properly
      _testConfidence = 0.3 + sin(time * 0.1).abs() * 0.6;
      
      landmarks.add([
        x.clamp(0.05, 0.95),
        y.clamp(0.05, 0.95)
      ]);
    }
    
    return landmarks;
  }

  Future<void> _initialize() async {
    try {
      await HandDetector.loadModel();
      await AlifClassifier.loadModel();
      _isReady = true;
      
      setState(() {});
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
        ResolutionPreset.low,
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
          final landmarks = await HandDetector.detectHand(jpegBytes);
          
          if (landmarks.isNotEmpty) {
            final result = await AlifClassifier.classify(landmarks);
            if (mounted) {
              setState(() {
                _result = result;
                _landmarks = landmarks;
              });
            }
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
    if (_landmarks.isEmpty) {
      return Container();
    }
    
    return CustomPaint(
      painter: CleanHandPainter(
        landmarks: _landmarks,
        isAlif: _result.isAlif,
        hasHand: _result.hasHand,
        confidence: _result.confidence,
        viewWidth: MediaQuery.of(context).size.width,
        viewHeight: MediaQuery.of(context).size.height,
      ),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    _dummyTimer?.cancel();
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
                    _result.label,
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
// CLEAN HAND PAINTER
// ============================================
class CleanHandPainter extends CustomPainter {
  final List<List<double>> landmarks;
  final bool isAlif;
  final bool hasHand;
  final double confidence;
  final double viewWidth;
  final double viewHeight;

  CleanHandPainter({
    required this.landmarks,
    required this.isAlif,
    required this.hasHand,
    required this.confidence,
    required this.viewWidth,
    required this.viewHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty || !hasHand) return;

    final color = isAlif ? Colors.green : Colors.red;

    // ============================================
    // SMALL CONNECTIONS
    // ============================================
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4],
      [0, 5], [5, 6], [6, 7], [7, 8],
      [0, 9], [9, 10], [10, 11], [11, 12],
      [0, 13], [13, 14], [14, 15], [15, 16],
      [0, 17], [17, 18], [18, 19], [19, 20],
    ];

    final linePaint = Paint()
      ..color = Colors.yellow.withOpacity(0.6)
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

    // ============================================
    // SMALL POINTS
    // ============================================
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
        
        final radius = i == 0 ? 3.5 : 2.5;
        final paint = i == 0 ? wristPaint : pointPaint;
        
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }

    // ============================================
    // TIGHT BOUNDING BOX
    // ============================================
    _drawTightBox(canvas, color);
  }

  void _drawTightBox(Canvas canvas, Color color) {
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
    
    final padX = (maxX - minX) * 0.03;
    final padY = (maxY - minY) * 0.03;
    
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
      ..strokeWidth = 1.5;
      
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}