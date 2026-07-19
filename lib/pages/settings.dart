import 'package:flutter/material.dart';
import 'termspolicyscreen.dart';

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
          backgroundColor: const Color.fromARGB(255, 220, 230, 236),
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
    },
  ];

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color color4 = Color(0xFF6CC2C0);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              // Custom AppBar - Simplified with just the arrow
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    // Simple back button - NO CONTAINER
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: marineBlue,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
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
              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Target Sign Language Section
                      _buildSectionHeader('Target Sign Language'),
                      const SizedBox(height: 8),
                      _buildLanguageCard(),
                      const SizedBox(height: 24),

                      // Audio Section
                      _buildSectionHeader('Audio'),
                      const SizedBox(height: 8),
                      _buildAudioCard(),
                      const SizedBox(height: 24),

                      // Information Section
                      _buildSectionHeader('Information'),
                      const SizedBox(height: 8),
                      _buildHelpItems(),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: marineBlue.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: marineBlue.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: signLanguages.asMap().entries.map((entry) {
          final index = entry.key;
          final language = entry.value;
          return _buildLanguageOption(
            language['name']!,
            language['value']!,
            isLast: index == signLanguages.length - 1,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLanguageOption(String name, String value, {bool isLast = false}) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
      borderRadius: BorderRadius.circular(16),
      splashColor: lightBlue.withOpacity(0.1),
      highlightColor: lightBlue.withOpacity(0.05),
      child: Container(
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: isLightMode
                        ? marineBlue.withOpacity(0.08)
                        : color1.withOpacity(0.08),
                  ),
                ),
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: marineBlue,
                  ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedLanguage == value
                        ? lightBlue
                        : isLightMode
                            ? marineBlue.withOpacity(0.3)
                            : color1.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: _selectedLanguage == value
                    ? Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightBlue,
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

  Widget _buildAudioCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: marineBlue.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Play Translated Text Aloud',
                style: TextStyle(
                  fontSize: 15,
                  color: marineBlue,
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
              activeColor: lightBlue,
              activeTrackColor: lightBlue.withOpacity(0.5),
              inactiveThumbColor: marineBlue,
              inactiveTrackColor: marineBlue.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItems() {
    return Column(
      children: helpItems.map((item) {
        return _buildHelpItem(
          context,
          item['title'] as String,
          item['icon'] as IconData,
        );
      }).toList(),
    );
  }

  Widget _buildHelpItem(
      BuildContext context, String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: marineBlue.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (title == 'Terms & Policies') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsPoliciesScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: lightBlue.withOpacity(0.1),
        highlightColor: lightBlue.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightBlue, color4],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: marineBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: marineBlue.withOpacity(0.5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}