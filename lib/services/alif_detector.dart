import 'package:flutter/services.dart';

class AlifDetector {
  static final AlifDetector _instance = AlifDetector._internal();
  factory AlifDetector() => _instance;
  AlifDetector._internal();

  bool _isInitialized = false;
  static const double THRESHOLD = 0.5;
  
  final List<double> _predictionHistory = [];
  static const int SMOOTHING_WINDOW = 10;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _isInitialized = true;
      print('✅ AlifDetector initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize: $e');
      rethrow;
    }
  }

  Future<bool> isAlif(List<Offset> landmarks) async {
    if (!_isInitialized || landmarks.length != 21) {
      return false;
    }

    double confidence = _calculateAlifScore(landmarks);
    _addToHistory(confidence);
    double smoothedScore = _getSmoothedScore();
    
    return smoothedScore > THRESHOLD;
  }
  
  Future<double> getAlifConfidence(List<Offset> landmarks) async {
    if (!_isInitialized || landmarks.length != 21) {
      return 0.0;
    }
    
    double confidence = _calculateAlifScore(landmarks);
    _addToHistory(confidence);
    
    return _getSmoothedScore();
  }

  double _calculateAlifScore(List<Offset> landmarks) {
    // Check if index finger is up (Alif sign)
    // Landmark indices: 
    // 4 = thumb tip, 8 = index tip, 12 = middle tip, 16 = ring tip, 20 = pinky tip
    
    if (landmarks.length < 21) return 0.0;
    
    // Get finger tip positions
    double indexTipY = landmarks[8].dy;
    double middleTipY = landmarks[12].dy;
    double ringTipY = landmarks[16].dy;
    double pinkyTipY = landmarks[20].dy;
    
    // Get finger base positions (MCP joints)
    double indexBaseY = landmarks[5].dy;
    double middleBaseY = landmarks[9].dy;
    double ringBaseY = landmarks[13].dy;
    double pinkyBaseY = landmarks[17].dy;
    
    // Check if index finger is extended (tip above base)
    bool indexUp = indexTipY < indexBaseY;
    
    // Check if other fingers are folded (tip below or near base)
    bool middleFolded = middleTipY > middleBaseY - 0.05;
    bool ringFolded = ringTipY > ringBaseY - 0.05;
    bool pinkyFolded = pinkyTipY > pinkyBaseY - 0.05;
    
    // Calculate score based on Alif criteria
    double score = 0.0;
    
    if (indexUp) score += 0.6;
    if (middleFolded) score += 0.15;
    if (ringFolded) score += 0.15;
    if (pinkyFolded) score += 0.10;
    
    return score;
  }

  void _addToHistory(double score) {
    _predictionHistory.add(score);
    if (_predictionHistory.length > SMOOTHING_WINDOW) {
      _predictionHistory.removeAt(0);
    }
  }

  double _getSmoothedScore() {
    if (_predictionHistory.isEmpty) return 0.0;
    return _predictionHistory.reduce((a, b) => a + b) / _predictionHistory.length;
  }

  void dispose() {
    _isInitialized = false;
  }
}