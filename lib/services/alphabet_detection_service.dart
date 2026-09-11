import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AlphabetDetectionService {
  static const String BASE_URL = 'http://192.168.1.62:5000';
  static const String DETECT_URL = '$BASE_URL/detect';
  static const String PING_URL = '$BASE_URL/ping';
  static const String MODELS_URL = '$BASE_URL/models';

  static Future<Map<String, dynamic>> pingServer() async {
    try {
      final response = await http.get(Uri.parse(PING_URL));
      return {'connected': response.statusCode == 200};
    } catch (e) {
      return {'connected': false, 'error': e.toString()};
    }
  }

  static Future<List<AlphabetModel>> getAvailableModels() async {
    try {
      final response = await http.get(Uri.parse(MODELS_URL));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List models = data['models'] ?? [];
        return models.map((m) => AlphabetModel.fromJson(m)).toList();
      }
    } catch (e) {
      print('Error getting models: $e');
    }
    return [];
  }

  static Future<DetectionResult> detectAlphabet(
    Uint8List imageBytes, {
    required String alphabet,
  }) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await http
          .post(
            Uri.parse(DETECT_URL),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'image': base64Image,
              'alphabet': alphabet,
            }),
          )
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw Exception('Connection timeout');
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

class AlphabetModel {
  final String name;
  final String display;
  final String arabic;

  AlphabetModel({
    required this.name,
    required this.display,
    required this.arabic,
  });

  factory AlphabetModel.fromJson(Map<String, dynamic> json) {
    return AlphabetModel(
      name: json['name'] ?? '',
      display: json['display'] ?? '',
      arabic: json['arabic'] ?? '',
    );
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
      landmarks: (json['landmarks'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [],
      alphabet: json['alphabet'] ?? '',
      display: json['display'] ?? '',
      message: json['message'] ?? '',
    );
  }

  factory DetectionResult.error(String message) {
    return DetectionResult(
      hasHand: false,
      isAlphabet: false,
      confidence: 0.0,
      message: message,
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