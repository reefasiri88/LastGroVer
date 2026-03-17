import 'package:flutter/material.dart';
import '../widgets/auth_background.dart';
import '../widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      showGradient: true,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            // Logo and title
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Power Up\nYour\nWalk !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Alexandria',
                      letterSpacing: 0,
                      height: 1.212,
                    ),
                  ),
                ],
              ),
            ),
            // Buttons
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        label: 'Login',
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        backgroundColor: Color.fromARGB(
                          63,
                          246,
                          242,
                          255,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        label: 'Register',
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
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
