import 'package:flutter/material.dart';

class TermsPoliciesScreen extends StatelessWidget {
  const TermsPoliciesScreen({super.key});

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text('Terms & Policies'),
        backgroundColor: color1,
        foregroundColor: marineBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _buildSectionHeader('Legal Documents'),
            
            _buildPolicyItem(
              context,
              icon: Icons.description,
              title: 'Terms of Service',
              subtitle: 'User agreement and conditions',
              lastUpdated: 'Dec 12, 2025',
              content: '''
# Terms of Service

## 1. Agreement to Terms
By accessing or using this application, you agree to be bound by these Terms of Service.

## 2. User Accounts
You are responsible for maintaining the confidentiality of your account.

## 3. Acceptable Use
You agree not to use the service for any unlawful purpose.

## 4. Intellectual Property
All content is protected by copyright and other intellectual property laws.

## 5. Termination
We may terminate your access for violations of these terms.

## 6. Limitation of Liability
We are not liable for any indirect damages arising from your use.

## 7. Changes to Terms
We may update these terms at any time. Continued use constitutes acceptance.
''',
            ),
            
            _buildPolicyItem(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              lastUpdated: 'Dec 12, 2025',
              content: '''
# Privacy Policy

## 1. Information We Collect
We collect information you provide directly to us, such as when you create an account.

## 2. How We Use Information
We use the information to provide, maintain, and improve our services.

## 3. Information Sharing
We do not sell your personal information to third parties.

## 4. Data Security
We implement reasonable security measures to protect your information.

## 5. Your Rights
You have the right to access, correct, or delete your personal information.

## 6. Changes to This Policy
We may update this privacy policy from time to time.
''',
            ),
            
            _buildPolicyItem(
              context,
              icon: Icons.cookie,
              title: 'Cookie Policy',
              subtitle: 'Information about cookies',
              lastUpdated: 'Dec 12, 2025',
              content: '''
# Cookie Policy

## What Are Cookies
Cookies are small text files stored on your device.

## How We Use Cookies
We use cookies to:
- Remember your preferences
- Analyze site traffic
- Improve user experience

## Types of Cookies
- Essential cookies (required for functionality)
- Performance cookies (for analytics)
- Functionality cookies (for personalized features)

## Managing Cookies
You can control cookies through your browser settings.
''',
            ),
            
            _buildPolicyItem(
              context,
              icon: Icons.gavel,
              title: 'Acceptable Use Policy',
              subtitle: 'Rules for using our service',
              lastUpdated: 'Dec 12, 2025',
              content: '''
# Acceptable Use Policy

## Prohibited Activities
You may not:
- Violate any applicable laws
- Infringe intellectual property rights
- Transmit viruses or malicious code
- Harass or threaten other users
- Attempt to gain unauthorized access

## Content Restrictions
You may not post content that:
- Is illegal or promotes illegal activities
- Is defamatory, abusive, or harassing
- Infringes on others' rights
- Contains malware or viruses

## Enforcement
Violations may result in:
- Content removal
- Account suspension
- Permanent ban
''',
            ),
            
            _buildSectionHeader('Consent Management'),
            
            _buildConsentItem(
              context,
              icon: Icons.settings,
              title: 'Consent Preferences',
              subtitle: 'Manage your privacy choices',
              onTap: () => _showConsentPreferences(context),
            ),
            
            _buildConsentItem(
              context,
              icon: Icons.history,
              title: 'Consent History',
              subtitle: 'View your acceptance records',
              onTap: () => _showConsentHistory(context),
            ),
            
            _buildSectionHeader('Contact'),
            
            _buildConsentItem(
              context,
              icon: Icons.help,
              title: 'Legal Questions',
              subtitle: 'Contact our legal team',
              onTap: () => _contactLegalTeam(context),
            ),
            
