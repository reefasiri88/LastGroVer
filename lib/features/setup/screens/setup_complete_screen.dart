import 'package:flutter/material.dart';
import 'package:gromotion/app/router/route_names.dart';
import '../../profile/data/profile_service.dart';
import '../../profile/logic/profile_store.dart';
import '../data/setup_service.dart';
import '../logic/setup_store.dart';
import '../widgets/setup_background.dart';
import '../widgets/setup_button.dart';

class SetupCompleteScreen extends StatefulWidget {
  const SetupCompleteScreen({super.key});

  @override
  State<SetupCompleteScreen> createState() => _SetupCompleteScreenState();
}

class _SetupCompleteScreenState extends State<SetupCompleteScreen> {
  final _setupService = SetupService();
  final _profileService = ProfileService();

  bool _isLoading = false;

  Future<void> _handleCompleteSetup() async {
    final store = SetupStore.instance;

    if (!store.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Setup data is incomplete.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _setupService.saveUserSetup(
        gender: store.gender!,
        age: store.age!,
        weight: store.weight!,
        height: store.height!,
        community: store.community!,
      );

      await _profileService.markSetupCompleted();
      await ProfileStore.instance.setLoggedIn(true);
      store.clear();

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
    return SetupBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3CDA89).withValues(alpha: 0.2),
                  border: Border.all(
                    color: const Color(0xFF3CDA89),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 60,
                  color: Color(0xFF3CDA89),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Setup Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Alexandria',
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You\'re all set. Let\'s get you started with GroMotion!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFDDDDDD),
                  fontFamily: 'Alexandria',
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                child: SetupButton(
                  label: _isLoading ? 'Saving...' : 'Get Started',
                  onPressed: _isLoading
                      ? null
                      : () {
                          _handleCompleteSetup();
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