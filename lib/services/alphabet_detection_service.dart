import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AlphabetDetectionService {
  // ============================================
  // BOTH SERVERS — tried in this order
  // 1. Local laptop (Wi-Fi) — used when developing
  // 2. Railway cloud — used when laptop is off / phone is on mobile data
  // ============================================
  static const List<String> POSSIBLE_HOSTS = [
    'http://192.168.100.7:5000',              // Local laptop (Wi-Fi)
    'https://signspeaks.nutrispherepk.site',  // Railway cloud
  ];

  static String? _activeBaseUrl;

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
            .timeout(const Duration(seconds: 5));
        if (r.statusCode == 200) {
          _activeBaseUrl = host;
          print('✅ Using server: $host');
          return host;
        }
      } catch (_) {
        // try next
      }
    }

    print('❌ No server reachable');
    return null;
  }

  static void resetServer() => _activeBaseUrl = null;

  static String get _base => _activeBaseUrl ?? POSSIBLE_HOSTS[0];

  // ============================================
  // PING SERVER
  // ============================================
  static Future<Map<String, dynamic>> pingServer() async {
    try {
      if (_activeBaseUrl == null) {
        await findServer();
      }
      if (_activeBaseUrl == null) {
        return {'connected': false, 'error': 'No server found'};
      }

      final cacheBuster = DateTime.now().millisecondsSinceEpoch;
      final url = '$_base/ping?t=$cacheBuster';
      print('🔌 PING: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      print('🔌 PING: ${response.statusCode}');
      return {'connected': response.statusCode == 200};
    } catch (e) {
      print('❌ PING error: $e');
      return {'connected': false, 'error': e.toString()};
    }
  }

  // ============================================
  // PRELOAD MODEL
  // ============================================
  static Future<void> preloadModel(String alphabet) async {
    try {
      if (_activeBaseUrl == null) {
        await findServer();
      }
      if (_activeBaseUrl == null) return;

      final cacheBuster = DateTime.now().millisecondsSinceEpoch;
      final url = '$_base/warmup/$alphabet?t=$cacheBuster';
      print('🔥 Preloading $alphabet');

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      print('🔥 Preload: ${response.statusCode} — ${response.body}');
    } catch (e) {
      print('⚠️ Preload failed: $e');
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
        return DetectionResult.error('No server reachable');
      }

      final base64Image = base64Encode(imageBytes);
      print('🎯 POST detect alphabet=$alphabet bytes=${imageBytes.length}');

      final response = await http
          .post(
            Uri.parse('$_base/detect'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'image': base64Image,
              'alphabet': alphabet,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Timeout'),
          );

      print('🎯 Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lmCount = (data['landmarks'] as List?)?.length ?? 0;
        print('🎯 hasHand=${data['hasHand']} '
            'isAlphabet=${data['isAlphabet']} '
            'landmarks=$lmCount '
            'msg=${data['message']}');
        return DetectionResult.fromJson(data);
      }
      return DetectionResult.error('Server ${response.statusCode}');
    } catch (e) {
      print('❌ DETECT error: $e');
      return DetectionResult.error('$e');
    }
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