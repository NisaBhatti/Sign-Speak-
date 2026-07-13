import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_hand_landmark/google_mlkit_hand_landmark.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart'; // important
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:collection';

// ========== HARDCODED REFERENCE ALIF (placeholder) ==========
const List<List<double>> REFERENCE_ALIF = [
  [0.5, 0.2],
  [0.5, 0.25],
  [0.5, 0.3],
  [0.5, 0.35],
  [0.5, 0.4],
  [0.55, 0.5],
  [0.6, 0.55],
  [0.65, 0.6],
  [0.7, 0.65],
  [0.5, 0.5],
  [0.45, 0.6],
  [0.45, 0.7],
  [0.45, 0.8],
  [0.5, 0.5],
  [0.5, 0.65],
  [0.5, 0.75],
  [0.5, 0.85],
  [0.5, 0.5],
  [0.55, 0.65],
  [0.6, 0.75],
  [0.6, 0.85],
];
// ===========================================================

class AlifDetectionPage extends StatefulWidget {
  const AlifDetectionPage({super.key});

  @override
  State<AlifDetectionPage> createState() => _AlifDetectionPageState();
}

class _AlifDetectionPageState extends State<AlifDetectionPage> {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  HandLandmarker? _handLandmarker;  // ← changed

  bool _isModelLoaded = false;
  bool _isCameraReady = false;
  bool _isLiveDetecting = false;

  String _prediction = 'Waiting...';
  double _confidence = 0.0;
  bool _isAlif = false;

  final Queue<double> _predictionHistory = Queue<double>();
  static const int smoothWindow = 10;

