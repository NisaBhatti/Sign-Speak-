package com.example.signspeak

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // ❌ COMMENT OUT OR REMOVE THIS LINE
        // flutterEngine.plugins.add(HandDetectionPlugin())
    }
}