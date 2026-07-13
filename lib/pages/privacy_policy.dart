// lib/pages/privacy_policy.dart
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  // Match the color scheme from terms_of_service.dart
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color darkBlue = Color.fromARGB(255, 8, 4, 84);
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: darkBlue,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section with image
                      _buildHeroSection(),
                      const SizedBox(height: 20),
                      
                      // Welcome text
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Welcome to ',
                                style: _bodyTextStyle(),
                              ),
                              TextSpan(
                                text: 'Signs Speak',
                                style: _bodyTextStyle().copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: lightBlue,
                                ),
                              ),
                              TextSpan(
                                text: '. This Privacy Policy explains how we collect, use, and protect your personal information when you use our mobile application and related services. By using Signs Speak, you agree to the collection and use of information in accordance with this policy.',
                                style: _bodyTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // All Sections
                      _buildSection(
                        title: '1. Information We Collect',
                        content: 'We collect information to provide and improve our services. The types of information we collect include:',
                        bulletPoints: const [
                          'Camera data: Real-time video processing for sign language translation (processed locally on your device)',
                          'Account information: Name, email address, and profile preferences when you create an account',
                          'Usage data: Anonymous analytics to improve app performance and user experience',
                          'Device information: Device model, operating system version, and app version for compatibility',
                        ],
                      ),
                      
                      _buildSection(
                        title: '2. How We Use Your Information',
                        content: 'We use the collected information for various purposes to provide and improve our services:',
                        bulletPoints: const [
                          'To provide real-time sign language translation services',
                          'To personalize your experience and improve translation accuracy',
                          'To maintain and enhance app performance and security',
                          'To send important notifications about app updates or policy changes',
                          'To analyze usage patterns and improve our features',
                        ],
                      ),
                      
                      _buildSection(
                        title: '3. Data Storage and Security',
                        content: 'We take data security seriously and implement appropriate measures to protect your information:',
                        bulletPoints: const [
                          'Camera data is processed locally on your device and never transmitted to our servers',
                          'Account information is encrypted and stored securely in the cloud',
                          'We use industry-standard encryption protocols for data in transit',
                          'Regular security audits are conducted to identify and address vulnerabilities',
                          'We follow "Privacy by Design" principles to minimize data collection and storage',
                        ],
                      ),
                      
                      _buildSection(
                        title: '4. Your Rights and Choices',
                        content: 'You have the following rights regarding your personal information:',
                        bulletPoints: const [
                          'Access: You can request a copy of your personal data we hold',
                          'Update: You can update or correct your profile information at any time',
                          'Delete: You can request deletion of your account and associated data',
                          'Opt-out: You can choose not to provide certain information, though this may limit some features',
                          'Data portability: You can request your data in a structured, machine-readable format',
                        ],
                      ),
                      
                      _buildSection(
                        title: '5. Third-Party Services',
                        content: 'We may use third-party services to enhance our app functionality. These services have their own privacy policies:',
                        bulletPoints: const [
                          'Analytics providers (anonymous usage data only)',
                          'Translation engines for improved accuracy',
                          'Cloud storage providers for account data',
                          'All third-party partners are contractually obligated to protect your data',
                          'We do not share personally identifiable information with third parties without your consent',
                        ],
                      ),
                      
                      _buildSection(
                        title: '6. Children\'s Privacy',
                        content: 'Our services are not directed to children under the age of 13. We do not knowingly collect personal information from children. If you are a parent or guardian and believe your child has provided us with personal information, please contact us immediately.',
                      ),
                      
                      _buildSection(
                        title: '7. Changes to This Policy',
                        content: 'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. We encourage you to review this policy periodically for any changes.',
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Footer Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [darkBlue, lightBlue],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'SIGNS SPEAK V1.0.0',
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: lightBlue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: Text(
                                      'Decline',
                                      style: TextStyle(
                                        color: lightBlue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: darkBlue,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: const Text(
                                      'Accept',
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
                        ),
                      ),
                      
                      const SizedBox(height: 32),
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

  // Hero section with image (NO circle icon)
  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'assets/images/privacy.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [darkBlue.withOpacity(0.8), lightBlue.withOpacity(0.8)],
                    ),
                  ),
                );
              },
            ),
            // Dark overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            // Text content (NO ICON)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Last Updated: June 2026',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildSection({
    required String title,
    required String content,
    List<String> bulletPoints = const [],
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: lightBlue,
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
                    color: darkBlue,
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
            const SizedBox(height: 16),
            ...bulletPoints.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: lightBlue,
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

  TextStyle _bodyTextStyle({double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      height: 1.6,
      color: const Color(0xFF4B5563),
    );
  }
}