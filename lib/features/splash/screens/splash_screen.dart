import 'dart:async';
import 'package:flutter/material.dart';
import '../ui/splash_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_handleLaunch());
  }

  Future<void> _handleLaunch() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashTransition(),
    );
  }
}