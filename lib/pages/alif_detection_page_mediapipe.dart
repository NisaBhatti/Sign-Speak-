// alif_detection_page_mediapipe.dart
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'hand_detector_mediapipe.dart'; // Your new MediaPipe detector

class AlifDetectionPage extends StatefulWidget {
  const AlifDetectionPage({super.key});

  @override
  State<AlifDetectionPage> createState() => _AlifDetectionPageState();
}

class _AlifDetectionPageState extends State<AlifDetectionPage> {
  CameraController? _cameraController;
  HandDetectorService? _handDetector;
  AlifDetector? _alifDetector;
  bool _isCameraReady = false;
  bool _isDetecting = false;
  
  String _prediction = 'Waiting...';
  double _confidence = 0.0;
  
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _initDetectors();
    await _initCamera();
  }
  
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await [Permission.camera].request();
    }
  }
  
  Future<void> _initDetectors() async {
    _handDetector = HandDetectorService();
    _alifDetector = AlifDetector();
    await _alifDetector!.initialize();
  }
  
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      
      await _cameraController!.initialize();
      
      setState(() => _isCameraReady = true);
      
      // Start continuous detection
      _startDetectionLoop();
      
      print('✅ Camera ready');
    } catch (e) {
      print('❌ Camera error: $e');
    }
  }
  
  void _startDetectionLoop() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isCameraReady && mounted) {
        _processFrame();
      }
    });
  }
  
  Future<void> _processFrame() async {
    if (_isDetecting || !_isCameraReady || _cameraController == null) {
      _startDetectionLoop();
      return;
    }
    
    _isDetecting = true;
    
    try {
      // Take picture for processing
      final XFile imageFile = await _cameraController!.takePicture();
      final File image = File(imageFile.path);
      
      // Convert to CameraImage format for MediaPipe
      // Note: This is simplified - you'll need proper CameraImage conversion
      // For now, using a workaround
      await _processImage(image);
      
    } catch (e) {
      print('Processing error: $e');
    } finally {
      _isDetecting = false;
      _startDetectionLoop(); // Continue detection
    }
  }
  
  Future<void> _processImage(File imageFile) async {
    try {
      // Read image bytes
      final bytes = await imageFile.readAsBytes();
      
      // Create input image for MediaPipe
      final inputImage = InputImage.fromFile(imageFile);
      
      // Get hand landmarks using MediaPipe
      final landmarks = await _handDetector!.detectHandLandmarks(
        await _cameraController!.takePicture() // Simplified
      );
      
      if (landmarks != null && landmarks.length == 21) {
        // Check if Alif sign
        final isAlif = await _alifDetector!.isAlif(landmarks);
        final confidence = await _alifDetector!.getAlifConfidence(landmarks);
        
        setState(() {
          _prediction = isAlif ? 'الف' : 'Not Alif';
          _confidence = confidence;
        });
      }
    } catch (e) {
      print('Image processing error: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection (MediaPipe)'),
        backgroundColor: marineBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFCFE8EA),
              const Color(0xFFACD9D9),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isCameraReady && _cameraController != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CameraPreview(_cameraController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
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
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _prediction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
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
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    _handDetector?.dispose();
    _alifDetector?.dispose();
    super.dispose();
  }
}