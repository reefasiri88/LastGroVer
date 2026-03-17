import 'package:flutter/material.dart';
import '../../profile/logic/profile_store.dart';
import '../logic/setup_store.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';
import '../widgets/age_picker.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  State<AgeSelectionScreen> createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  int _selectedAge = 28;
  bool _isLoading = false;

  void _handleContinue() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;

      SetupStore.instance.setAge(_selectedAge);

      await ProfileStore.instance.saveProfilePatch(age: _selectedAge);

      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-weight');
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
            children: [
              const SetupHeader(
                title: "How Old Are You?",
              ),
              const SizedBox(height: 48),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: AgePicker(
                    initialAge: _selectedAge,
                    minAge: 18,
                    maxAge: 100,
                    onAgeChanged: (age) {
                      setState(() => _selectedAge = age);
                    },
                  ),
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