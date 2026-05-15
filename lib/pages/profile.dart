import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  String _fullName = "Alex Morgan";
  String _email = "alex.morgan@example.com";
  String _selectedLanguage = "PSL";

  final List<Map<String, String>> languages = [
    {'value': 'ASL', 'label': 'ASL (American Sign Language)'},
    {'value': 'PSL', 'label': 'PSL (Pakistani Sign Language)'},
  ];

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color color4 = Color(0xFF6CC2C0);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

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
                Text(
                  'Update Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: marineBlue,
                  ),
                ),
                const SizedBox(height: 8),
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
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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

  void _performUpdateProfile(BuildContext context) {
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
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      }
    });
  }

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
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: marineBlue,
                  ),
                ),
                const SizedBox(height: 8),
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
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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

  // FIXED: Proper logout function with immediate navigation
  void _performLogout(BuildContext context) {
    // Show snackbar
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
        duration: const Duration(seconds: 1),
      ),
    );
    
    // Navigate immediately without delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Clear all routes and go to SignUpPage
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignUpPage()),
          (route) => false,
        );
      }
    });
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
                          child: Container(),
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
          width: 128,
          height: 128,
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
                child: Icon(
                  Icons.person,
                  color: lightBlue,
                  size: 60,
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
                border: Border.all(
                  color: lightBlue.withOpacity(0.3),
                ),
              ),
              child: Text(
                _fullName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: marineBlue,
                  letterSpacing: -0.015,
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: lightBlue,
                ),
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
          onChanged: (value) {
            setState(() {
              _fullName = value;
            });
          },
        ),
        const SizedBox(height: 16),
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
                value: _selectedLanguage,
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
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  suffixIcon: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [lightBlue, color4],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: marineBlue,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                isExpanded: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          children: [
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
            keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: marineBlue,
            ),
            maxLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              suffixIcon: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 8),
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
              suffixIconConstraints: const BoxConstraints(
                minWidth: 44,
                minHeight: 44,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromARGB(255, 0, 109, 176),
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