            // Version information
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'All documents are version controlled',
                    style: TextStyle(
                      color: marineBlue.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current version: 1.0',
                    style: TextStyle(
                      color: marineBlue.withOpacity(0.4),
                      fontSize: 12,
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
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: marineBlue.withOpacity(0.7),
          letterSpacing: 1.0,
        ),
      ),
    );
  }
  
  Widget _buildPolicyItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String lastUpdated,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, color1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightBlue, marineBlue],
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
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: marineBlue,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                subtitle, 
                style: TextStyle(
                  color: lightBlue.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Updated: $lastUpdated',
                style: TextStyle(
                  fontSize: 11,
                  color: marineBlue.withOpacity(0.5),
                ),
              ),
            ],
          ),
          trailing: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: lightBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right,
              color: marineBlue,
              size: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PolicyDocumentViewer(
                  title: title,
                  content: content,
                  lastUpdated: lastUpdated,
                ),
              ),
            );
          },
          onLongPress: () => _showDocumentOptions(context, title),
        ),
      ),
    );
  }

  Widget _buildConsentItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white,color1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [marineBlue, lightBlue],
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
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: marineBlue,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: lightBlue.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          trailing: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: lightBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right,
              color: marineBlue,
              size: 18,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
  
  void _showConsentPreferences(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, color1],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: _buildConsentPreferencesSheet(context),
      ),
    );
  }
  
  void _showConsentHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _buildConsentHistoryScreen(),
      ),
    );
  }
  
  void _contactLegalTeam(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Contact Legal Team',
          style: TextStyle(color: marineBlue, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.email, color: lightBlue, size: 20),
                const SizedBox(width: 12),
                Text(
                  'signsspeak@app.com',
                  style: TextStyle(color: marineBlue.withOpacity(0.8)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone, color: lightBlue, size: 20),
                const SizedBox(width: 12),
                Text(
                  '+1-234-567-8900',
                  style: TextStyle(color: marineBlue.withOpacity(0.8)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: marineBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: lightBlue,
                  content: const Text('Opening email client...'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: marineBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Send Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDocumentOptions(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, color1],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: lightBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.share, color: marineBlue),
                ),
                title: Text(
                  'Share Document',
                  style: TextStyle(color: marineBlue, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _shareDocument(context, title);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.print, color: marineBlue),
                ),
                title: Text(
                  'Print Document',
                  style: TextStyle(color: marineBlue, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _printDocument(context, title);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.download, color: marineBlue),
                ),
                title: Text(
                  'Download PDF',
                  style: TextStyle(color: marineBlue, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _downloadDocument(context, title);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildConsentPreferencesSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: lightBlue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Consent Preferences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: marineBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Manage your privacy preferences and consents.',
            style: TextStyle(
              color: lightBlue.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildPreferenceToggle(
            title: 'Essential Cookies',
            subtitle: 'Required for app functionality',
            value: true,
          ),
          _buildPreferenceToggle(
            title: 'Analytics Cookies',
            subtitle: 'Help us improve our service',
            value: false,
          ),
          _buildPreferenceToggle(
            title: 'Marketing Cookies',
            subtitle: 'Personalized content and ads',
            value: false,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: lightBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: marineBlue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: lightBlue,
                        content: const Text('Preferences saved successfully'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: marineBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  
  Widget _buildPreferenceToggle({
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: marineBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: lightBlue.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {},
            activeThumbColor: lightBlue,
            activeTrackColor: lightBlue.withOpacity(0.3),
            inactiveThumbColor: marineBlue,
            inactiveTrackColor: marineBlue.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
  
  Widget _buildConsentHistoryScreen() {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text('Consent History'),
        backgroundColor: color1,
        foregroundColor: marineBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHistoryItem(
              document: 'Terms of Service',
              date: 'Dec 12, 2025',
              accepted: true,
            ),
            _buildHistoryItem(
              document: 'Privacy Policy',
              date: 'Dec 12, 2025',
              accepted: true,
            ),
            _buildHistoryItem(
              document: 'Cookie Policy',
              date: 'Dec 12, 2025',
              accepted: false,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHistoryItem({
    required String document,
    required String date,
    required bool accepted,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, color1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: accepted 
                    ? [lightBlue, marineBlue] 
                    : [marineBlue.withOpacity(0.5), lightBlue.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              accepted ? Icons.check : Icons.close,
              color: Colors.white,
            ),
          ),
          title: Text(
            document,
            style: TextStyle(
              color: marineBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Accepted on $date',
            style: TextStyle(
              color: lightBlue.withOpacity(0.8),
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: accepted 
                    ? [lightBlue, marineBlue] 
                    : [marineBlue.withOpacity(0.3), lightBlue.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              accepted ? 'Accepted' : 'Declined',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _shareDocument(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: lightBlue,
        content: Text('Sharing $title'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  void _printDocument(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: lightBlue,
        content: Text('Printing $title'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  void _downloadDocument(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: lightBlue,
        content: Text('Downloading $title as PDF'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// PolicyDocumentViewer with updated color scheme
class PolicyDocumentViewer extends StatelessWidget {
  final String title;
  final String content;
  final String lastUpdated;
  
  const PolicyDocumentViewer({
    super.key,
    required this.title,
    required this.content,
    required this.lastUpdated,
  });

  // Colors from main palette
  Color get color1 => const Color(0xFFCFE8EA);
  Color get color2 => const Color(0xFFACD9D9);
  Color get marineBlue => const Color.fromARGB(255, 8, 4, 84);
  Color get lightBlue => const Color.fromARGB(255, 0, 109, 176);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color1,
        foregroundColor: marineBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: marineBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: lightBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Last Updated: $lastUpdated',
                        style: TextStyle(
                          fontSize: 13,
                          color: lightBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: marineBlue,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Accept button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [marineBlue, lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
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
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: lightBlue,
                        content: Text('Accepted $title'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'I Accept',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}