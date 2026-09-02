import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/hand_detection_service.dart';

class AlifDetectionPage extends StatefulWidget {
  const AlifDetectionPage({Key? key}) : super(key: key);

  @override
  State<AlifDetectionPage> createState() => _AlifDetectionPageState();
}

class _AlifDetectionPageState extends State<AlifDetectionPage> {
  DetectionResult _result = DetectionResult.empty();
  bool _isLoading = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    _isConnected = await HandDetectionService.ping();
    setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 640,
        maxHeight: 480,
      );
      
      if (image != null) {
        setState(() {
          _isLoading = true;
        });
        
        final bytes = await image.readAsBytes();
        final result = await HandDetectionService.processImage(bytes);
        
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = DetectionResult.empty();
        _isLoading = false;
      });
      print('Error picking image: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 640,
        maxHeight: 480,
      );
      
      if (image != null) {
        setState(() {
          _isLoading = true;
        });
        
        final bytes = await image.readAsBytes();
        final result = await HandDetectionService.processImage(bytes);
        
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = DetectionResult.empty();
        _isLoading = false;
      });
      print('Error taking photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isConnected ? Icons.cloud_done : Icons.cloud_off,
              color: _isConnected ? Colors.green : Colors.red,
            ),
            onPressed: _checkConnection,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Connection Status
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isConnected ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isConnected ? Colors.green : Colors.red,
                ),
              ),
              child: Text(
                _isConnected ? '✅ Plugin Connected' : '❌ Plugin Not Connected',
                style: TextStyle(
                  color: _isConnected ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: _result.hasHand
                  ? (_result.isAlif ? Colors.green.shade50 : Colors.red.shade50)
                  : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _result.hasHand
                    ? (_result.isAlif ? Colors.green : Colors.red)
                    : Colors.grey,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (!_result.hasHand)
                    const Icon(
                      Icons.handshake,
                      size: 80,
                      color: Colors.grey,
                    )
                  else
                    Icon(
                      _result.isAlif ? Icons.check_circle : Icons.cancel,
                      size: 80,
                      color: _result.isAlif ? Colors.green : Colors.red,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    _isLoading
                      ? 'Processing...'
                      : _result.hasHand
                        ? (_result.isAlif 
                          ? 'ALIF (ا) ✓'
                          : 'Not Alif ✗')
                        : 'No Hand Detected',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _result.hasHand
                        ? (_result.isAlif ? Colors.green : Colors.red)
                        : Colors.grey,
                    ),
                  ),
                  if (_result.hasHand) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: ${(_result.confidence * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (_result.hasHand) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Landmarks: ${_result.landmarks.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pick Image'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Status message
            if (_result is DetectionResult && _result.landmarks.isNotEmpty)
              Text(
                'Detected ${_result.landmarks.length} landmarks',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}