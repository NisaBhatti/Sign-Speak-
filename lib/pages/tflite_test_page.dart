import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/tflite_service.dart';

class TFLiteTestPage extends StatefulWidget {
  const TFLiteTestPage({Key? key}) : super(key: key);

  @override
  State<TFLiteTestPage> createState() => _TFLiteTestPageState();
}

class _TFLiteTestPageState extends State<TFLiteTestPage> {
  DetectionResult _result = DetectionResult.empty();
  bool _isLoading = false;
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    TFLiteService.close();
    super.dispose();
  }

  Future<void> _initialize() async {
    setState(() => _isLoading = true);
    
    await TFLiteService.loadModel();
    _isModelLoaded = true;
    
    final result = await TFLiteService.testWithDummy();
    
    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 640,
        maxHeight: 480,
      );
      
      if (image != null) {
        setState(() => _isLoading = true);
        
        final bytes = await image.readAsBytes();
        final prediction = await TFLiteService.predictFromImage(bytes);
        
        setState(() {
          _result = DetectionResult(
            hasHand: true,
            isAlif: prediction > 0.5,
            confidence: prediction,
            featuresCount: 42,
            message: 'Prediction from image',
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = DetectionResult.error('Error: $e');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TFLite Test'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          Icon(
            _isModelLoaded ? Icons.check_circle : Icons.error,
            color: _isModelLoaded ? Colors.green : Colors.red,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Model Status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isModelLoaded ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isModelLoaded ? Icons.check_circle : Icons.error,
                    color: _isModelLoaded ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isModelLoaded ? '✅ Model Loaded' : '❌ Model Not Loaded',
                    style: TextStyle(
                      color: _isModelLoaded ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Result
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
              child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Icon(
                        _result.hasHand
                          ? (_result.isAlif ? Icons.check_circle : Icons.cancel)
                          : Icons.handshake,
                        size: 60,
                        color: _result.hasHand
                          ? (_result.isAlif ? Colors.green : Colors.red)
                          : Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _result.isSuccess
                          ? (_result.hasHand
                              ? (_result.isAlif ? '✅ ALIF' : '❌ Not Alif')
                              : '🤚 No Hand')
                          : '⚠️ ${_result.error}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _result.hasHand
                            ? (_result.isAlif ? Colors.green : Colors.red)
                            : Colors.grey,
                        ),
                      ),
                      if (_result.hasHand)
                        Text(
                          'Confidence: ${(_result.confidence * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                      if (_result.featuresCount > 0)
                        Text(
                          'Features: ${_result.featuresCount}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      if (_result.message.isNotEmpty)
                        Text(
                          _result.message,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
            ),
            
            const SizedBox(height: 40),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Test with Image'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Using tflite_flutter package',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Model: alif_robust.tflite',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
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