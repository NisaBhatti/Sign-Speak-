import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

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
          iconTheme: IconThemeData(color: marineBlue),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: color1,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const ProfileSettingsPage(),
    );
  }
}

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String _fullName = "";
  String _email = "";
  bool _isLoading = true;
  String _selectedLanguage = "PSL";

  final List<Map<String, String>> languages = [
    {'value': 'ASL', 'label': 'ASL (American Sign Language)'},
    {'value': 'PSL', 'label': 'PSL (Pakistani Sign Language)'},
  ];

  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color color4 = Color(0xFF6CC2C0);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        _email = user.email ?? "No email";
        _fullName = user.displayName ?? "User";
        _isLoading = false;
      });

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && mounted) {
          setState(() {
            _fullName = doc.data()?['name'] ?? _fullName;
            _email = doc.data()?['email'] ?? _email;
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _performUpdateProfile(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateDisplayName(_fullName);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': _fullName,
          'email': _email,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: lightBlue,
              content: Text('Profile updated successfully!',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error updating profile: ${e.toString()}'),
            ),
          );
        }
      }
    }
  }

  void _showUpdateProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [lightBlue, color4]),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.update, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 16),
                Text('Update Profile',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: marineBlue)),
                const SizedBox(height: 8),
                Text('Are you sure you want to update your profile?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: marineBlue.withOpacity(0.7))),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: lightBlue, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Text('Cancel',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: marineBlue)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _performUpdateProfile(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Text('Update',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.red, lightBlue]),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.logout, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 16),
                Text('Logout',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: marineBlue)),
                const SizedBox(height: 8),
                Text('Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: marineBlue.withOpacity(0.7))),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: lightBlue, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Text('Cancel',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: marineBlue)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _performLogout(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Text('Logout',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  void _performLogout(BuildContext context) async {
    Navigator.of(context).pop();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1, color2]),
          ),
          child: Center(
            child: CircularProgressIndicator(color: marineBlue),
          ),
        ),
      );
    }

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
                  // Custom AppBar - Simplified with just the arrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: marineBlue,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Profile Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: marineBlue,
                              letterSpacing: -0.015,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 76,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildProfileAvatar(),
                            const SizedBox(height: 32),
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
        Container(
          width: 128, height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
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
                  'assets/images/logo.png',
                  width: 100, height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.translate, color: lightBlue, size: 60);
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Container(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: lightBlue.withOpacity(0.3)),
              ),
              child: Text(
                _fullName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold,
                  color: marineBlue, letterSpacing: -0.015,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _email,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightBlue),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFormField(
          label: 'Full Name',
          value: _fullName,
          icon: Icons.person,
          onChanged: (value) => setState(() => _fullName = value),
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: 'Email',
          value: _email,
          icon: Icons.mail,
          isEmail: true,
          onChanged: (value) => setState(() => _email = value),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text('Preferred Sign Language',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: marineBlue)),
            ),
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: lightBlue.withOpacity(0.5), width: 1),
                boxShadow: [
                  BoxShadow(color: marineBlue.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  if (newValue != null) setState(() => _selectedLanguage = newValue);
                },
                items: languages.map<DropdownMenuItem<String>>((language) {
                  return DropdownMenuItem<String>(
                    value: language['value'],
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(language['label']!,
                          overflow: TextOverflow.ellipsis, maxLines: 1,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: marineBlue)),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  suffixIcon: Icon(Icons.expand_more, color: lightBlue),
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: marineBlue),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                icon: const SizedBox.shrink(),
                isExpanded: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          children: [
            SizedBox(
              width: double.infinity, height: 56,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [marineBlue, lightBlue]),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(color: marineBlue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _showUpdateProfileDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  child: Text('Update Profile',
                      overflow: TextOverflow.ellipsis, maxLines: 1,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: marineBlue.withOpacity(0.3), width: 2),
              ),
              child: TextButton(
                onPressed: () => _showLogoutDialog(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: marineBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: marineBlue, size: 20),
                    const SizedBox(width: 8),
                    Text('Log Out',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: marineBlue)),
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

  // ✅ UPDATED: Properly centered text and icon with simplified back button
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
          child: Text(label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: marineBlue)),
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: lightBlue.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(color: marineBlue.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500, 
              color: marineBlue,
              height: 1.2,
            ),
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 24,
              ),
              isDense: true,
              suffixIcon: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [lightBlue, color4]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
            ),
          ),
        ),
      ],
    );
  }
}