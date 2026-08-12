// lib/pages/alif_detection_page.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/hand_detector_service.dart';
import '../services/alif_detector.dart';

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
  bool _isMediaPipeLoading = true;
  bool _useFallback = false;
  
  String _prediction = 'Waiting...';
  double _confidence = 0.0;
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Initialize services with fallback
    _handDetector = HandDetectorService();
    _alifDetector = AlifDetector();
    await _alifDetector!.initialize();
    
    // Check if MediaPipe loaded
    _isMediaPipeLoading = false;
    
    // If MediaPipe not available, use fallback
    _useFallback = true;
    
    await _initCamera();
  }
  
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      setState(() => _isCameraReady = true);
      
      // Start detection loop
      _startDetectionLoop();
      
    } catch (e) {
      print('❌ Camera error: $e');
    }
  }
  
  void _startDetectionLoop() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _isCameraReady) {
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
      // Take picture
      final image = await _cameraController!.takePicture();
      
      // For now, use simulated landmarks (since MediaPipe is not working)
      // Get landmarks from hand detector (will use simulation if MediaPipe fails)
      final landmarks = await _handDetector!.detectHandLandmarks(
        await _cameraController!.takePicture() as CameraImage
      );
      
      if (landmarks != null && landmarks.length == 21) {
        final isAlif = await _alifDetector!.isAlif(landmarks);
        final confidence = await _alifDetector!.getAlifConfidence(landmarks);
        
        setState(() {
          _prediction = isAlif ? 'الف' : 'Not Alif';
          _confidence = confidence;
        });
      }
      
    } catch (e) {
      print('Processing error: $e');
    } finally {
      _isDetecting = false;
      _startDetectionLoop();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alif Detection ${_useFallback ? "(Demo Mode)" : ""}'),
        backgroundColor: const Color.fromARGB(255, 8, 4, 84),
        foregroundColor: Colors.white,
        actions: [
          if (_useFallback)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'DEMO',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
        ],
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
                  colors: [
                    const Color.fromARGB(255, 8, 4, 84),
                    const Color.fromARGB(255, 0, 109, 176),
                  ],
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
                  if (_useFallback)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '⚠️ Using demo mode (MediaPipe unavailable)',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            // Retry button
            if (_useFallback)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _retryMediaPipe,
                  child: const Text('Retry MediaPipe Loading'),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _retryMediaPipe() async {
    setState(() => _isMediaPipeLoading = true);
    
    final success = await _handDetector!.forceReloadMediaPipe();
    
    setState(() {
      _isMediaPipeLoading = false;
      _useFallback = !success;
    });
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('MediaPipe loaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('MediaPipe still unavailable. Using demo mode.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    _handDetector?.dispose();
    super.dispose();
  }
}