import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reset_code_screen.dart'; // Fixed: correct file name

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color darkBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      print('Attempting to send password reset email to: $email');
      
      try {
        String email = _emailController.text.trim().toLowerCase();
        
        List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
        
        if (signInMethods.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No account found with this email. Please sign up first.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() => _isLoading = false);
          return;
        }

        await _auth.sendPasswordResetEmail(email: email);

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
              builder: (context) => ResetCodeScreen(email: email),
            ),
          );

        }
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException Details:');
        print('  Code: ${e.code}');
        print('  Message: ${e.message}');
        
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':

            errorMessage = 'No account found with this email address. Please sign up first.';
            errorMessage = 'No user found with this email.';

            break;
          case 'invalid-email':
            errorMessage = 'Please enter a valid email.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests. Try again later.';
            break;
          default:
            errorMessage = e.message ?? 'An error occurred.';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: MyApp.color1,
        elevation: 0,
        foregroundColor: MyApp.darkBlue,
      ),
      body: SafeArea(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: darkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: darkBlue),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  const Icon(Icons.lock_reset, size: 80, color: darkBlue),
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkBlue),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Enter your email and we\'ll send you a code to reset your password.',
                    style: TextStyle(fontSize: 16, color: darkBlue.withOpacity(0.7), height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16, color: darkBlue),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: const Icon(Icons.email_outlined, color: darkBlue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: darkBlue.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: darkBlue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendResetEmail,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: darkBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          )
                        : const Text('Send Code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Login', style: TextStyle(color: darkBlue, fontSize: 16)),
                  ),
                ],
              ),
>>>>>>> a801e51b9c28cd5b38e20b8b3008df4c8fd057e1
            ),
          ),
        ),
      ),
    );
  }
}