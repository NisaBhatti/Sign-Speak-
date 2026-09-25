import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AlphabetDetectionService {
  static const String BASE_URL =
      'https://pythonserversignspeak-production.up.railway.app';

  static Future<Map<String, dynamic>> pingServer() async {
    try {
      final url = '$BASE_URL/ping';
      print('🔌 PING: $url');
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20));
      print('🔌 PING: ${response.statusCode}');
      return {'connected': response.statusCode == 200};
    } catch (e) {
      print('❌ PING error: $e');
      return {'connected': false, 'error': e.toString()};
    }
  }

  static Future<DetectionResult> detectAlphabet(
    Uint8List imageBytes, {
    required String alphabet,
  }) async {
    try {
      final base64Image = base64Encode(imageBytes);
      print('🎯 POST detect alphabet=$alphabet bytes=${imageBytes.length}');

      final response = await http
          .post(
            Uri.parse('$BASE_URL/detect'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'image': base64Image,
              'alphabet': alphabet,
            }),
          )
          .timeout(const Duration(seconds: 30));

      print('🎯 Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DetectionResult.fromJson(data);
      }
      return DetectionResult.error('Server ${response.statusCode}');
    } catch (e) {
      print('❌ DETECT error: $e');
      return DetectionResult.error('$e');
    }
  }
}

class DetectionResult {
  final bool hasHand;
  final bool isAlphabet;
  final double confidence;
  final List<double> landmarks;
  final String alphabet;
  final String display;
  final String message;

  DetectionResult({
    required this.hasHand,
    required this.isAlphabet,
    required this.confidence,
    this.landmarks = const [],
    this.alphabet = '',
    this.display = '',
    this.message = '',
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      hasHand: json['hasHand'] ?? false,
      isAlphabet: json['isAlphabet'] ?? false,
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      landmarks: (json['landmarks'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      alphabet: json['alphabet'] ?? '',
      display: json['display'] ?? '',
      message: json['message'] ?? '',
    );
  }

  factory DetectionResult.error(String message) {
    return DetectionResult(
      hasHand: false, isAlphabet: false, confidence: 0.0, message: message,
    );
  }

  String get label {
    if (!hasHand) return '👋 Show your hand';
    if (isAlphabet) {
      return '✅ $display (${(confidence * 100).toStringAsFixed(0)}%)';
    }
    return '❌ Not $display (${(confidence * 100).toStringAsFixed(0)}%)';
  }
}