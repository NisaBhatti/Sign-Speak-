import 'package:flutter/material.dart';

class AppIntroDocument extends StatelessWidget {
  const AppIntroDocument({super.key});

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue
  static const Color cream = Color(0xFFFBE4D8);    // Cream for contrast

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Introduction'),
        backgroundColor: marineBlue, // Dark blue
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2], // Light blue-green to light teal
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),
              const SizedBox(height: 30),

              // Section 1: The Power of Connection
              _buildSection(
                title: 'The Power of Connection',
                subtitle: 'Bridging Worlds, One Sign at a Time',
                content:
                    'Welcome to **Signs Speak**, your real-time bridge between sign language and spoken language. This app is built on a simple, powerful belief: **communication is a fundamental human right.**\n\nFor the 70+ million people worldwide who use sign language as their primary language, everyday interactions can be filled with barriers. Our mission is to use cutting-edge AI not to replace human connection, but to **enable it**—instantly, accurately, and respectfully.',
                icon: Icons.handshake,
                iconColor: marineBlue, // Dark blue
              ),
              const SizedBox(height: 30),

              // Image before Section 2: Understanding Sign Language
              _buildImageSection(
                'assets/images/image1.png',
                'Understanding Sign Language',
              ),
              const SizedBox(height: 20),

              // Section 2: Understanding Sign Language
              _buildSection(
                title:
                    'Understanding Sign Language & the Deaf and Hard of Hearing Community',
                subtitle: 'More Than Just "Hand Signs"',
                content:
                    '**Sign languages** (like ASL, BSL, LSF) are complete, natural languages with their own grammar, syntax, and culture. They are not visual versions of spoken languages. They are rich, expressive, and vital to the cultural identity of the **Deaf and Hard-of-Hearing (DHH) community**.\n\nThis community is diverse:\n\n• **Culturally Deaf** individuals who identify with Deaf culture and use sign language as their primary language.\n• **Hard-of-hearing** people who may use sign.\n• **Late-deafened** adults.\n• **Families and friends** of DHH individuals.\n\nFor many, sign language is not a choice—it\'s the most natural and effective way to communicate, express nuance, and build relationships.',
                icon: Icons.language,
                iconColor: lightBlue, // Light blue
              ),
              const SizedBox(height: 30),

              // Image before Section 3: Who This App Is For
              _buildImageSection(
                'assets/images/image2.png',
                'Who This App Is For',
              ),
              const SizedBox(height: 20),

              // Section 3: Who This App Is For
              _buildSection(
                title: 'Who This App Is For (The "Why")',
                subtitle: 'Who Is This For? Everyone.',
                content:
                    'This app is a tool for **inclusion**. It\'s useful for:\n\n**For Deaf & Hard-of-Hearing Users:**\n• Communicate spontaneously with anyone, anywhere—at a store, with a colleague, or at a government office.\n• Double-check understanding in critical situations (medical, legal).\n• Assist in teaching signs to friends and family.\n\n**For Hearing Friends, Family & Colleagues:**\n• Have meaningful conversations without prior fluency. Be more present.\n• Learn naturally by seeing real-time translation.\n• Include DHH peers fully in social and professional settings.\n\n**For Professionals & Public Servants:**\n• **Doctors, nurses, police, librarians:** Provide immediate, accessible service without waiting for a human interpreter.\n• **Teachers:** Make classrooms more inclusive.\n• **Customer service staff:** Assist all customers with dignity.\n\nIt\'s not about perfection; it\'s about **making the effort**, reducing isolation, and opening doors.',
                icon: Icons.group,
                iconColor: marineBlue, // Dark blue
                textColor: marineBlue,
              ),
              const SizedBox(height: 30),

              // Image before Section 4: How It Works
              _buildImageSection(
                'assets/images/image3.png',
                'How It Works',
              ),
              const SizedBox(height: 20),

              // Section 4: How It Works
              _buildSection(
                title: 'How It Works (Simply)',
                subtitle: 'How It Works: Simple & Powerful',
                content:
                    'Our technology is complex, but using it is simple.\n\n**1. POINT & SIGN**\nHold your device or point its camera at the person signing. Our AI watches for sign language grammar, handshapes, movement.\n\n**2. REAL-TIME TRANSLATION**\nInstantly, the signs are translated into clear text or synthetic speech.\n\n**3. CONNECT**\nHave a fluid, two-way conversation. The app acts as your communication partner, helping you both understand each other.\n\n**Our Promise:** We prioritize **privacy**. You can choose to process everything on your device, so your conversations stay yours.',
                icon: Icons.settings,
                iconColor: marineBlue, // Dark blue
              ),
              const SizedBox(height: 30),

              // Section 5: Our Commitment
              _buildSection(
                title: 'Our Commitment & Your First Step',
                subtitle: 'A Tool for Respectful Connection',
                content:
                    'We recognize that **no AI can replace the nuance of a human interpreter or the depth of learning a language.** This app is designed as an **aid for accessibility**, a **bridge in spontaneous situations**, and a **step towards greater understanding**.\n\nWe are committed to continuous improvement, community feedback, and ethical technology use.\n\n**Take your first step towards a more connected world.**',
                icon: Icons.verified,
                iconColor: lightBlue, // Light blue
              ),
              const SizedBox(height: 40),

              // Key Notes Section
              _buildKeyNotesSection(),
              const SizedBox(height: 40),

              // Footer with Terms
              _buildFooterSection(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            marineBlue, // Dark blue
            lightBlue, // Light blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: marineBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.handshake,
            size: 60,
            color: cream, // cream
          ),
          const SizedBox(height: 15),
          const Text(
            'Signs Speak',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Real-Time Sign Language Translation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String imagePath, String caption) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: marineBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback container if image fails to load
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: color1.withOpacity(0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 50,
                        color: marineBlue.withOpacity(0.5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        caption,
                        style: TextStyle(
                          color: marineBlue.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            style: TextStyle(
              fontSize: 14,
              color: marineBlue.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required String content,
    required IconData icon,
    required Color iconColor,
    Color textColor = const Color.fromARGB(255, 8, 4, 84),
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: marineBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [iconColor, iconColor == marineBlue ? lightBlue : marineBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Subtitle
          Container(
            padding: const EdgeInsets.only(left: 46), // Align with icon
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: iconColor,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Content
          Container(
            padding: const EdgeInsets.only(left: 46), // Align with icon
            child: _buildFormattedText(content, textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(String text, Color textColor) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().isEmpty) {
          return const SizedBox(height: 12);
        } else if (line.trim().startsWith('•')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('•', style: TextStyle(fontSize: 16, color: textColor)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _parseBoldText(
                    line.substring(1).trim(),
                    textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          );
        } else if (line.trim().startsWith(RegExp(r'\d+\.'))) {
          final number = line.split('.')[0];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [marineBlue, lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _parseBoldText(
                    line.substring(line.indexOf('.') + 1).trim(),
                    textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _parseBoldText(line, textColor.withOpacity(0.8)),
          );
        }
      }).toList(),
    );
  }

  Widget _parseBoldText(String text, Color color) {
    final parts = text.split('**');
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: color, height: 1.6),
        children: parts.asMap().entries.map((entry) {
          final index = entry.key;
          final part = entry.value;
          return TextSpan(
            text: part,
            style: TextStyle(
              fontWeight: index % 2 == 1 ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1.withOpacity(0.5), color2.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lightBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Tone & Messaging Notes:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: marineBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildNoteItem(
            'Empowerment Over Pity',
            'Focus on ability, not disability.',
          ),
          _buildNoteItem(
            'Respect for Culture',
            'Acknowledge sign language as a legitimate language and culture.',
          ),
          _buildNoteItem(
            'Clarity on Purpose',
            'It\'s a bridge and tool, not a replacement for human interpreters in formal settings.',
          ),
          _buildNoteItem(
            'Inclusive Language',
            '"Deaf and Hard-of-Hearing community," "sign language users," "communication partners."',
          ),
          _buildNoteItem(
            'Visual Harmony',
            'Use high-contrast, clear visuals with diverse representation of people.',
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightBlue, marineBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: marineBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: marineBlue.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Column(
      children: [
        Divider(color: lightBlue.withOpacity(0.3)),
        const SizedBox(height: 20),
        Text(
          'By using this app, you agree to our:',
          style: TextStyle(color: marineBlue, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Navigate to Terms of Service
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: lightBlue,
                    content: const Text('Terms of Service page'),
                  ),
                );
              },
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  color: lightBlue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                // Navigate to Privacy Policy
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: lightBlue,
                    content: const Text('Privacy Policy page'),
                  ),
                );
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: lightBlue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Version 1.0.0 • © 2025 Signs Speak',
          style: TextStyle(color: marineBlue, fontSize: 12),
        ),
      ],
    );
  }
}