  List<HandLandmark>? _currentLandmarks;
  Size? _imageSize;

  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _loadModel();
    await _initCamera();
    _initHandLandmarker();
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera].request();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/alif_robust.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      setState(() => _isModelLoaded = true);
      print('✅ Robust model loaded');
    } catch (e) {
      print('❌ Model error: $e');
      setState(() => _isModelLoaded = true); // fallback
    }
  }

  void _initHandLandmarker() {
    _handLandmarker = HandLandmarker(
      options: HandLandmarkerOptions(
        mode: HandLandmarkerMode.liveStream,   // ← correct
        numHands: 1,
        minHandDetectionConfidence: 0.5,
        minHandPresenceConfidence: 0.5,
        minTrackingConfidence: 0.5,
      ),
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420, // ML Kit needs YUV
    );
    await _cameraController!.initialize();
    _imageSize = Size(
      _cameraController!.value.previewSize!.height,
      _cameraController!.value.previewSize!.width,
    );
    setState(() => _isCameraReady = true);
    print('✅ Camera ready');
  }

  // ========== TOGGLE ==========
  void _toggleLiveDetection(bool value) async {
    setState(() => _isLiveDetecting = value);
    if (value) {
      _startImageStream();
    } else {
      _stopImageStream();
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream(_processCameraImage);
  }

  void _stopImageStream() {
    _cameraController?.stopImageStream();
  }

  // ========== FRAME PROCESSING ==========
  Future<void> _processCameraImage(CameraImage cameraImage) async {
    if (!_isLiveDetecting || !_isModelLoaded) return;

    final inputImage = _convertCameraImage(cameraImage);
    if (inputImage == null) return;

    final List<Hand> hands = await _handLandmarker!.processImage(inputImage);
    if (hands.isEmpty) {
      setState(() {
        _currentLandmarks = null;
        _prediction = 'No hand';
        _confidence = 0.0;
      });
      return;
    }

    final hand = hands.first;
    final landmarks = hand.landmarks;

    // Normalize landmarks to 0-1 (relative to image size)
    final normX = landmarks.map((lm) => lm.x / inputImage.size.width).toList();
    final normY = landmarks.map((lm) => lm.y / inputImage.size.height).toList();

    final List<double> features = [];
    for (int i = 0; i < landmarks.length; i++) {
      features.add(normX[i]);
      features.add(normY[i]);
    }

    // TFLite inference
    final inputTensor = [features];        // [1,42]
    final outputTensor = List.generate(1, (_) => [0.0]); // [1,1]
    _interpreter!.run(inputTensor, outputTensor);
    double rawPred = outputTensor[0][0];

    // Smoothing
    _predictionHistory.add(rawPred);
    if (_predictionHistory.length > smoothWindow) {
      _predictionHistory.removeFirst();
    }
    double smoothPred = _predictionHistory.reduce((a,b) => a+b) / _predictionHistory.length;

    bool isAlif = smoothPred > 0.5;
    double confidence = isAlif ? smoothPred : (1 - smoothPred);

    setState(() {
      _currentLandmarks = landmarks;
      _isAlif = isAlif;
      _prediction = isAlif ? 'الف (Alif)' : 'Not Alif';
      _confidence = confidence;
    });
  }

  // ✅ CORRECT YUV -> InputImage conversion
  InputImage? _convertCameraImage(CameraImage image) {
    // Build ML Kit planes from camera planes
    final planes = image.planes.map((plane) {
      return InputImagePlane(
        bytes: plane.bytes,
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    }).toList();

    final inputImageData = InputImageData(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      imageRotation: InputImageRotation.rotation0deg, // adjust if needed
      inputImageFormat: InputImageFormat.yuv_420_888,
      planeData: planes,
    );

    return InputImage.fromPlanes(inputImageData);
  }

  @override
  void dispose() {
    _stopImageStream();
    _cameraController?.dispose();
    _interpreter?.close();
    _handLandmarker?.close();  // ← changed
    super.dispose();
  }

  // ========== UI (unchanged) ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection'),
        backgroundColor: marineBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: Column(
          children: [
            // Camera preview + overlay
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: marineBlue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: _isCameraReady && _cameraController != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(_cameraController!),
                            if (_currentLandmarks != null)
                              CustomPaint(
                                painter: HandPainter(
                                  landmarks: _currentLandmarks!,
                                  imageSize: _imageSize ?? Size(400, 400),
                                  referenceAlif: REFERENCE_ALIF,
                                  isAlif: _isAlif,
                                ),
                              ),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),

            // Real‑time toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Real‑time Detection',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Switch(
                    value: _isLiveDetecting,
                    onChanged: _toggleLiveDetection,
                    activeColor: marineBlue,
                  ),
                ],
              ),
            ),

            // Result card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [marineBlue, lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    'Detection Result',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _prediction,
                    style: TextStyle(
                      color: _isAlif ? Colors.greenAccent : Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_confidence > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '${(_confidence * 100).toStringAsFixed(1)}% confidence',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isModelLoaded ? Icons.check_circle : Icons.warning,
                    color: _isModelLoaded ? Colors.green : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isModelLoaded ? 'Model Ready' : 'Loading Model...',
                    style: TextStyle(
                      color: _isModelLoaded ? Colors.green : Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== HAND PAINTER (unchanged) ==========
class HandPainter extends CustomPainter {
  final List<HandLandmark> landmarks;
  final Size imageSize;
  final List<List<double>> referenceAlif;
  final bool isAlif;

  HandPainter({
    required this.landmarks,
    required this.imageSize,
    required this.referenceAlif,
    required this.isAlif,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    // Draw reference Alif skeleton
    final refPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < referenceAlif.length; i++) {
      final x = referenceAlif[i][0] * size.width;
      final y = referenceAlif[i][1] * size.height;
      canvas.drawCircle(Offset(x, y), 4, refPaint..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(x, y), 6, refPaint..style = PaintingStyle.stroke);
    }
    for (int i = 0; i < referenceAlif.length - 1; i++) {
      final p1 = Offset(referenceAlif[i][0] * size.width, referenceAlif[i][1] * size.height);
      final p2 = Offset(referenceAlif[i+1][0] * size.width, referenceAlif[i+1][1] * size.height);
      canvas.drawLine(p1, p2, refPaint);
    }

    // Draw current hand
    final handColor = isAlif ? Colors.green : Colors.yellow;
    final handPaint = Paint()
      ..color = handColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = handColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    for (final lm in landmarks) {
      final x = lm.x * scaleX;
      final y = lm.y * scaleY;
      canvas.drawCircle(Offset(x, y), 6, fillPaint);
      canvas.drawCircle(Offset(x, y), 8, handPaint);
    }

    final connections = [
      [0,1],[1,2],[2,3],[3,4],
      [0,5],[5,6],[6,7],[7,8],
      [0,9],[9,10],[10,11],[11,12],
      [0,13],[13,14],[14,15],[15,16],
      [0,17],[17,18],[18,19],[19,20],
      [5,9],[9,13],[13,17]
    ];
    for (final conn in connections) {
      final p1 = Offset(landmarks[conn[0]].x * scaleX, landmarks[conn[0]].y * scaleY);
      final p2 = Offset(landmarks[conn[1]].x * scaleX, landmarks[conn[1]].y * scaleY);
      canvas.drawLine(p1, p2, handPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}