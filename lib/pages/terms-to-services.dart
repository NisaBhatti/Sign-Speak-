import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Speak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PublicSans',
        scaffoldBackgroundColor: const Color(0xFFF8F6F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF4B2038),
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4B2038), // brand-purple
          secondary: Color(0xFFEC5B13), // primary orange
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const TermsOfServicePage(),
    );
  }
}

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF221610),
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Section
              _buildHeroImage(context),
              const SizedBox(height: 24),
              
              // Welcome text
              Text(
                'Welcome to ',
                style: _bodyTextStyle(),
              ) +
              TextSpan(
                text: 'Sign Speak',
                style: _bodyTextStyle().copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4B2038),
                ),
              ) +
              TextSpan(
                text: '. These Terms of Service ("Terms") govern your access to and use of our mobile application and related services. By using Sign Speak, you agree to be bound by these terms.',
                style: _bodyTextStyle(),
              ),
              
              const SizedBox(height: 32),
              
              // All Sections
              _buildSection(
                title: '1. Agreement to Terms',
                content: 'By downloading, installing, or using the Sign Speak application, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy. If you do not agree, please do not use the app.',
              ),
              
              _buildSection(
                title: '2. User Account',
                content: 'To access certain features of Sign Speak, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
              ),
              
              _buildSection(
                title: '3. Acceptable Use',
                content: 'You agree to use Sign Speak only for lawful purposes. Prohibited activities include but are not limited to:',
                bulletPoints: const [
                  'Reverse engineering or attempting to extract the source code of the Sign Speak engine.',
                  'Using the service to transmit any content that is infringing, libelous, or otherwise unlawful.',
                  'Attempting to interfere with the proper functioning of the Sign Speak application.',
                ],
              ),
              
              _buildSection(
                title: '4. Intellectual Property',
                content: 'The Sign Speak application, including its original content, features, and functionality, are and will remain the exclusive property of Sign Speak and its licensors. Our trademarks and trade dress may not be used in connection with any product or service without our prior written consent.',
              ),
              
              _buildSection(
                title: '5. Termination',
                content: 'We reserve the right to suspend or terminate your access to Sign Speak at any time, without prior notice, for conduct that we believe violates these Terms or is harmful to other users of the app, us, or third parties.',
              ),
              
              _buildSection(
                title: '6. Changes to Terms',
                content: 'We may revise these Terms from time to time. The most current version will always be posted on this page. By continuing to access or use Sign Speak after revisions become effective, you agree to be bound by the revised Terms.',
              ),
              
              const SizedBox(height: 32),
              
              // Footer Section
              _buildFooter(),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF221610), // brand-bg
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAg7FVzW6bK14PeNowXt7f-tgu-1VEbMlpOlU5Ph9KmPKbkpkI2rmYmXRm-I5roxljYibJ2kDOrBFZjNn6Ri15jLr2PkKiacDUqk4_idAkwaMwj-ZaCC-ZtKwUyPJJ2cvHBpBaOSHaq-TD1Kuw_NoScjXObM9plcZbynHKPFogHlt5MwWrNQdawruuXI5pIVpDNednEos73oHYjrBHahJsx3SkGZQqTDlIGbPEDkTVupT-XjtVGj8W_zZMOyZIU3pW0djw5N7UTViA',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Legal Agreement',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: May 2026',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<String> bulletPoints = const [],
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFEC5B13), // primary
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B2038), // brand-purple
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: _bodyTextStyle(),
          ),
          if (bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...bulletPoints.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: Color(0xFFEC5B13),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: _bodyTextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Divider(
          color: Colors.grey.shade200,
          thickness: 1,
        ),
        const SizedBox(height: 24),
        Text(
          'SIGN SPEAK V2.4.0',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4B2038)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Decline',
                  style: TextStyle(
                    color: Color(0xFF4B2038),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B2038),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Accept Terms',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextStyle _bodyTextStyle({double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      height: 1.5,
      color: const Color(0xFF4B5563), // gray-600 equivalent
    );
  }
}