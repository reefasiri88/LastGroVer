import 'package:flutter/material.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';
import '../widgets/setup_option_card.dart';

class FitnessLevelScreen extends StatefulWidget {
  const FitnessLevelScreen({super.key});

  @override
  State<FitnessLevelScreen> createState() => _FitnessLevelScreenState();
}

class _FitnessLevelScreenState extends State<FitnessLevelScreen> {
  String? _selectedLevel;
  bool _isLoading = false;

  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  void _handleContinue() {
    if (_selectedLevel == null) return;
    
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-activity');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SetupBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SetupHeader(
                title: "What's Your Fitness Level?",
              ),
              SizedBox(height: 40),
              ..._levels.asMap().entries.map((entry) {
                final level = entry.value;
                final isLast = entry.key == _levels.length - 1;
                return Column(
                  children: [
                    SetupOptionCard(
                      label: level,
                      isSelected: _selectedLevel == level,
                      onTap: () => setState(() => _selectedLevel = level),
                    ),
                    if (!isLast) SizedBox(height: 16),
                  ],
                );
              }),
              SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: SetupButton(
                  label: 'Continue',
                  onPressed: _handleContinue,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
