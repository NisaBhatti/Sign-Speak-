import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

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
      title: 'SignTranslate',
      debugShowCheckedModeBanner: false,
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
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color color4 = Color(0xFF6CC2C0);   // Teal
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color1, // #CFE8EA - lightest at top
              color2, // #ACD9D9
              color4.withOpacity(0.5), // #6CC2C0 with opacity
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 120,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Section - PERFECT CIRCLE with blue gradient
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                marineBlue, // Dark blue
                                lightBlue, // Light blue
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: marineBlue.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              semanticLabel: 'SignTranslate logo',
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading logo asset: $error');
                                return Container(
                                  width: 120,
                                  height: 120,
                                  color: lightBlue.withOpacity(0.2),
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: marineBlue, // Marine blue icon
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // App Name - MARINE BLUE
                        Text(
                          'SignTranslate',
                          style: TextStyle(
                            color: marineBlue, // Marine blue text
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Main Heading
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Unlock\n', // LIGHT BLUE
                                  style: TextStyle(
                                    color: lightBlue, // Light blue text
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                    height: 1.1,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Communication.\n', // MARINE BLUE
                                  style: TextStyle(
                                    color: marineBlue, // Marine blue text
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Instantly.', // LIGHT BLUE
                                  style: TextStyle(
                                    color: lightBlue, // Light blue text
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Create Account Button - MARINE BLUE with WHITE TEXT
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [marineBlue, lightBlue],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: marineBlue.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white, // White text
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login Link - MARINE BLUE BORDER with MARINE BLUE TEXT
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: marineBlue.withOpacity(0.5), // Marine blue border
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: marineBlue.withOpacity(0.8), // Marine blue text
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Log In', // MARINE BLUE
                                    style: TextStyle(
                                      color: marineBlue, // Marine blue text
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Continue as Guest - MARINE BLUE
                  Container(
                    padding: const EdgeInsets.only(bottom: 32.0, top: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 1,
                          color: marineBlue.withOpacity(0.3), // Marine blue line
                          margin: const EdgeInsets.only(bottom: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Continue as Guest');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: marineBlue.withOpacity(0.3), // Marine blue border
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Continue as Guest', // MARINE BLUE
                              style: TextStyle(
                                color: marineBlue, // Marine blue text
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}