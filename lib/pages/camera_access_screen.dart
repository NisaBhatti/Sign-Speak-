import 'package:flutter/material.dart';
import 'live_camera.dart';

class CameraAccessScreen extends StatefulWidget {
  const CameraAccessScreen({super.key});

  @override
  State<CameraAccessScreen> createState() => _CameraAccessScreenState();
}

class _CameraAccessScreenState extends State<CameraAccessScreen> {
  // Updated color palette from file
  static const Color color1 = Color(0xFFCFE8EA);   // #cfe8ea - Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // #acd9d9 - Light teal
  static const Color darkBlue = Color.fromARGB(255, 25, 19, 132); // Dark Blue

  void _handleAllowAccess() {
    // Handle camera permission logic
    debugPrint('Camera access allowed');
    // Navigate to camera screen or home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LiveCameraPage()),
    );
  }

  void _handleMaybeLater() {
    // Handle later option
    debugPrint('Camera access postponed');
    // Navigate back or to home screen without camera access
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color1, // Light blue-green at top
              color2, // Light teal at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon - CIRCULAR
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        darkBlue,
                        darkBlue, // Dark Blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(60), // CIRCULAR
                    boxShadow: [
                      BoxShadow(
                        color: darkBlue.withOpacity(0.3), // Dark Blue shadow
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: darkBlue, // Dark Blue border
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white, // White icon
                    size: 50,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Camera Access',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 8, 4, 84), // Dark Blue text
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Our app needs access to your camera to translate sign language in real-time. We will never record or store any video.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 109, 176), // marine text
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Buttons
                Column(
                  children: [
                    // Allow Access Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 8, 4, 84), // White background
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: darkBlue.withOpacity(0.4), // Dark Blue shadow
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: darkBlue.withOpacity(0.3), // Subtle border
                          width: 1.5,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _handleAllowAccess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Allow Access',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255), // Dark Blue text
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.015,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Maybe Later Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 8, 4, 84), // White background
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: darkBlue.withOpacity(0.5), // Dark Blue border
                          width: 2,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _handleMaybeLater,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Maybe Later',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255), // Dark Blue text
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.015,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}