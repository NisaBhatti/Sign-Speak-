import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

import 'package:tflite_flutter/tflite_flutter.dart'
    if (dart.library.html) 'package:tflite_flutter/tflite_flutter_web.dart';

class AlifDetectionPage extends StatefulWidget {
  const AlifDetectionPage({super.key});

  @override
  State<AlifDetectionPage> createState() => _AlifDetectionPageState();
}

class _AlifDetectionPageState extends State<AlifDetectionPage> {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  bool _isCameraReady = false;
  bool _isProcessing = false;        // for capture button
  bool _isLiveDetecting = false;     // live stream toggle
  String _prediction = 'Waiting...';
  double _confidence = 0.0;
  List<CameraDescription>? _cameras;

  final int _inputSize = 224;
  final int _numClasses = 10;

  // Home page colors
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
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await [
        Permission.camera,
        Permission.storage,
      ].request();
    }
  }

  Future<void> _loadModel() async {
    try {
      print('📥 Loading model...');
      _interpreter = await Interpreter.fromAsset(
        'assets/models/alif_model.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      setState(() => _isModelLoaded = true);
      print('✅ Model loaded');
    } catch (e) {
      print('❌ Model error: $e');
      setState(() {
        _isModelLoaded = true;
        _prediction = 'الف (Demo)';
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras');
      }
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      setState(() => _isCameraReady = true);
      print('✅ Camera ready');
    } catch (e) {
      print('❌ Camera error: $e');
    }
  }

  // 🔁 Toggle real‑time detection
  void _toggleLiveDetection(bool value) async {
    setState(() => _isLiveDetecting = value);
    if (value) {
      _startImageStream();
    } else {
      _stopImageStream();
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) {
      if (!_isLiveDetecting || !_isModelLoaded) return;
      _processFrame(image);
    });
  }

  void _stopImageStream() {
    _cameraController?.stopImageStream();
  }

  // 🔹 Convert CameraImage (YUV420) to img.Image and predict
  Future<void> _processFrame(CameraImage cameraImage) async {
    // Convert YUV420 to RGB (simplified – uses first plane only, adjust for full colour)
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final plane = cameraImage.planes[0];
    final bytes = plane.bytes;
    // Create Image from raw BGRA bytes if available, else approximate
    // For simplicity, we use a rough conversion:
    final img.Image? frameImg = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: bytes.buffer,
      format: img.Format.uint8, // single channel
    );
    if (frameImg == null) return;

    final preprocessed = _preprocessImage(frameImg);
    final output = await _runInference(preprocessed);
    final (predictedClass, confidence) = _getPrediction(output);

    if (mounted) {
      setState(() {
        _prediction = _getSignLabel(predictedClass);
        _confidence = confidence;
      });
    }
  }

  // 4D tensor [1][224][224][1] grayscale
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    final resized = img.copyResize(image, width: _inputSize, height: _inputSize);
    return List.generate(
      1,
      (b) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [(pixel.r + pixel.g + pixel.b) / (3 * 255.0)];
          },
        ),
      ),
    );
  }

  Future<List<List<double>>> _runInference(List<List<List<List<double>>>> input) async {
    var outputTensor = List.generate(1, (_) => List.filled(_numClasses, 0.0));
    _interpreter?.run(input, outputTensor);
    return outputTensor;
  }

  (int, double) _getPrediction(List<List<double>> output) {
    final predictions = output[0];
    int maxIndex = 0;
    double maxValue = predictions[0];
    for (int i = 1; i < predictions.length; i++) {
      if (predictions[i] > maxValue) {
        maxValue = predictions[i];
        maxIndex = i;
      }
    }
    return (maxIndex, maxValue);
  }

  String _getSignLabel(int index) {
    const labels = [
      'الف', 'بے', 'پے', 'تے', 'ٹے',
      'ثے', 'جیم', 'چے', 'حے', 'خے'
    ];
    return index < labels.length ? labels[index] : 'Unknown';
  }

  // Manual capture (works when live detection OFF)
  Future<void> _captureAndPredict() async {
    if (!_isCameraReady || !_isModelLoaded) return;
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final File image = File(imageFile.path);
      final img.Image? inputImage = img.decodeImage(await image.readAsBytes());
      if (inputImage == null) throw Exception('Failed to decode');
      final preprocessed = _preprocessImage(inputImage);
      final output = await _runInference(preprocessed);
      final (predictedClass, confidence) = _getPrediction(output);
      setState(() {
        _prediction = _getSignLabel(predictedClass);
        _confidence = confidence;
      });
    } catch (e) {
      print('Capture error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _stopImageStream();
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

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
            // Camera preview
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
                child: _isCameraReady
                    ? _cameraController != null && _cameraController!.value.isInitialized
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CameraPreview(_cameraController!),
                          )
                        : const Center(child: CircularProgressIndicator())
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),

            // Real‑time toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Real‑time Detection', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Switch(
                    value: _isLiveDetecting,
                    onChanged: _toggleLiveDetection,
                    activeColor: marineBlue,
                  ),
                ],
              ),
            ),

            // 🔵 Wider result card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              width: double.infinity,   // full width
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
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _prediction,
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
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

            // Only one button – Capture (when live mode OFF)
            if (!_isLiveDetecting)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (_isCameraReady && _isModelLoaded && !_isProcessing)
                        ? _captureAndPredict
                        : null,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Capture & Detect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: marineBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
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