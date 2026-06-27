// lib/pages/privacy_policy.dart
import 'package:flutter/material.dart';

const Color color1 = Color(0xFFCFE8EA);
const Color color2 = Color(0xFFACD9D9);
const Color darkBlue = Color.fromARGB(255, 8, 4, 84);
const Color lightBlue = Color.fromARGB(255, 0, 109, 176);
const Color surface = Color(0xFFFFFFFF);
const Color onSurface = Color(0xFF4B5563);
const Color outlineVariant = Color(0xFFE5E7EB);
const Color darkBlueShadow = Color.fromARGB(77, 8, 4, 84);
const Color darkBlueOverlay = Color.fromARGB(102, 8, 4, 84);
const Color blackShadow = Color.fromARGB(13, 0, 0, 0);
const Color lightBlueBorder = Color.fromARGB(77, 0, 109, 176);
const Color onSurface70 = Color.fromARGB(179, 75, 85, 99);

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _buildTopAppBar(context),
      ),
      body: const _MainContent(),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: darkBlue,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            const Text(
              'Sign Speak',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: darkBlue,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color1, color2],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          children: [
            // Hero Illustration / Header
            _buildHeroHeader(),
            
            const SizedBox(height: 24),
            
            // Privacy Content Sections
            Column(
              children: [
                // 1. Introduction
                _buildPolicyCard(
                  title: '1. Introduction',
                  content: 'Welcome to Sign Speak\'s Privacy Policy. We are committed to protecting your personal information and your right to privacy. This document outlines how we handle your data when you use our real-time translation services.',
                ),
                
                const SizedBox(height: 16),
                
                // 2. Data Collection & Camera Access (Bento Style)
                Row(
                  children: [
                    Expanded(
                      child: _buildDataCollectionCard(
                        icon: Icons.camera_enhance,
                        title: '2. Data Collection',
                        content: 'We process real-time camera data for sign language translation. All video processing occurs locally on your device. We do not transmit or store your raw video feed on our servers without your explicit, separate consent.',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDataCollectionCard(
                        icon: Icons.vpn_key,
                        title: '3. Camera Access',
                        content: 'Camera permissions are strictly required for the app to function. This feed is used solely to identify hand gestures and facial expressions for high-fidelity translation into text and audio.',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Image Break with Styled Prompt
                _buildHeroImage(),
                
                const SizedBox(height: 16),
                
                // 4. User Rights & Security
                _buildRightsAndSecurityCard(),
                
                const SizedBox(height: 16),
                
                // 6. Third-Party & Contact
                _buildThirdPartyCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [darkBlue, lightBlue],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: darkBlue.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.security,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: darkBlue,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Last Updated: October 2023',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: onSurface70,
            letterSpacing: 0.14,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCollectionCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Icon(
                icon,
                color: lightBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Stack(
      children: [
        Container(
          height: 192,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: darkBlue.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD-bERHpCA4ydLYdgrtVUVeM5zyfO2W0be27eUytl3HKRgleXqytCA1RMckzp0088VSzIBqyhF9KU5DyBhAQbOoJ5OnVLWKQuBgGqY34t0CaB0y1LjOSsksz_okEgjX5niXhUWMvfvq6Vf9e2EpmW2q1T7c8hDMt0pCUuZeqmWrxenwhqlvGLcavZsAc06Nuw73ICfMKW-XSVRhSSSBoekeajEPnBm-h_AA4HP73ePOJaY-NEZ4UwR-NsF2k6K4sKf5FBz2iPEWh88'
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 192,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                darkBlueOverlay,
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [darkBlue, lightBlue],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Secured On-Device',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightsAndSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              const Text(
                '4. Your Rights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'You have the right to access, update, or delete any personal information associated with your profile. Since we minimize server-side storage, most of your "data" is ephemeral and exists only during your active session.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: onSurface,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: outlineVariant),
          const SizedBox(height: 20),
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
              const Text(
                '5. Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'We implement industry-standard encryption protocols for any data in transit (such as profile settings or analytics). Our architecture is designed to prioritize "Privacy by Design," ensuring your communication remains private.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPartyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              const Text(
                '6. Third-Party Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'We may use anonymized analytics and specific translation engines to improve accuracy. These partners are strictly vetted and are contractually prohibited from retaining user-identifiable data.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: onSurface,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: lightBlueBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alternate_email,
                      color: darkBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'For any privacy-related inquiries, please reach out to our dedicated support team at:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: onSurface,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    // Launch email
                    // You can use url_launcher package here
                  },
                  child: const Text(
                    'privacy@signspeak.app',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Decline Button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: lightBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close,
                      color: lightBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Decline',
                      style: TextStyle(
                        color: lightBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Accept Button
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Accept',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}