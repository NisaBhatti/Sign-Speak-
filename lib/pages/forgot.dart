import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      print('Attempting to send password reset email to: $email');
      
      try {
        // Configure action code settings (optional but recommended)
        ActionCodeSettings actionCodeSettings = ActionCodeSettings(
          url: 'https://signspeak-85332.firebaseapp.com/__/auth/action?mode=resetPassword',
          handleCodeInApp: true,
          iOSBundleId: 'com.example.signspeak',
          androidPackageName: 'com.example.signspeak',
          androidInstallApp: true,
          androidMinimumVersion: '1',
        );

        await _auth.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: actionCodeSettings, // Optional: remove if not needed
        );
        
        print('Password reset email sent successfully to: $email');

        if (mounted) {
          // Show success message with more details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '✓ Password reset email sent!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Please check your inbox (and spam folder)',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back to login screen after short delay
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException Details:');
        print('  Code: ${e.code}');
        print('  Message: ${e.message}');
        
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No account found with this email address. Please sign up first.';
            break;
          case 'invalid-email':
            errorMessage = 'Please enter a valid email address.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many reset attempts. Please wait a few minutes and try again.';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Please check your internet connection.';
            break;
          case 'missing-android-pkg-name':
            errorMessage = 'Configuration error. Please contact support.';
            break;
          case 'missing-ios-bundle-id':
            errorMessage = 'Configuration error. Please contact support.';
            break;
          default:
            errorMessage = 'Failed to send reset email: ${e.message}';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        print('Unexpected error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'An unexpected error occurred. Please try again.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: MyApp.color1,
        elevation: 0,
        foregroundColor: MyApp.darkBlue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Icon
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: MyApp.darkBlue,
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: MyApp.darkBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  'Enter your email address below and we\'ll send you a link to reset your password.',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 109, 176).withOpacity(0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MyApp.color1.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MyApp.color2,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: MyApp.darkBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Make sure to check your spam/junk folder if you don\'t see the email in your inbox.',
                          style: TextStyle(
                            fontSize: 12,
                            color: MyApp.darkBlue.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'you@example.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: MyApp.darkBlue,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Reset Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: MyApp.darkBlue,
                    disabledBackgroundColor: MyApp.darkBlue.withOpacity(0.6),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // Back to Login
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: MyApp.darkBlue,
                  ),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}