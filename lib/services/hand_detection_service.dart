import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

class HandDetectionService {
  static const MethodChannel _channel = MethodChannel('hand_detection');
  
  // Process image bytes
  static Future<DetectionResult> processImage(Uint8List imageBytes) async {
    try {
      final result = await _channel.invokeMethod('processFrame', {
        'imageBytes': imageBytes,
      });
      
      if (result != null) {
        return DetectionResult.fromMap(result as Map<dynamic, dynamic>);
      }
    } on PlatformException catch (e) {
      print('Failed to process image: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
    
    return DetectionResult.empty();
  }
  
  // Get landmarks only
  static Future<List<List<double>>> detectLandmarks(Uint8List imageBytes) async {
    try {
      final result = await _channel.invokeMethod('detectLandmarks', {
        'imageBytes': imageBytes,
      });
      
      if (result != null && result is List) {
        return result.map((list) => 
          (list as List).map((e) => (e as num).toDouble()).toList()
        ).toList();
      }
    } on PlatformException catch (e) {
      print('Failed to detect landmarks: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
    
    return [];
  }
}

class DetectionResult {
  final bool isAlif;
  final double confidence;
  final bool hasHand;
  final List<List<double>> landmarks;
  
  DetectionResult({
    required this.isAlif,
    required this.confidence,
    required this.hasHand,
    required this.landmarks,
  });
  
  factory DetectionResult.fromMap(Map<dynamic, dynamic> map) {
    return DetectionResult(
      isAlif: map['isAlif'] ?? false,
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      hasHand: map['hasHand'] ?? false,
      landmarks: (map['landmarks'] as List?)?.map((e) => 
        (e as List).map((v) => (v as num).toDouble()).toList()
      ).toList() ?? [],
    );
  }
  
  factory DetectionResult.empty() {
    return DetectionResult(
      isAlif: false,
      confidence: 0.0,
      hasHand: false,
      landmarks: [],
    );
  }
}