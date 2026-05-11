import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Color palette
  static const Color color1 = Color(0xFFCFE8EA);   // #cfe8ea - Lightest blue-green
  static const Color color2 = Color(0xFFACD9D9);   // #acd9d9 - Light blue-green
  static const Color color4 = Color(0xFF6CC2C0);   // #6cc2c0 - Teal
  static const Color darkBlue = Color.fromARGB(255, 8, 4, 84); // Dark Blue

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signs Speak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.light(
          primary: color4,
          secondary: color2,
          tertiary: color2,
          surface: color1,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: color1,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: color4,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.dark(
          primary: color4,
          secondary: color2,
          surface: const Color(0xFF1E1E1E),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white70,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: color4,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: color4,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
<<<<<<< HEAD
      home: const SplashScreen(), // Start with SplashScreen directly
      routes: {
=======
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
        '/onboarding': (context) => const OnboardingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

<<<<<<< HEAD
// ====================== SPLASH SCREEN (Fixed) ======================
=======
// ====================== AUTH WRAPPER ======================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        
        return FutureBuilder<bool>(
          future: _checkFirstLaunch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.data == true) {
              return const OnboardingScreen();
            }
            return const WelcomeScreen();
          },
        );
      },
    );
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      return true;
    }
    return false;
  }
}

// ====================== SPLASH SCREEN ======================
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Check if it's first launch
      final prefs = await SharedPreferences.getInstance();
      final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      
      // Wait for 2 seconds to show splash screen
      await Future.delayed(const Duration(seconds: 2));
      
      // Mark as not first launch if it was first launch
      if (isFirstLaunch) {
        await prefs.setBool('isFirstLaunch', false);
        
        if (mounted) {
          // Navigate to onboarding for first time users
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      } else {
        // Check authentication status after showing splash
        final user = FirebaseAuth.instance.currentUser;
        
        if (mounted) {
          if (user != null) {
            // User is logged in
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // User is not logged in
            Navigator.pushReplacementNamed(context, '/welcome');
          }
        }
      }
    } catch (e) {
      // Error handling - default to welcome screen
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
=======
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Navigation will be handled by AuthWrapper
>>>>>>> a13f109c93f777c070ae61bb24f2a538d4edf90d
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyApp.color1,
              MyApp.color2,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyApp.color2.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: MyApp.color2.withOpacity(0.3),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 660,
                    height: 460,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.front_hand,
                        size: 650,
                        color: MyApp.darkBlue,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Signs Speak',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                      color: MyApp.darkBlue,
                      fontFamily: 'Inter',
                      shadows: [
                        Shadow(
                          color: MyApp.color2.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MyApp.color4.withOpacity(0.8),
                          MyApp.color2.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================== ONBOARDING SCREEN ======================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Signs Speak',
      description: 'Bridge the communication gap between sign language and spoken language effortlessly.',
      imagePath: 'assets/images/wel.png',
      color: MyApp.color4,
    ),
    OnboardingPage(
      title: 'Real-time Translation',
      description: 'Instantly translate sign language gestures to text and speech with our advanced AI technology.',
      imagePath: 'assets/images/real.png',
      color: MyApp.color2,
    ),
    OnboardingPage(
      title: 'Break Language Barriers',
      description: 'Communicate effectively with the deaf and hard-of-hearing community.',
      imagePath: 'assets/images/communi.png',
      color: MyApp.color2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyApp.color1,
              MyApp.color2,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/welcome');
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: MyApp.darkBlue.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(page: _pages[index]);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 40.0,
                  left: 24.0,
                  right: 24.0,
                  top: 16.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          } else {
                            Navigator.pushReplacementNamed(context, '/welcome');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyApp.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenHeight < 700 ? 200.0 : 240.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            page.imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Image Not Found',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              color: MyApp.darkBlue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              page.description,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 109, 176).withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== WELCOME SCREEN ======================
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
            colors: [
              MyApp.color1,
              MyApp.color2,
            ],
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
                        Image.asset(
                          'assets/images/logo.png',
                          width: 420,
                          height: 220,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.sign_language,
                              size: 58,
                              color: MyApp.darkBlue,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Signs Speak',
                          style: TextStyle(
                            color: MyApp.darkBlue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Unlock\n',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 109, 176),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                    height: 1.1,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Communication.\n',
                                  style: const TextStyle(
                                    color: MyApp.darkBlue,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Instantly.',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 109, 176),
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
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyApp.darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                color: const Color.fromARGB(255, 0, 109, 176).withOpacity(0.5),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 109, 176).withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'Log In',
                                    style: TextStyle(
                                      color: MyApp.darkBlue,
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
                  Container(
                    padding: const EdgeInsets.only(bottom: 32.0, top: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 1,
                          color: const Color.fromARGB(255, 0, 109, 176).withOpacity(0.5),
                          margin: const EdgeInsets.only(bottom: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Continue as Guest
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 109, 176).withOpacity(0.5),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Continue as Guest',
                              style: TextStyle(
                                color: MyApp.darkBlue,
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