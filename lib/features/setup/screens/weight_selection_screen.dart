import 'package:flutter/material.dart';
import '../../profile/logic/profile_store.dart';
import '../logic/setup_store.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';
import '../widgets/weight_picker.dart';

class WeightSelectionScreen extends StatefulWidget {
  const WeightSelectionScreen({super.key});

  @override
  State<WeightSelectionScreen> createState() => _WeightSelectionScreenState();
}

class _WeightSelectionScreenState extends State<WeightSelectionScreen> {
  double _selectedWeight = 75;
  bool _isLoading = false;

  void _handleContinue() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;

      SetupStore.instance.setWeight(_selectedWeight);

      await ProfileStore.instance.saveProfilePatch(weightKg: _selectedWeight);

      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-height');
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
                title: "What Is Your Weight?",
              ),
              const SizedBox(height: 48),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: WeightPicker(
                    initialWeight: _selectedWeight,
                    minWeight: 40,
                    maxWeight: 150,
                    onWeightChanged: (weight) {
                      setState(() => _selectedWeight = weight);
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