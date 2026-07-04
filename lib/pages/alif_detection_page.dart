import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/alif_detector.dart';
import '../services/hand_detector.dart';

class AlifDetectionPage extends StatefulWidget {
  const AlifDetectionPage({super.key});

  @override
  State<AlifDetectionPage> createState() => _AlifDetectionPageState();
}

class _AlifDetectionPageState extends State<AlifDetectionPage> {
  CameraController? _cameraController;
  HandDetectorService? _handDetector;
  AlifDetector? _alifDetector;
  
  bool _isInitialized = false;
  bool _isDetecting = false;
  double _confidence = 0.0;
  String _feedback = "Initializing camera...";
  Color _feedbackColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Request permissions
      await Permission.camera.request();
      
      // Initialize detectors
      _handDetector = HandDetectorService();
      _alifDetector = AlifDetector();
      await _alifDetector!.initialize();
      
      // Initialize camera
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      
      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_processCameraImage);
      
      setState(() {
        _isInitialized = true;
        _feedback = "Show Alif sign (Index finger up)";
        _feedbackColor = Colors.amber;
      });
    } catch (e) {
      setState(() {
        _feedback = "Error: $e";
        _feedbackColor = Colors.red;
      });
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (!_isInitialized || _isDetecting) return;
    
    _isDetecting = true;
    
    try {
      // Detect hand landmarks
      final landmarks = await _handDetector!.detectHandLandmarks(image);
      
      if (landmarks != null && landmarks.length == 21) {
        // Get Alif detection confidence
        final confidence = await _alifDetector!.getAlifConfidence(landmarks);
        final isAlif = confidence > 0.5;
        
        setState(() {
          _confidence = confidence;
          
          if (isAlif) {
            if (confidence > 0.8) {
              _feedback = "✅ ALIF (ا) - Perfect!";
              _feedbackColor = Colors.green;
            } else if (confidence > 0.6) {
              _feedback = "✅ ALIF (ا) - Good";
              _feedbackColor = Colors.lightGreen;
            } else {
              _feedback = "✅ ALIF (ا) - Almost there";
              _feedbackColor = Colors.yellow.shade700;
            }
          } else {
            if (confidence < 0.2) {
              _feedback = "❌ Not Alif";
              _feedbackColor = Colors.red;
            } else if (confidence < 0.4) {
              _feedback = "🔄 Raise your index finger";
              _feedbackColor = Colors.orange;
            } else {
              _feedback = "⚠️ Keep index finger up, others down";
              _feedbackColor = Colors.amber;
            }
          }
        });
      } else {
        setState(() {
          _feedback = "🖐️ Show your hand to camera";
          _feedbackColor = Colors.grey;
          _confidence = 0.0;
        });
      }
    } catch (e) {
      print('Error processing image: $e');
    }
    
    _isDetecting = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _cameraController == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(_feedback),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alif Detection - Urdu Sign"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Camera preview
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: CameraPreview(_cameraController!),
            ),
          ),
          
          // Detection feedback panel
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade900,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: _feedbackColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: _feedbackColor, width: 2),
                  ),
                  child: Text(
                    _feedback,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _feedbackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 15),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confidence: ${(_confidence * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _confidence,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade700,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _confidence > 0.5 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
                
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InstructionWidget("☝️", "Index finger up"),
                      InstructionWidget("✊", "Other fingers folded"),
                      InstructionWidget("🎯", "Clear background"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

class InstructionWidget extends StatelessWidget {
  final String emoji;
  final String text;
  
  const InstructionWidget(this.emoji, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}