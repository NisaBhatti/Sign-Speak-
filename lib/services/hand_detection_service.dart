import 'dart:typed_data';
import 'package:flutter/services.dart';

class HandDetectionService {
  static const MethodChannel _channel = MethodChannel('hand_detection');
  
  // Method 1: Detect hand from image bytes
  static Future<DetectionResult> processImage(Uint8List imageBytes) async {
    try {
      final result = await _channel.invokeMethod('detectHand', {
        'imageBytes': imageBytes,
      });
      
      if (result != null) {
        return DetectionResult.fromMap(result as Map<dynamic, dynamic>);
      }
    } on PlatformException catch (e) {
      print('❌ Failed to detect hand: ${e.message}');
    } catch (e) {
      print('❌ Error: $e');
    }
    
    return DetectionResult.empty();
  }
  
  // Method 2: Simple ping to test connection
  static Future<bool> ping() async {
    try {
      final result = await _channel.invokeMethod('ping');
      return result == 'pong';
    } catch (e) {
      return false;
    }
  }
}

class DetectionResult {
  final bool hasHand;
  final bool isAlif;
  final double confidence;
  final List<List<double>> landmarks;
  
  DetectionResult({
    required this.hasHand,
    required this.isAlif,
    required this.confidence,
    this.landmarks = const [],
  });
  
  factory DetectionResult.fromMap(Map<dynamic, dynamic> map) {
    return DetectionResult(
      hasHand: map['hasHand'] ?? false,
      isAlif: map['isAlif'] ?? false,
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      landmarks: (map['landmarks'] as List?)?.map((e) =>
        (e as List).map((v) => (v as num).toDouble()).toList()
      ).toList() ?? [],
    );
  }
  
  factory DetectionResult.empty() {
    return DetectionResult(
      hasHand: false,
      isAlif: false,
      confidence: 0.0,
    );
  }
}