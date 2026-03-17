import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../ui/onboarding_screen_1.dart';
import '../ui/onboarding_screen_2.dart';
import '../ui/onboarding_screen_3.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: [
        OnboardingScreen1(
          onNext: _nextPage,
          onSkip: _goToLogin,
        ),
        OnboardingScreen2(
          onNext: _nextPage,
          onSkip: _goToLogin,
        ),
        OnboardingScreen3(
          onNext: _nextPage,
          onSkip: _goToLogin,
        ),
      ],
    );
  }
}
