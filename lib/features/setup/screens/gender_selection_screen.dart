import 'package:flutter/material.dart';
import '../../profile/logic/profile_store.dart';
import '../logic/setup_store.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/gender_button.dart';
import '../widgets/setup_background.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? _selectedGender;
  bool _isLoading = false;

  void _handleContinue() {
    if (_selectedGender == null) return;

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;

      SetupStore.instance.setGender(_selectedGender!);

      await ProfileStore.instance.saveProfilePatch(gender: _selectedGender);

      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-age');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SetupBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SetupHeader(
                title: "What's Your Gender",
              ),
              const SizedBox(height: 48),
              Center(
                child: GenderButton(
                  label: 'Male',
                  icon: Icons.male,
                  isSelected: _selectedGender == 'male',
                  onTap: () => setState(() => _selectedGender = 'male'),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: GenderButton(
                  label: 'Female',
                  icon: Icons.female,
                  isSelected: _selectedGender == 'female',
                  onTap: () => setState(() => _selectedGender = 'female'),
                ),
              ),
              const SizedBox(height: 48),
              SetupButton(
                label: 'Continue',
                onPressed: _handleContinue,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}