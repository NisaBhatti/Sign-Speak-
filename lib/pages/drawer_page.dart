import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'intro_screen.dart';
import 'profile.dart';
import 'history.dart'; 
import 'settings.dart';
import 'login.dart';

// Define color constants at the top level for global access
const Color drawerColor1 = Color(0xFFCFE8EA);
const Color drawerColor2 = Color(0xFFACD9D9);
const Color drawerColor3 = Color(0xFFB6C2C3);
const Color drawerColor4 = Color(0xFF6CC2C0);
const Color drawerDarkBlue = Color.fromARGB(255, 8, 4, 84);

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close when tapping outside
        },
        child: Container(
          color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping on drawer
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: const CustomDrawer(),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class CustomDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final bool isGuest;
  final VoidCallback? onSignOut;

  const CustomDrawer({
    super.key,
    this.userName,
    this.userEmail,
    this.isGuest = false,
    this.onSignOut,
  });

  Future<void> _logout(BuildContext context) async {
    try {
      if (onSignOut != null) {
        onSignOut!(); // Call the sign out function from parent
      } else {
        // Fallback logout if no callback provided
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          // Navigate to welcome screen and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged out successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void navigateAndCloseDrawer(BuildContext context, Widget page) {
    Navigator.pop(context); // Close drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            drawerColor1,
            drawerColor2,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header with User Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  drawerDarkBlue.withOpacity(0.9),
                  drawerColor4.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    const Text(
                      'Signs Speak',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16),
                
                // Home Menu Item
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: drawerDarkBlue, // Dark Blue
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: drawerDarkBlue, // Dark Blue
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppIntroDocument(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: drawerDarkBlue, // Dark Blue
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: drawerDarkBlue, // Dark Blue
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close drawer page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettingsPage(),
                      ),
                    );
                  },
                ),
                
                // History Menu Item
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: drawerDarkBlue, // Dark Blue
                  ),
                  title: Text(
                    'History',
                    style: TextStyle(
                      color: drawerDarkBlue, // Dark Blue
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close drawer page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TranslationHistoryScreen(),
                      ),
                    );
                  },
                ),
                // Settings Menu Item
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: drawerDarkBlue, // Dark Blue
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: drawerDarkBlue, // Dark Blue
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close drawer page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
               // Divider before Logout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Divider(
                    color: Color.fromARGB(255, 8, 4, 84), // Dark Blue
                    thickness: 0.5,
                  ),
                ),
      // Logout/Sign In Menu Item
                if (!isGuest)
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      Navigator.pop(context); // Close drawer first
                      _showLogoutDialog(context);
                    },
                  )
                else
                  _buildDrawerItem(
                    icon: Icons.login,
                    title: 'Sign In',
                    iconColor: drawerDarkBlue,
                    textColor: drawerDarkBlue,
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: drawerDarkBlue.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: drawerDarkBlue.withOpacity(0.6),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2024 Signs Speak',
                  style: TextStyle(
                    color: drawerDarkBlue.withOpacity(0.5),
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? drawerDarkBlue,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? drawerDarkBlue,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
      hoverColor: drawerColor4.withOpacity(0.1),
      splashColor: drawerColor4.withOpacity(0.2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red, size: 24),
            const SizedBox(width: 8),
            const Text('Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: drawerDarkBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _logout(context); // Perform logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.login, color: drawerDarkBlue),
              const SizedBox(width: 8),
              const Text('Sign In Required'),
            ],
          ),
          content: const Text(
            'Please sign in to access this feature and save your progress across devices.',
            style: TextStyle(fontSize: 14),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: drawerDarkBlue)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: drawerDarkBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sign In'),
            ),
          ],
        );
      },
    );
  }
}

// Welcome Screen with proper color definitions
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [drawerColor1, drawerColor2], // Using global color constants
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sign_language,
                size: 80,
                color: drawerDarkBlue, // Using global color constant
              ),
              const SizedBox(height: 24),
              Text(
                'Signs Speak',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: drawerDarkBlue, // Using global color constant
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bridge the communication gap',
                style: TextStyle(
                  fontSize: 16, 
                  color: drawerDarkBlue, // Using global color constant
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: drawerDarkBlue, // Using global color constant
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show drawer with animation
void showCustomDrawer(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close drawer',
    barrierColor: Colors.black.withOpacity(0.3),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child:const DrawerPage(),
      );
    },
  );
}