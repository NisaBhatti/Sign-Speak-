import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_tts/flutter_tts.dart';
import '../services/alphabet_detection_service.dart';

class AlphabetDetectionPage extends StatefulWidget {
  final String alphabet;
  final String displayName;
  final String arabic;

  const AlphabetDetectionPage({
    super.key,
    required this.alphabet,
    required this.displayName,
    required this.arabic,
  });

  @override
  State<AlphabetDetectionPage> createState() => _AlphabetDetectionPageState();
}

class _AlphabetDetectionPageState extends State<AlphabetDetectionPage> {
  CameraController? _controller;
  DetectionResult _result = DetectionResult.error('Waiting...');
  bool _isProcessing = false;
  bool _isConnected = false;
  int _frameCount = 0;
  double _fps = 0.0;
  DateTime _lastFpsUpdate = DateTime.now();
  DateTime? _lastFrameTime;
  List<double> _landmarks = [];

  final FlutterTts _tts = FlutterTts();
  bool _ttsReady = false;
  String _lastSpokenMessage = '';
  DateTime _lastSpokenTime = DateTime.now();

  // 🐞 debug: 1 = draw dummy landmarks
  int _debugMode = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initialize();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.2);

      final voices = await _tts.getVoices;
      if (voices != null) {
        for (final v in voices) {
          final name = (v['name'] ?? '').toString().toLowerCase();
          if (name.contains('female') ||
              name.contains('samantha') ||
              name.contains('victoria') ||
              name.contains('karen') ||
              name.contains('zira') ||
              name.contains('google us english')) {
            await _tts.setVoice({
              'name': v['name'].toString(),
              'locale': v['locale'].toString(),
            });
            print('🔊 TTS voice: ${v['name']}');
            break;
          }
        }
      }
      _ttsReady = true;
      print('✅ TTS initialized');
    } catch (e) {
      print('⚠️ TTS init failed: $e');
      _ttsReady = false;
    }
  }

  Future<void> _speak(String text, {bool force = false}) async {
    if (!_ttsReady) return;
    if (!force && text == _lastSpokenMessage) {
      if (DateTime.now().difference(_lastSpokenTime).inSeconds < 3) return;
    }
    _lastSpokenMessage = text;
    _lastSpokenTime = DateTime.now();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      print('⚠️ TTS speak failed: $e');
    }
  }

  Future<void> _initialize() async {
    print('🔌 Checking server connection...');
    final status = await AlphabetDetectionService.pingServer();
    _isConnected = status['connected'] ?? false;
    print('🔌 Server connected: $_isConnected');

    setState(() {});

    if (_isConnected) {
      await AlphabetDetectionService.preloadModel(widget.alphabet);
      await _initializeCamera();
    } else {
      setState(() {
        _result = DetectionResult.error(
          'Server not connected!\nCheck Wi-Fi and server IP.',
        );
      });
      _speak('Server is offline. Please check Wi-Fi and server IP.',
          force: true);
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
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {});
        _controller!.startImageStream(_processCameraImage);
      }
      print('✅ Camera initialized');
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
            int g = (yValue -
                    0.344 * (uValue - 128) -
                    0.714 * (vValue - 128))
                .round();
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

        // Higher quality for better local detection
        final resized = img.copyResize(imgImage, width: 480);
        final jpegBytes = img.encodeJpg(resized, quality: 60);
        return Uint8List.fromList(jpegBytes);
      }
      return null;
    } catch (e) {
      print('❌ Conversion error: $e');
      return null;
    }
  }

  List<double> _generateDebugLandmarks() {
    final lm = <double>[];
    for (int i = 0; i < 21; i++) {
      lm.add((0.3 + 0.4 * (i / 20.0)).clamp(0.0, 1.0));
      lm.add((0.3 + 0.4 * (i / 20.0)).clamp(0.0, 1.0));
    }
    return lm;
  }

  void _processCameraImage(CameraImage image) {
    if (_isProcessing || !_isConnected) return;

    final now = DateTime.now();
    if (_lastFrameTime != null &&
        now.difference(_lastFrameTime!).inMilliseconds < 250) {
      return;
    }
    _lastFrameTime = now;
    _isProcessing = true;

    _frameCount++;
    if (now.difference(_lastFpsUpdate) > const Duration(seconds: 1)) {
      _fps = _frameCount.toDouble();
      _frameCount = 0;
      _lastFpsUpdate = now;
      if (mounted) setState(() {});
    }

    // 🐞 debug mode
    if (_debugMode == 1) {
      final dummy = _generateDebugLandmarks();
      setState(() {
        _result = DetectionResult(
          hasHand: true,
          isAlphabet: true,
          confidence: 0.9,
          landmarks: dummy,
          message: 'Debug mode',
        );
        _landmarks = dummy;
      });
      _isProcessing = false;
      return;
    }

    _convertCameraImageToBytes(image).then((jpegBytes) async {
      if (jpegBytes != null && mounted) {
        try {
          final result = await AlphabetDetectionService.detectAlphabet(
            jpegBytes,
            alphabet: widget.alphabet,
          );
          if (mounted) {
            setState(() {
              _result = result;
              _landmarks = result.landmarks;
            });
            _handleVoiceFeedback(result);
          }
        } catch (e) {
          print('❌ Detection error: $e');
        }
      }
      _isProcessing = false;
    }).catchError((e) {
      _isProcessing = false;
    });
  }

  void _handleVoiceFeedback(DetectionResult result) {
    if (!result.hasHand) {
      _speak('Please show your hand to the camera.');
    } else if (result.isAlphabet) {
      _speak('Correct! It is ${widget.displayName}.');
    } else {
      _speak('This is not ${widget.displayName}. Please do the correct sign.');
    }
  }

  Widget _buildLandmarkOverlay() {
    if (_landmarks.length < 42) return Container();
    if (!_result.hasHand && _debugMode == 0) return Container();

    return CustomPaint(
      painter: HandLandmarkPainter(
        landmarks: _landmarks,
        isAlphabet: _result.isAlphabet,
        viewWidth: MediaQuery.of(context).size.width,
        viewHeight: MediaQuery.of(context).size.height,
      ),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _controller?.stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.arabic,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Text(widget.displayName),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: _debugMode == 0 ? 'Enable dummy landmarks' : 'Disable dummy',
            onPressed: () {
              setState(() {
                _debugMode = _debugMode == 0 ? 1 : 0;
                if (_debugMode == 0) {
                  _landmarks = [];
                  _result = DetectionResult.error('Waiting...');
                }
              });
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _isConnected ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isConnected ? Icons.cloud_done : Icons.cloud_off,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _isConnected ? 'Server' : 'Offline',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),

          _buildLandmarkOverlay(),

          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _result.hasHand
                            ? (_result.isAlphabet
                                ? Icons.check_circle
                                : Icons.cancel)
                            : Icons.handshake,
                        color: _result.hasHand
                            ? (_result.isAlphabet ? Colors.green : Colors.red)
                            : Colors.grey,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          _result.label,
                          style: TextStyle(
                            color: _result.hasHand
                                ? (_result.isAlphabet
                                    ? Colors.green
                                    : Colors.red)
                                : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'hasHand=${_result.hasHand}  |  '
                    'landmarks=${_landmarks.length}  |  '
                    'conf=${(_result.confidence * 100).toStringAsFixed(0)}%'
                    '${_debugMode == 1 ? "  |  DEBUG" : ""}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '⚡ ${_fps.toStringAsFixed(0)} FPS',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'msg: ${_result.message}',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                !_isConnected
                    ? '❌ Server offline — check Wi-Fi and server IP'
                    : _result.hasHand
                        ? (_result.isAlphabet
                            ? '✅ Correct! You are showing ${widget.displayName}'
                            : '❌ This is not ${widget.displayName}')
                        : '👋 Show your hand to camera',
                style: TextStyle(
                  color: !_isConnected
                      ? Colors.red
                      : _result.hasHand
                          ? (_result.isAlphabet ? Colors.green : Colors.red)
                          : Colors.grey,
                  fontSize: 12,
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
// HAND LANDMARK PAINTER
// ============================================
class HandLandmarkPainter extends CustomPainter {
  final List<double> landmarks;
  final bool isAlphabet;
  final double viewWidth;
  final double viewHeight;

  HandLandmarkPainter({
    required this.landmarks,
    required this.isAlphabet,
    required this.viewWidth,
    required this.viewHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.length < 42) return;

    final color = isAlphabet ? Colors.green : Colors.red;

    final points = <Offset>[];
    for (int i = 0; i < 21; i++) {
      final x = landmarks[i * 2] * viewWidth;
      final y = landmarks[i * 2 + 1] * viewHeight;
      points.add(Offset(x, y));
    }

    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4],
      [0, 5], [5, 6], [6, 7], [7, 8],
      [0, 9], [9, 10], [10, 11], [11, 12],
      [0, 13], [13, 14], [14, 15], [15, 16],
      [0, 17], [17, 18], [18, 19], [19, 20],
    ];

    final linePaint = Paint()
      ..color = Colors.yellow.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var conn in connections) {
      if (conn[0] < points.length && conn[1] < points.length) {
        canvas.drawLine(points[conn[0]], points[conn[1]], linePaint);
      }
    }

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final wristPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final radius = i == 0 ? 5.0 : 3.5;
      final paint = i == 0 ? wristPaint : pointPaint;
      canvas.drawCircle(points[i], radius, paint);
    }

    double minX = double.infinity, minY = double.infinity;
    double maxX = -double.infinity, maxY = -double.infinity;
    for (var p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy > maxY) maxY = p.dy;
    }

    final padding = 20.0;
    minX = (minX - padding).clamp(0.0, viewWidth);
    minY = (minY - padding).clamp(0.0, viewHeight);
    maxX = (maxX + padding).clamp(0.0, viewWidth);
    maxY = (maxY + padding).clamp(0.0, viewHeight);

    final rect = Rect.fromLTRB(minX, minY, maxX, maxY);

    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, borderPaint);

    final label = isAlphabet ? 'MATCH!' : 'Not Match';
    final labelColor = isAlphabet ? Colors.green : Colors.red;

    final labelPaint = Paint()..color = Colors.black.withValues(alpha: 0.7);

    final labelRect = Rect.fromLTWH(minX + 10, minY - 28, 90, 22);
    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
      labelPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: labelColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(minX + 14, minY - 26));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}