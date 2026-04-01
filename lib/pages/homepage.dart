import 'package:flutter/material.dart';
import 'camera_access_screen.dart';
import 'dictionary.dart';
import 'drawer_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Color scheme matching your sign-up screen
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color color4 = Color(0xFF6CC2C0);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      drawer: const DrawerPage(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
            stops: const [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with hamburger menu on left
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Hamburger menu on left - FIXED: Using Builder widget
                    Builder(
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: marineBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // FIXED: Open drawer using the context from Builder
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(Icons.menu, color: marineBlue, size: 22),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ),
                    ),

                    // App title in center
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Signs Speak',
                        style: TextStyle(
                          color: lightBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Empty container to maintain balance
                    Container(
                      width: 48, // Same width as left icon for symmetry
                    ),
                  ],
                ),
              ),

              // Welcome Text
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What would you like\nto do today?',
                      style: TextStyle(
                        color: marineBlue,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Feature Cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 1st: Real-Time Signs - Navigates to CameraScreen
                      _buildSmallFeatureCard(
                        title: 'Real-Time Signs',
                        subtitle: 'Start camera detection',
                        icon: Icons.videocam_outlined,
                        gradient: LinearGradient(
                          colors: [marineBlue.withOpacity(0.9), color2],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraAccessScreen(),
                            ),
                          );
                        },
                      ),

                      // 2nd: Signs Dictionary
                      _buildSmallFeatureCard(
                        title: 'Signs Dictionary',
                        subtitle: 'Browse over 1,000 signs',
                        icon: Icons.menu_book_outlined,
                        gradient: LinearGradient(
                          colors: [marineBlue, lightBlue],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DictionaryPage(),
                            ),
                          );
                        },
                      ),

                      // 3rd: Favorites
                      _buildSmallFeatureCard(
                        title: 'Favorites',
                        subtitle: 'Access your saved phrases',
                        icon: Icons.favorite_border,
                        gradient: LinearGradient(
                          colors: [marineBlue.withOpacity(0.9), lightBlue],
                        ),
                        onTap: () {
                          print('Favorites tapped');
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Small bottom padding
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: marineBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}