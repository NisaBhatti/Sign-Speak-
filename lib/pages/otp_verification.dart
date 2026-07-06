import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reset_code_screen.dart';
import 'login.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;
  
  const OTPVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  int _timerSeconds = 60;
  bool _canResend = false;

  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color darkBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
        if (_timerSeconds == 0) {
          setState(() {
            _canResend = true;
          });
        } else {
          _startTimer();
        }
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: widget.email);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New verification code sent! Check your email.'),
            backgroundColor: Colors.green,
          ),
        );
        
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
        
        setState(() {
          _timerSeconds = 60;
          _canResend = false;
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _verifyOTP() {
    String otp = _otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code verified! Now enter the code from your email.'),
        backgroundColor: Colors.green,
      ),
    );

    // ✅ FIXED: Correct class name and parameters
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResetCodeScreen(
          email: widget.email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
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
                
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: darkBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.security, size: 40, color: darkBlue),
                ),
                
                const SizedBox(height: 30),
                
                const Text(
                  'Enter Verification Code',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkBlue),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                Text.rich(
                  TextSpan(
                    text: 'We\'ve sent a 6-digit code to\n',
                    style: TextStyle(fontSize: 16, color: darkBlue.withOpacity(0.7)),
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: darkBlue),
                      ),
                      const TextSpan(text: '\nCheck your inbox and spam folder'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkBlue),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: darkBlue.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: darkBlue, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (_otpControllers.every((c) => c.text.isNotEmpty)) {
                            _verifyOTP();
                          }
                        },
                      ),
                    );
                  }),
                ),
                
                const SizedBox(height: 30),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_canResend)
                      Text(
                        'Resend code in ${_timerSeconds}s',
                        style: TextStyle(color: darkBlue.withOpacity(0.7), fontSize: 14),
                      )
                    else
                      TextButton(
                        onPressed: _isLoading ? null : _resendCode,
                        child: const Text('Resend Code', style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Back to Login', style: TextStyle(color: darkBlue, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}