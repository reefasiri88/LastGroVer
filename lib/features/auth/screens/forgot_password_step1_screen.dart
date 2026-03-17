import 'package:flutter/material.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_footer.dart';

class ForgotPasswordStep1Screen extends StatefulWidget {
  const ForgotPasswordStep1Screen({super.key});

  @override
  State<ForgotPasswordStep1Screen> createState() => _ForgotPasswordStep1ScreenState();
}

class _ForgotPasswordStep1ScreenState extends State<ForgotPasswordStep1Screen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendCode() {
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/forgot-password-2');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.chevron_left, color: Colors.white, size: 24),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Alexandria',
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Don't worry! It occurs. Please enter the email address linked with your account.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.64),
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 50),
              AuthTextField(
                label: 'Email',
                placeholder: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Send Code',
                  onPressed: _handleSendCode,
                  isLoading: _isLoading,
                ),
              ),
              SizedBox(height: 48),
              Center(
                child: AuthFooter(
                  mainText: 'Remember Password?',
                  linkText: 'Login',
                  onLinkTapped: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
