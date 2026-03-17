import 'package:flutter/material.dart';

import '../../../app/router/route_names.dart';
import '../data/session_service.dart';
import '../../profile/logic/profile_store.dart';
import '../widgets/auth_background.dart';
import '../widgets/otp_field.dart';
import '../widgets/primary_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String _otp = '';
  final _sessionService = SessionService();
  bool _isLoading = false;

  Future<void> _handleVerify() async {
    if (_otp.length != 4) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ProfileStore.instance.setLoggedIn(true);
      await _sessionService.startSession();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.mainNavigation,
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                'OTP Verification',
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
                'Enter the verification code we just sent on your email address.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.64),
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 50),
              OTPField(
                length: 4,
                onChanged: (otp) {
                  setState(() => _otp = otp);
                },
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Verify',
                  onPressed: _handleVerify,
                  isLoading: _isLoading,
                ),
              ),
              SizedBox(height: 48),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Resend OTP logic
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't received code? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(
                            color: Color(0xFFffa434),
                            fontSize: 15,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
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
