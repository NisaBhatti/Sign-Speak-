import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumina Sign Translator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: lightBlue,
          secondary: marineBlue,
          tertiary: marineBlue,
          surface: color1,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: marineBlue,
        ),
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
          backgroundColor: color1,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
            color: lightBlue,
          ),
          iconTheme: IconThemeData(
            color: marineBlue,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: color1,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: marineBlue,
          secondary: lightBlue,
          tertiary: marineBlue,
          surface: const Color(0xFF1A2F3A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: color1,
        ),
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A2F3A),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
            color: color1,
          ),
          iconTheme: IconThemeData(
            color: color1,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2A4045),
          surfaceTintColor: const Color(0xFF2A4045),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const ProfileSettingsPage(),
    );
  }
}

// Assuming you have a SignUpPage - if not, here's a basic one
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: MyApp.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Sign Up Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String _fullName = "Alex Morgan";
  String _email = "alex.morgan@example.com";
  String _selectedLanguage = "PSL"; // Changed default to PSL

  final List<Map<String, String>> languages = [
    {'value': 'ASL', 'label': 'ASL (American Sign Language)'},
    {'value': 'PSL', 'label': 'PSL (Pakistani Sign Language)'},
  ];

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color color4 = Color(0xFF6CC2C0);   // Teal
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue

  // Function to show update profile confirmation dialog
  void _showUpdateProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, color1.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [lightBlue, color4],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.update,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'Update Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: marineBlue,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Message
                Text(
                  'Are you sure you want to update your profile?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: marineBlue.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Buttons Row
                Row(
                  children: [
                    // Cancel Button - Outlined Style
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: lightBlue, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: marineBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Update Button - Blue Solid Style
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                            _performUpdateProfile(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Update',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to perform update profile and navigate to Sign Up page
  void _performUpdateProfile(BuildContext context) {
    // Show a success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: lightBlue,
        content: Text(
          'Profile updated successfully!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Navigate to Sign Up page after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to SignUpPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    });
  }

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, color1.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: marineBlue,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Message
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: marineBlue.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Buttons Row
                Row(
                  children: [
                    // Cancel Button - Outlined Style
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: lightBlue, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: marineBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Logout Button - Red Solid Style
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                            _performLogout(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Logout',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to perform logout
  void _performLogout(BuildContext context) {
    // Show a snackbar or perform actual logout logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: marineBlue,
        content: Text(
          'Logging out...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: Column(
                children: [
                  // Header - FIXED: No overflow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [lightBlue, color4],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: marineBlue.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        // Flexible title to prevent overflow
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Profile Settings',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: marineBlue,
                                letterSpacing: -0.015,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 44,
                          child: Container(), // Placeholder for balance
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 76, // Account for header height
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Profile Avatar Section - White circle with app logo
                            _buildProfileAvatar(),
                            const SizedBox(height: 32),

                            // Form Section
                            _buildFormSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Column(
      children: [
        // White circle with app logo - No network image, no camera overlay
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // White background
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: marineBlue.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png', // Your app logo image
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback icon if image is not found
                    return Icon(
                      Icons.translate,
                      color: lightBlue,
                      size: 60,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // MERGED CONTAINER - Name and Email in one box
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: lightBlue.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: marineBlue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 20,
                      color: lightBlue,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _fullName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: marineBlue,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Divider line
              Container(
                height: 1,
                color: lightBlue.withOpacity(0.2),
              ),
              
              // Email section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: lightBlue,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _email,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Full Name Field
        _buildFormField(
          label: 'Full Name',
          value: _fullName,
          icon: Icons.person,
          onChanged: (value) {
            setState(() {
              _fullName = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Email Field
        _buildFormField(
          label: 'Email',
          value: _email,
          icon: Icons.mail,
          isEmail: true,
          onChanged: (value) {
            setState(() {
              _email = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // Preferred Language Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                'Preferred Sign Language',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: marineBlue,
                ),
              ),
            ),
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: lightBlue.withOpacity(0.5), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: marineBlue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedLanguage,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  }
                },
                items: languages.map<DropdownMenuItem<String>>((language) {
                  return DropdownMenuItem<String>(
                    value: language['value'],
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        language['label']!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: marineBlue,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  suffixIcon: Icon(Icons.expand_more, color: lightBlue),
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: marineBlue,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                icon: const SizedBox.shrink(),
                isExpanded: true,
              ),
            ),
          ],
        ),

        // Actions
        const SizedBox(height: 40),
        Column(
          children: [
            // Update Profile Button - Now shows confirmation dialog
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [marineBlue, lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: marineBlue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _showUpdateProfileDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'Update Profile',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Logout Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: marineBlue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: TextButton(
                onPressed: () => _showLogoutDialog(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: marineBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: marineBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: marineBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String value,
    required IconData icon,
    bool isEmail = false,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: marineBlue,
            ),
          ),
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: lightBlue.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: marineBlue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: marineBlue,
            ),
            maxLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              suffixIcon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightBlue, color4],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}