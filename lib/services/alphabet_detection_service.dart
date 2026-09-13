import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AlphabetDetectionService {
  // ✅ Current laptop IP is FIRST (fastest detection)
  // If IP changes again, just add the new one at the top.
  static const List<String> POSSIBLE_HOSTS = [
    'http://192.168.1.142:5000',   // ← current IP
    'http://192.168.100.7:5000',   // previous
    'http://192.168.1.62:5000',    // older
    'http://192.168.0.100:5000',
    'http://10.0.0.100:5000',
  ];

  static String? _activeBaseUrl;
  static const int PORT = 5000;

  // ============================================
  // AUTO-DETECT REACHABLE SERVER
  // ============================================
  static Future<String?> findServer() async {
    if (_activeBaseUrl != null) return _activeBaseUrl;

    print('🔎 Searching for server...');

    for (final host in POSSIBLE_HOSTS) {
      try {
        print('  Trying $host ...');
        final r = await http
            .get(Uri.parse('$host/ping'))
            .timeout(const Duration(seconds: 2));
        if (r.statusCode == 200) {
          _activeBaseUrl = host;
          print('✅ Found server at: $host');
          return host;
        }
      } catch (_) {
        // try next
      }
    }

    print('❌ No server found on any host');
    return null;
  }

  /// Force reset (e.g., after IP change)
  static void resetServer() {
    _activeBaseUrl = null;
  }

  static String get _base => _activeBaseUrl ?? POSSIBLE_HOSTS[0];
  static String get DETECT_URL => '$_base/detect';
  static String get PING_URL => '$_base/ping';
  static String get MODELS_URL => '$_base/models';

  // ============================================
  // PING SERVER
  // ============================================
  static Future<Map<String, dynamic>> pingServer() async {
    try {
      if (_activeBaseUrl == null) {
        await findServer();
      }
      if (_activeBaseUrl == null) {
        return {'connected': false, 'error': 'Server not found'};
      }

      final response = await http
          .get(Uri.parse(PING_URL))
          .timeout(const Duration(seconds: 3));
      return {'connected': response.statusCode == 200};
    } catch (e) {
      print('❌ Ping error: $e');
      return {'connected': false, 'error': e.toString()};
    }
  }

  // ============================================
  // DETECT ALPHABET
  // ============================================
  static Future<DetectionResult> detectAlphabet(
    Uint8List imageBytes, {
    required String alphabet,
  }) async {
    try {
      if (_activeBaseUrl == null) {
        await findServer();
      }
      if (_activeBaseUrl == null) {
        return DetectionResult.error('Server not found');
      }

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
            onTimeout: () => throw Exception('Timeout'),
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

// ============================================
// ALPHABET MODEL
// ============================================
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

// ============================================
// DETECTION RESULT
// ============================================
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