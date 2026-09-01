import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../services/hand_detection_service.dart';

class AlifDetectionScreen extends StatefulWidget {
  const AlifDetectionScreen({Key? key}) : super(key: key);

  @override
  State<AlifDetectionScreen> createState() => _AlifDetectionScreenState();
}

class _AlifDetectionScreenState extends State<AlifDetectionScreen> {
  DetectionResult _result = DetectionResult.empty();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
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
      print('Error picking image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
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
      print('Error taking photo: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection Test'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  Icon(
                    _result.hasHand 
                      ? (_result.isAlif ? Icons.check_circle : Icons.cancel)
                      : Icons.handshake,
                    size: 80,
                    color: _result.hasHand 
                      ? (_result.isAlif ? Colors.green : Colors.red)
                      : Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _result.hasHand
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
                      'Landmarks Detected: ${_result.landmarks.length}/21',
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
            
            if (_isLoading) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}