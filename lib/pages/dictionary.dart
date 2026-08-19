import 'package:flutter/material.dart';
import 'words_page.dart';  

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  // Colors matching Home Screen
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
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
              // App bar with back button - matching Home Screen style
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
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: marineBlue, size: 22),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ),
                    Text(
                      'Dictionary',
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // symmetry
                  ],
                ),
              ),
              
              // Welcome text
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Text(
                  'Learn Sign Language',
                  style: TextStyle(
                    color: marineBlue.withOpacity(0.7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Feature cards
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      // 1. Words Button - UPDATED WITH NAVIGATION
                      _buildFeatureCard(
                        title: 'Words',
                        subtitle: 'Learn Common Words',
                        description: 'Explore common sign language words.',
                        icon: Icons.menu_book,
                        gradient: LinearGradient(
                          colors: [marineBlue.withOpacity(0.9), lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          // 👇 YEH LINE UPDATE HUI HAI - AB WORDS PAGE OPEN HOGA
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WordsPage(),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 2. A to Z & الف تا یئ (Combined Button)
                      _buildFeatureCard(
                        title: 'A to Z / الف تا یئ',
                        subtitle: 'English & Urdu Signs',
                        description: 'Learn signs from A to Z and الف to یئ.',
                        icon: Icons.abc,
                        gradient: LinearGradient(
                          colors: [marineBlue.withOpacity(0.9), lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('A to Z & Urdu signs feature coming soon!'),
                              backgroundColor: Color.fromARGB(255, 0, 109, 176),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 3. Videos Button
                      _buildFeatureCard(
                        title: 'Videos',
                        subtitle: 'Video Tutorials',
                        description: 'Watch sign language video tutorials.',
                        icon: Icons.video_library,
                        gradient: LinearGradient(
                          colors: [marineBlue.withOpacity(0.9), lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Videos feature coming soon!'),
                              backgroundColor: Color.fromARGB(255, 0, 109, 176),
                            ),
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
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
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
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}