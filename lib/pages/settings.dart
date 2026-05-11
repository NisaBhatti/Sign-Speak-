import 'package:flutter/material.dart';
import 'termspolicyscreen.dart'; // This is now used correctly

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
      title: 'Sign Language Translator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: lightBlue, // Light blue as primary
          secondary: marineBlue, // Teal as secondary
          tertiary: marineBlue, // Dark blue as tertiary
          surface: color1, // Light blue-green for surfaces
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: marineBlue, // Dark blue for text
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
          primary: marineBlue, // Teal for primary
          secondary: lightBlue, // Light blue for secondary
          tertiary: marineBlue, // Dark blue for tertiary
<<<<<<< HEAD
          surface: const Color.fromARGB(255, 230, 240, 245), // Dark blue-green background
=======
          surface: const Color(0xFF1A2F3A), // Dark blue-green background
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: color1, // Light blue-green for text
        ),
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
<<<<<<< HEAD
          backgroundColor: const Color.fromARGB(255, 220, 230, 236), // Dark blue-green background
=======
          backgroundColor: const Color(0xFF1A2F3A), // Dark blue-green background
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
            color: color1, // Light blue-green
          ),
          iconTheme: IconThemeData(
            color: color1, // Light blue-green
          ),
        ),
        cardTheme: CardThemeData(
<<<<<<< HEAD
          color: const Color.fromARGB(255, 230, 240, 245), // Darker blue-green
          surfaceTintColor: const Color.fromARGB(255, 220, 230, 236), // Dark blue-green background
=======
          color: const Color(0xFF2A4045), // Darker blue-green
          surfaceTintColor: const Color(0xFF2A4045),
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'ASL';
  bool _playAudio = true;

  final List<Map<String, String>> signLanguages = [
    {'name': 'American Sign Language (ASL)', 'value': 'ASL'},
    {'name': 'Pakistani Sign Language (PSL)', 'value': 'PSL'},
  ];

  final List<Map<String, dynamic>> helpItems = [
    {
      'title': 'Terms & Policies',
      'icon': Icons.description_outlined,
      'color': lightBlue, // Changed to lightBlue
    },
  ];

  // Color scheme matching your app's palette
<<<<<<< HEAD
  static const Color color1 = Color.fromARGB(255, 207, 232, 234);   // Light blue-green
  static const Color color2 = Color.fromARGB(255, 172, 217, 217);   // Light teal
=======
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color color4 = Color(0xFF6CC2C0);   // Teal
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: color1, // Changed to color1
      appBar: AppBar(
        backgroundColor: color1, // Changed to color1
        title: Text(
          'Settings',
          style: TextStyle(
            color: lightBlue, // Changed to lightBlue
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isLightMode
                ? marineBlue.withOpacity(0.2) // Changed to marineBlue
                : color1.withOpacity(0.2), // Changed to color1
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2], // Added gradient background
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Target Sign Language Section
                _buildSectionHeader('Target Sign Language'),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
<<<<<<< HEAD
                        colors: [Colors.white, color1],
=======
                        colors: [Colors.white, color1.withOpacity(0.3)],
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: signLanguages.map((language) {
                        return _buildLanguageOption(
                          language['name']!,
                          language['value']!,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Audio Section
                _buildSectionHeader('Audio'),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
<<<<<<< HEAD
                        colors: [Colors.white, color1],
=======
                        colors: [Colors.white, color1.withOpacity(0.3)],
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Play Translated Text Aloud',
                              style: TextStyle(
                                fontSize: 16,
                                color: marineBlue, // Changed to marineBlue
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: _playAudio,
                            onChanged: (value) {
                              setState(() {
                                _playAudio = value;
                              });
                            },
                            activeColor: lightBlue, // Changed to lightBlue
                            activeTrackColor: lightBlue.withOpacity(0.5),
                            inactiveThumbColor: marineBlue, // Changed to marineBlue
                            inactiveTrackColor: marineBlue.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Information Section
                _buildSectionHeader('Information'),
                const SizedBox(height: 8),
                Column(
                  children: helpItems.map((item) {
                    return _buildHelpItem(
                      context,
                      item['title'] as String,
                      item['icon'] as IconData,
                      item['color'] as Color,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.015,
          color: marineBlue, // Changed to marineBlue
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String name, String value) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      splashColor: lightBlue.withOpacity(0.1), // Changed to lightBlue
      highlightColor: lightBlue.withOpacity(0.05), // Changed to lightBlue
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLightMode
                  ? marineBlue.withOpacity(0.1) // Changed to marineBlue
                  : color1.withOpacity(0.1), // Changed to color1
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: marineBlue, // Changed to marineBlue
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedLanguage == value
                        ? lightBlue // Changed to lightBlue
                        : isLightMode
                            ? marineBlue.withOpacity(0.3) // Changed to marineBlue
<<<<<<< HEAD
                            : color1, // Changed to color1
=======
                            : color1.withOpacity(0.3), // Changed to color1
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
                    width: 2,
                  ),
                ),
                child: _selectedLanguage == value
                    ? Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightBlue, // Changed to lightBlue
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(
      BuildContext context, String title, IconData icon, Color color) {

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
<<<<<<< HEAD
            colors: [Colors.white, color1],
=======
            colors: [Colors.white, color1.withOpacity(0.3)],
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            // Handle item tap based on title
            if (title == 'Terms & Policies') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsPoliciesScreen(),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: lightBlue.withOpacity(0.1), // Changed to lightBlue
          highlightColor: lightBlue.withOpacity(0.05), // Changed to lightBlue
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
<<<<<<< HEAD
                      colors: [lightBlue, color2], // Added gradient
=======
                      colors: [lightBlue, color4], // Added gradient
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
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
                  child: Icon(
                    icon,
                    color: Colors.white, // Changed to white
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: marineBlue, // Changed to marineBlue
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: lightBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: marineBlue, // Changed to marineBlue
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}