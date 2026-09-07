import 'package:flutter/material.dart';
import 'live_camera.dart'; // Make sure this import matches your live camera file name

class CameraAccessScreen extends StatefulWidget {
  const CameraAccessScreen({super.key});

  @override
  State<CameraAccessScreen> createState() => _CameraAccessScreenState();
}

class _CameraAccessScreenState extends State<CameraAccessScreen> {
  // Colors matching the home page
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar with back button
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: marineBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: marineBlue, size: 22),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ),
                    Text(
                      'Real-Time Translation',
                      style: TextStyle(color: lightBlue, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Welcome text
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Text(
                  'Choose translation mode',
                  style: TextStyle(
                    color: marineBlue.withValues(alpha: 0.7),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Feature cards
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      // 1. Alphabet Translation - Goes to Live Camera
                      _buildFeatureCard(
                        title: 'Alphabet',
                        subtitle: 'English & Urdu Signs detection',
                        description: 'Recognise individual letters in real-time.',
                        icon: Icons.abc,
                        gradient: LinearGradient(
                          colors: [marineBlue.withValues(alpha: 0.9), lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LiveCameraPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // 2. Word Translation - Coming Soon
                      _buildFeatureCard(
                        title: 'Word',
                        subtitle: 'Learn Common Words',
                        description: 'Explore common sign language words.',
                        icon: Icons.menu_book,
                        gradient: LinearGradient(
                          colors: [marineBlue.withValues(alpha: 0.9), lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Word translation feature coming soon!'),
                              backgroundColor: Color.fromARGB(255, 0, 94, 255),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Gradient gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: marineBlue.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        )),
                    const SizedBox(height: 4), // Reduced from 6 to 4
                    Text(subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85), 
                          fontSize: 12, // Reduced from 14 to 12
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 2), // Reduced from 4 to 2
                    Text(description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7), 
                          fontSize: 10, // Reduced from 12 to 10
                        )),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward, 
                  color: Colors.white.withValues(alpha: 0.8), 
                  size: 20
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}