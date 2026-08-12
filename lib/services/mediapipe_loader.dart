// lib/services/mediapipe_loader.dart
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ml_kit;

class MediaPipeLoader {
  static bool _isLoaded = false;
  static bool _isLoading = false;
  static Completer<bool>? _loadCompleter;
  
  /// Force load MediaPipe with retry
  static Future<bool> forceLoadMediaPipe({int maxRetries = 3}) async {
    if (_isLoaded) return true;
    if (_isLoading) {
      return _loadCompleter!.future;
    }
    
    _isLoading = true;
    _loadCompleter = Completer<bool>();
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('🔄 Loading MediaPipe - Attempt $attempt/$maxRetries');
        
        // Method 1: Try standard import
        try {
          final detector = ml_kit.GoogleMlKit.vision.handDetector();
          await detector.close();
          _isLoaded = true;
          print('✅ MediaPipe loaded successfully!');
          _loadCompleter!.complete(true);
          return true;
        } catch (e) {
          print('⚠️ Standard loading failed: $e');
        }
        
        // Method 2: Try via MethodChannel
        try {
          const platform = MethodChannel('com.signspeak/mediapipe');
          final bool result = await platform.invokeMethod('loadMediaPipe');
          if (result) {
            _isLoaded = true;
            print('✅ MediaPipe loaded via MethodChannel!');
            _loadCompleter!.complete(true);
            return true;
          }
        } catch (e) {
          print('⚠️ MethodChannel loading failed: $e');
        }
        
        // Method 3: Try via System.loadLibrary (Android only)
        try {
          if (Platform.isAndroid) {
            // Force load native libraries
            await _loadNativeLibraries();
            _isLoaded = true;
            print('✅ MediaPipe loaded via native libraries!');
            _loadCompleter!.complete(true);
            return true;
          }
        } catch (e) {
          print('⚠️ Native library loading failed: $e');
        }
        
        // Wait before retry
        if (attempt < maxRetries) {
          await Future.delayed(Duration(seconds: attempt));
        }
        
      } catch (e) {
        print('❌ Attempt $attempt failed: $e');
        if (attempt == maxRetries) {
          _loadCompleter!.complete(false);
          return false;
        }
      }
    }
    
    _isLoading = false;
    _loadCompleter!.complete(false);
    return false;
  }
  
  /// Load native libraries (Android only)
  static Future<void> _loadNativeLibraries() async {
    try {
      // Try to load required native libraries
      const platform = MethodChannel('com.signspeek/mediapipe');
      await platform.invokeMethod('loadNativeLibraries');
    } catch (e) {
      print('Native library load error: $e');
      rethrow;
    }
  }
  
  /// Check if MediaPipe is loaded
  static bool isLoaded() => _isLoaded;
  
  /// Reset loading state
  static void reset() {
    _isLoaded = false;
    _isLoading = false;
    _loadCompleter = null;
  }
}