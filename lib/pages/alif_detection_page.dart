<<<<<<< HEAD
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class HandLandmarkDetectionPage extends StatefulWidget {
  const HandLandmarkDetectionPage({super.key});

  @override
  State<HandLandmarkDetectionPage> createState() => _HandLandmarkDetectionPageState();
}

class _HandLandmarkDetectionPageState extends State<HandLandmarkDetectionPage> {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  
  bool _isCameraReady = false;
  bool _isModelLoaded = false;
  bool _isProcessing = false;
  Timer? _detectionTimer;
  
  List<dynamic>? _landmarks;
  String _gesture = 'No hand detected';
  bool _showLandmarks = true;
  
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);

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
      final status = await Permission.camera.request();
      print('Camera permission status: $status');
    }
  }

  Future<void> _loadModel() async {
    try {
      // Load TFLite model
      _interpreter = await Interpreter.fromAsset(
        'assets/hand_landmark.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      
      setState(() => _isModelLoaded = true);
      print('✅ Model loaded successfully');
    } catch (e) {
      print('❌ Model loading error: $e');
      setState(() => _isModelLoaded = false);
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras available');
        return;
      }
      
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      _startContinuousDetection();
      
      setState(() => _isCameraReady = true);
      print('✅ Camera ready');
    } catch (e) {
      print('❌ Camera error: $e');
    }
  }

  void _startContinuousDetection() {
    _detectionTimer?.cancel();
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isCameraReady && !_isProcessing && _isModelLoaded) {
        _detectHands();
      }
    });
  }

  Future<void> _detectHands() async {
    if (_isProcessing || _cameraController == null) return;
    
    _isProcessing = true;
    
    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final File image = File(imageFile.path);
      final bytes = await image.readAsBytes();
      final img.Image? inputImage = img.decodeImage(bytes);
      
      if (inputImage == null) return;
      
      // Preprocess image for model
      final preprocessed = _preprocessImage(inputImage);
      
      // Run inference
      final output = await _runInference(preprocessed);
      
      // Process output to get landmarks
      final landmarks = _processOutput(output);
      
      if (mounted) {
        setState(() {
          _landmarks = landmarks;
          if (landmarks != null && landmarks.isNotEmpty) {
            _analyzeGesture(landmarks);
          } else {
            _gesture = 'No hand detected';
          }
        });
      }
      
    } catch (e) {
      print('Detection error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize to 224x224
    final resized = img.copyResize(image, width: 224, height: 224);
    
    // Convert to normalized float array
    List<List<List<List<double>>>> input = List.generate(
      1,
      (b) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = resized.getPixel(x, y);
            // Normalize to [0,1]
            return [(pixel.r / 255.0), (pixel.g / 255.0), (pixel.b / 255.0)];
          },
        ),
      ),
    );
    
    return input;
  }

  Future<List<dynamic>> _runInference(List<List<List<List<double>>>> input) async {
    // Output shape depends on the model
    var output = List.filled(1, List.filled(21 * 3, 0.0));
    _interpreter!.run(input, output);
    return output;
  }

  List<dynamic>? _processOutput(List<dynamic> output) {
    try {
      final flatOutput = output[0] as List<dynamic>;
      
      // Extract 21 landmarks (x, y, z)
      List<dynamic> landmarks = [];
      for (int i = 0; i < 21; i++) {
        final x = flatOutput[i * 3];
        final y = flatOutput[i * 3 + 1];
        final z = flatOutput[i * 3 + 2];
        landmarks.add({'x': x, 'y': y, 'z': z});
      }
      
      return landmarks;
    } catch (e) {
      print('Output processing error: $e');
      return null;
    }
  }

  void _analyzeGesture(List<dynamic> landmarks) {
    if (landmarks.length < 21) {
      _gesture = 'Insufficient landmarks';
      return;
    }
    
    try {
      // Get key landmarks
      final wrist = landmarks[0];
      final thumbTip = landmarks[4];
      final indexTip = landmarks[8];
      final middleTip = landmarks[12];
      final ringTip = landmarks[16];
      final pinkyTip = landmarks[20];
      
      // Check finger extensions
      bool thumbExtended = thumbTip['y'] < wrist['y'] - 0.05;
      bool indexExtended = indexTip['y'] < landmarks[6]['y'] - 0.02;
      bool middleExtended = middleTip['y'] < landmarks[10]['y'] - 0.02;
      bool ringExtended = ringTip['y'] < landmarks[14]['y'] - 0.02;
      bool pinkyExtended = pinkyTip['y'] < landmarks[18]['y'] - 0.02;
      
      int extendedCount = [
        thumbExtended, indexExtended, middleExtended, ringExtended, pinkyExtended
      ].where((e) => e).length;
      
      // Detect gestures
      if (extendedCount == 5) {
        _gesture = '🖐️ Open Hand';
      } else if (extendedCount == 0) {
        _gesture = '✊ Fist';
      } else if (indexExtended && !middleExtended && !ringExtended && !pinkyExtended) {
        _gesture = '☝️ Pointing';
      } else if (indexExtended && middleExtended && !ringExtended && !pinkyExtended) {
        _gesture = '✌️ Victory';
      } else if (thumbExtended && !indexExtended && !middleExtended && !ringExtended && !pinkyExtended) {
        _gesture = '👍 Thumbs Up';
      } else {
        _gesture = '🤚 Custom Gesture';
      }
      
    } catch (e) {
      print('Gesture analysis error: $e');
      _gesture = 'Analysis error';
    }
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    _interpreter?.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hand Landmark Detection'),
        backgroundColor: marineBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showLandmarks ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showLandmarks = !_showLandmarks),
            tooltip: 'Toggle Landmarks',
          ),
        ],
      ),
      body: _isCameraReady && _cameraController != null
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                if (_showLandmarks && _landmarks != null && _landmarks!.isNotEmpty)
                  CustomPaint(
                    painter: LandmarkPainter(
                      landmarks: _landmarks!,
                    ),
                    size: Size.infinite,
                  ),
                _buildInfoOverlay(),
                _buildStatusIndicator(),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildInfoOverlay() {
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _gesture,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_landmarks != null && _landmarks!.isNotEmpty)
              Text(
                '${_landmarks!.length} landmarks',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            const SizedBox(height: 4),
            Text(
              _isProcessing ? '⏳ Processing...' : '✅ Ready',
              style: TextStyle(
                color: _isProcessing ? Colors.orange : Colors.green,
                fontSize: 12,
              ),
=======
import 'package:flutter/material.dart';

class AlifDetectionPage extends StatelessWidget {
  const AlifDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection'),
        backgroundColor: const Color.fromARGB(255, 8, 4, 84),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'App is Working! ✅',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Build successful at: ${DateTime.now()}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
>>>>>>> e26f5f854aa8bd8b01123444ec9e1619ed3f348b
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isModelLoaded ? Colors.green : Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isModelLoaded ? Icons.check_circle : Icons.warning,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              _isModelLoaded 
                  ? '✅ Model Ready - Detecting hands' 
                  : '⏳ Loading model...',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Landmarks
class LandmarkPainter extends CustomPainter {
  final List<dynamic> landmarks;
  
  LandmarkPainter({required this.landmarks});

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;
    
    final connectionPaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Hand connections
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4],
      [0, 5], [5, 6], [6, 7], [7, 8],
      [0, 9], [9, 10], [10, 11], [11, 12],
      [0, 13], [13, 14], [14, 15], [15, 16],
      [0, 17], [17, 18], [18, 19], [19, 20],
      [5, 9], [9, 13], [13, 17],
    ];
    
    // Draw connections
    for (var connection in connections) {
      if (connection[0] < landmarks.length && connection[1] < landmarks.length) {
        final p1 = landmarks[connection[0]];
        final p2 = landmarks[connection[1]];
        canvas.drawLine(
          Offset(p1['x'] * size.width, p1['y'] * size.height),
          Offset(p2['x'] * size.width, p2['y'] * size.height),
          connectionPaint,
        );
      }
    }
    
    // Draw landmarks
    for (int i = 0; i < landmarks.length; i++) {
      final landmark = landmarks[i];
      final dx = landmark['x'] * size.width;
      final dy = landmark['y'] * size.height;
      
      Paint paint;
      if ([4, 8, 12, 16, 20].contains(i)) {
        paint = Paint()..color = Colors.yellow..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 8, paint);
      } else if ([0].contains(i)) {
        paint = Paint()..color = Colors.red..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 6, paint);
      } else if ([2, 6, 10, 14, 18].contains(i)) {
        paint = Paint()..color = Colors.orange..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 5, paint);
      } else {
        paint = Paint()..color = Colors.green..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}