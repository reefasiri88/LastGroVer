import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../app/router/route_names.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/decorative_background.dart';

class YoureInScreen extends StatelessWidget {
  const YoureInScreen({super.key});

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.mainNavigation,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goToHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: DecorativeBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: BackButtonWidget(
                        onPressed: () => _goToHome(context),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Success checkmark
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF7B61FF),
                            Color(0xFF5E4A9B),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B61FF).withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Success text
                    const Text(
                      "You're In!",
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your registration for ',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.64),
                            ),
                          ),
                          const TextSpan(
                            text: 'Power Hour Event 2026',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' has been successfully confirmed.',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.64),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Event details card with countdown
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              // Countdown timer
                              const CountdownTimer(
                                days: '02',
                                hours: '08',
                                minutes: '47',
                                seconds: '03',
                              ),
                              const SizedBox(height: 20),
                              // Event details
                              Text(
                                'Wednesday, 12 May 2026',
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: const Color(0xFFfdfdfd),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ' 2:00 PM – 4:00 PM',
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: const Color(0xFFfdfdfd),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sedra Community',
                                    style: TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
