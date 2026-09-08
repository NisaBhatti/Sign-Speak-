import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class HandDetectionService {
  // ✅ YOUR IP ADDRESS FROM ipconfig
  static const String BASE_URL = 'http://192.168.1.62:5000';  // ← UPDATED!
  static const String DETECT_URL = '$BASE_URL/detect';
  static const String PING_URL = '$BASE_URL/ping';

  static Future<Map<String, dynamic>> pingServer() async {
    try {
      final response = await http.get(Uri.parse(PING_URL));
      return {'connected': response.statusCode == 200};
    } catch (e) {
      return {'connected': false, 'error': e.toString()};
    }
  }

  static Future<DetectionResult> detectHand(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await http
          .post(
            Uri.parse(DETECT_URL),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'image': base64Image}),
          )
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw Exception('Connection timeout - Server not responding');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DetectionResult.fromJson(data);
      } else {
        return DetectionResult.error('Server error: ${response.statusCode}');
      }
    } catch (e) {
      return DetectionResult.error('Connection error: $e');
    }
  }
}

class DetectionResult {
  final bool hasHand;
  final bool isAlif;
  final double confidence;
  final List<double> landmarks; // 42 values

  DetectionResult({
    required this.hasHand,
    required this.isAlif,
    required this.confidence,
    this.landmarks = const [],
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      hasHand: json['hasHand'] ?? false,
      isAlif: json['isAlif'] ?? false,
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      landmarks: (json['landmarks'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [],
    );
  }

  factory DetectionResult.error(String message) {
    return DetectionResult(
      hasHand: false,
      isAlif: false,
      confidence: 0.0,
    );
  }

  String get label {
    if (!hasHand) return '👋 Show your hand';
    return isAlif 
        ? '✅ ALIF (${(confidence * 100).toStringAsFixed(0)}%)' 
        : '❌ Not Alif (${(confidence * 100).toStringAsFixed(0)}%)';
  }
}