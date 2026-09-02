import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../services/tflite_service.dart';

class RealtimeDetectionPage extends StatefulWidget {
  const RealtimeDetectionPage({Key? key}) : super(key: key);

  @override
  State<RealtimeDetectionPage> createState() => _RealtimeDetectionPageState();
}

class _RealtimeDetectionPageState extends State<RealtimeDetectionPage> {
  CameraController? _controller;
  DetectionResult _result = DetectionResult.empty();
  bool _isProcessing = false;
  bool _isModelLoaded = false;
  int _frameCount = 0;
  double _fps = 0.0;
  DateTime _lastFpsUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await TFLiteService.loadModels();
    _isModelLoaded = true;
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
      print('Error initializing camera: $e');
    }
  }

  // ============================================
  // 🔥 FIXED: Convert CameraImage to JPEG bytes
  // ============================================
  Future<Uint8List?> _convertCameraImageToBytes(CameraImage image) async {
    try {
      // Get image dimensions
      final width = image.width;
      final height = image.height;
      
      // Create a buffer for RGB image
      Uint8List rgbBytes = Uint8List(width * height * 3);
      
      if (image.format.group == ImageFormatGroup.yuv420) {
        // YUV420 format - most common
        final yPlane = image.planes[0];
        final uPlane = image.planes[1];
        final vPlane = image.planes[2];
        
        int rgbIndex = 0;
        
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            // Y value
            final yValue = yPlane.bytes[y * yPlane.bytesPerRow + x] & 0xFF;
            
            // UV values (4:2:0 subsampling)
            final uvX = x ~/ 2;
            final uvY = y ~/ 2;
            final uValue = uPlane.bytes[uvY * uPlane.bytesPerRow + uvX] & 0xFF;
            final vValue = vPlane.bytes[uvY * vPlane.bytesPerRow + uvX] & 0xFF;
            
            // Convert YUV to RGB
            int r = (yValue + 1.402 * (vValue - 128)).round();
            int g = (yValue - 0.344 * (uValue - 128) - 0.714 * (vValue - 128)).round();
            int b = (yValue + 1.772 * (uValue - 128)).round();
            
            // Clamp RGB values
            rgbBytes[rgbIndex++] = r.clamp(0, 255).toInt();
            rgbBytes[rgbIndex++] = g.clamp(0, 255).toInt();
            rgbBytes[rgbIndex++] = b.clamp(0, 255).toInt();
          }
        }
        
        // Convert RGB bytes to Image
        final imgImage = img.Image.fromBytes(
          width: width,
          height: height,
          bytes: rgbBytes.buffer,
          numChannels: 3,
        );
        
        // Encode to JPEG
        final jpegBytes = img.encodeJpg(imgImage);
        return Uint8List.fromList(jpegBytes);
        
      } else {
        print('⚠️ Unsupported format: ${image.format.group}');
        return null;
      }
      
    } catch (e) {
      print('❌ Image conversion error: $e');
      return null;
    }
  }

  void _processCameraImage(CameraImage image) {
    if (_isProcessing || !_isModelLoaded) return;
    _isProcessing = true;
    
    // Calculate FPS
    _frameCount++;
    final now = DateTime.now();
    if (now.difference(_lastFpsUpdate) > const Duration(seconds: 1)) {
      _fps = _frameCount.toDouble();
      _frameCount = 0;
      _lastFpsUpdate = now;
      if (mounted) setState(() {});
    }
    
    // Convert camera image to JPEG bytes
    _convertCameraImageToBytes(image).then((jpegBytes) {
      if (jpegBytes != null && mounted) {
        print('📷 Image converted: ${jpegBytes.length} bytes');
        
        // Send to TFLite
        TFLiteService.predictFromImage(jpegBytes).then((result) {
          if (mounted) {
            setState(() {
              _result = result;
            });
          }
          _isProcessing = false;
        }).catchError((e) {
          print('❌ Prediction error: $e');
          _isProcessing = false;
        });
      } else {
        _isProcessing = false;
      }
    }).catchError((e) {
      print('❌ Conversion error: $e');
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    TFLiteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Alif Detection'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          Icon(
            _isModelLoaded ? Icons.check_circle : Icons.error,
            color: _isModelLoaded ? Colors.green : Colors.red,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            CameraPreview(_controller!),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
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
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      _result.hasHand
                        ? (_result.isAlif 
                          ? '✅ ALIF ${(_result.confidence * 100).toStringAsFixed(0)}%'
                          : '❌ Not Alif ${(_result.confidence * 100).toStringAsFixed(0)}%')
                        : '👋 Show your hand',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      _result.message.isNotEmpty ? _result.message : 'Processing...',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FPS: ${_fps.toStringAsFixed(1)} | Features: ${_result.featuresCount}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    if (_result.error.isNotEmpty)
                      Text(
                        'Error: ${_result.error}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}