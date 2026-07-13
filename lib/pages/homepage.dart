import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'camera_access_screen.dart';
import 'dictionary.dart';
import 'drawer_page.dart';
import 'pages/alif_detection_page.dart';   // ← new import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Colors
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerPage(),
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
              // App bar
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: marineBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        icon: Icon(Icons.menu, color: marineBlue, size: 22),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ),
                    Text(
                      'Signs Speak',
                      style: TextStyle(color: lightBlue, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48), // symmetry
                  ],
                ),
              ),
              // Welcome text
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Text(
                  'What would you like to do today?',
                  style: TextStyle(
                    color: marineBlue.withOpacity(0.7),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Feature cards – now scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // 1. Real-Time Translation
                      _buildFeatureCard(
                        title: 'Real-Time Translation',
                        subtitle: 'Live camera detection',
                        description: 'Recognise signs instantly with your camera.',
                        icon: Icons.videocam_outlined,
                        gradient: LinearGradient(
                          colors: [marineBlue.withOpacity(0.9), lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CameraAccessScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // 2. Sign Book
                      _buildFeatureCard(
                        title: 'Sign Book',
                        subtitle: 'Browse 500+ signs',
                        description: 'Search the complete dictionary.',
                        icon: Icons.menu_book_outlined,
                        gradient: LinearGradient(
                          colors: [lightBlue, marineBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DictionaryPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // 3. Fav Signs
                      _buildFeatureCard(
                        title: 'Fav Signs',
                        subtitle: 'Your saved signs',
                        description: 'Quick access to favourite signs.',
                        icon: Icons.favorite_border,
                        gradient: LinearGradient(
                          colors: [marineBlue.withOpacity(0.9), lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          if (isGuest) {
                            _showGuestDialog();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Favorites feature coming soon!'),
                                backgroundColor: Color.fromARGB(255, 0, 94, 255),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // 4. Alif Detection Screen
                      _buildFeatureCard(
                        title: 'Alif Detection',
                        subtitle: 'Urdu Sign Detection',
                        description: 'Detect Alif and other signs with your model.',
                        icon: Icons.auto_awesome,  // or Icons.accessibility_new
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AlifDetectionPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
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
        height: 120,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: marineBlue.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(description,
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.8), size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGuestDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Guest Mode'),
          ],
        ),
        content: const Text('Sign in to save your favourite signs and access them across devices!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: marineBlue),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}