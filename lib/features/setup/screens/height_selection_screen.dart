import 'package:flutter/material.dart';
import '../../profile/logic/profile_store.dart';
import '../logic/setup_store.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';
import '../widgets/height_picker.dart';

class HeightSelectionScreen extends StatefulWidget {
  const HeightSelectionScreen({super.key});

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  double _selectedHeight = 165;
  bool _isLoading = false;

  void _handleContinue() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;

      SetupStore.instance.setHeight(_selectedHeight);

      await ProfileStore.instance.saveProfilePatch(heightCm: _selectedHeight);

      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-community');
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
                title: "What Is Your Height?",
              ),
              const SizedBox(height: 48),
              Center(
                child: HeightPicker(
                  initialHeight: _selectedHeight,
                  minHeight: 140,
                  maxHeight: 220,
                  onHeightChanged: (height) {
                    setState(() => _selectedHeight = height);
                  },
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