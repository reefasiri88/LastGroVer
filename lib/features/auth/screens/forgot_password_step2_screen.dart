import 'package:flutter/material.dart';
import '../widgets/auth_background.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordStep2Screen extends StatefulWidget {
  const ForgotPasswordStep2Screen({super.key});

  @override
  State<ForgotPasswordStep2Screen> createState() => _ForgotPasswordStep2ScreenState();
}

class _ForgotPasswordStep2ScreenState extends State<ForgotPasswordStep2Screen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/password-changed');
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
                'Create new password',
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
                'Your new password must be unique from those previously used.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.64),
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 50),
              PasswordField(
                label: 'New Password',
                placeholder: 'At least 8 characters',
                controller: _newPasswordController,
              ),
              SizedBox(height: 20),
              PasswordField(
                label: 'Confirm Password',
                placeholder: 'At least 8 characters',
                controller: _confirmPasswordController,
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Reset Password',
                  onPressed: _handleResetPassword,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
