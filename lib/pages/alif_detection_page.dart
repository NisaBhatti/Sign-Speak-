import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import '../services/hand_detector_service.dart';

class AlifDetectionPage extends StatefulWidget {
  const AlifDetectionPage({super.key});

  @override
  State<AlifDetectionPage> createState() => _AlifDetectionPageState();
}

class _AlifDetectionPageState extends State<AlifDetectionPage> {
  CameraController? _cameraController;
  HandDetectorService? _handDetector;
  List<Offset> _landmarks = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeHandDetector();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _initializeHandDetector() async {
    _handDetector = HandDetectorService();
    await _handDetector!.initialize();
  }

  // Helper method to convert CameraImage to InputImage
  Future<InputImage> _convertToInputImage(CameraImage image) async {
    // For now, use a simple conversion
    // You might need to implement proper image conversion based on your needs
    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        format: InputImageFormat.nv21,
        rotation: InputImageRotation.rotation0deg,
      ),
    );
  }

  Future<void> _processFrame(CameraImage cameraImage) async {
    if (_isProcessing || _handDetector == null) return;
    
    _isProcessing = true;
    try {
      final inputImage = await _convertToInputImage(cameraImage);
      final landmarks = await _handDetector!.detectHandLandmarks(inputImage);
      
      setState(() {
        _landmarks = landmarks;
      });
      
    } catch (e) {
      print('Error processing frame: $e');
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _reloadMediaPipe() async {
    if (_handDetector != null) {
      final success = await _handDetector!.forceReloadMediaPipe();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MediaPipe reloaded successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadMediaPipe,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Expanded(
              child: Stack(
                children: [
                  CameraPreview(_cameraController!),
                  // Draw landmarks on the camera preview
                  CustomPaint(
                    painter: LandmarkPainter(_landmarks),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Landmarks detected: ${_landmarks.length}',
              style: const TextStyle(fontSize: 16),
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
    super.dispose();
  }
}

// Custom painter for drawing landmarks
class LandmarkPainter extends CustomPainter {
  final List<Offset> landmarks;

  LandmarkPainter(this.landmarks);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4.0
      ..style = PaintingStyle.fill;

    for (var landmark in landmarks) {
      canvas.drawCircle(
        Offset(landmark.dx * size.width, landmark.dy * size.height),
        6,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}