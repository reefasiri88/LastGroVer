import 'package:flutter/material.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';

class SetupWelcomeScreen extends StatelessWidget {
  const SetupWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SetupBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                'Welcome to Setup',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Alexandria',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Let\'s get to know you better so we can personalize your experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFDDDDDD),
                  fontFamily: 'Alexandria',
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFA56EFF).withValues(alpha: 0.1),
                  border: Border.all(
                    color: Color(0xFFA56EFF).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 48,
                      color: Color(0xFFA56EFF),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This will take about 2 minutes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                child: SetupButton(
                  label: 'Get Started',
                  onPressed: () {
                    Navigator.pushNamed(context, '/setup-gender');
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
