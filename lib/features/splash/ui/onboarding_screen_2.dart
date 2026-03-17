import 'package:flutter/material.dart';
import '../../../app/theme/app_text_styles.dart';
import 'status_bar.dart';
import 'home_indicator.dart';
import 'onboarding_page_indicator.dart';
import 'next_button.dart';

class OnboardingScreen2 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingScreen2({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/onboarding_2_bg.png',
            fit: BoxFit.cover,
          ),
          // Gradient overlay - image to black
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                  Colors.black,
                ],
                stops: const [0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          // Purple gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xFF480a9f).withValues(alpha: 0.3),
                  Color(0xFF480a9f).withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // Status bar
              const StatusBar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Title & Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            'Join your community challenges.',
                            style: AppTextStyles.title.copyWith(
                              letterSpacing: 0.36,
                              height: 34 / 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Work together to light up parks and playgrounds in your neighborhood.',
                            style: AppTextStyles.body,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 44),
                    // Page indicator
                    OnboardingPageIndicator(
                      currentPage: 1,
                      totalPages: 3,
                    ),
                    const SizedBox(height: 44),
                    // Next button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: NextButton(
                          onPressed: onNext,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Skip button
                    GestureDetector(
                      onTap: onSkip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFFFEF9EE),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Alexandria',
                          letterSpacing: -0.24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              // Home indicator
              const HomeIndicator(),
            ],
          ),
        ],
      ),
    );
  }
}
