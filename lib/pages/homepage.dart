import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'camera_access_screen.dart';
import 'dictionary.dart';
import 'drawer_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Color scheme matching your app
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);
  
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? userName;
  String? userEmail;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      try {
        // Try to get user data from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists) {
          setState(() {
            userData = doc.data();
            userName = userData?['name'] ?? user.displayName;
            userEmail = userData?['email'] ?? user.email;
            isLoading = false;
          });
        } else {
          // If no Firestore document, use Firebase Auth data
          setState(() {
            userName = user.displayName;
            userEmail = user.email;
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
        setState(() {
          userName = user.displayName;
          userEmail = user.email;
          isLoading = false;
        });
      }
    } else {
      // Guest user
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null;
    
    return Scaffold(
      backgroundColor: color1,
      drawer: DrawerPage(
        userName: userName ?? (isGuest ? null : 'User'),
        userEmail: userEmail,
        isGuest: isGuest,
        onSignOut: () => _signOut(context),
      ),
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
                    // Hamburger menu on left
                    Builder(
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: marineBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
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
                    
                    // Empty container for balance (right side)
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Feature Cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1st: Real-Time Signs
                      _buildFeatureCard(
                        title: 'Real-Time Signs',
                        subtitle: 'Start camera detection',
                        description: 'Translate sign language in real-time',
                        icon: Icons.videocam_outlined,
                        gradient: LinearGradient(
                          colors: [marineBlue, marineBlue.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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
                      
                      const SizedBox(height: 16),
                      
                      // 2nd: Signs Dictionary
                      _buildFeatureCard(
                        title: 'Signs Dictionary',
                        subtitle: 'Browse over 1,000 signs',
                        description: 'Learn and practice sign language',
                        icon: Icons.menu_book_outlined,
                        gradient: LinearGradient(
                          colors: [lightBlue, marineBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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
                      
                      const SizedBox(height: 16),
                      
                      // 3rd: Favorites
                      _buildFeatureCard(
                        title: 'Favorites',
                        subtitle: 'Access your saved phrases',
                        description: isGuest 
                            ? 'Sign in to save favorites'
                            : 'Quick access to your favorite signs',
                        icon: Icons.favorite_border,
                        gradient: LinearGradient(
                          colors: [marineBlue, lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          if (isGuest) {
                            _showGuestDialog();
                          } else {
                            // Navigate to favorites page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Favorites feature coming soon!'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
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
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
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
  
  void _showGuestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Guest Mode'),
            ],
          ),
          content: const Text(
            'Sign in to save your favorite signs and access them across devices!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: marineBlue,
              ),
              child: const Text('Sign In'),
            ),
          ],
        );
      },
    );
  }
}