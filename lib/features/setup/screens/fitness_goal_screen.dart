import 'package:flutter/material.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';
import '../widgets/setup_option_card.dart';

class FitnessGoalScreen extends StatefulWidget {
  const FitnessGoalScreen({super.key});

  @override
  State<FitnessGoalScreen> createState() => _FitnessGoalScreenState();
}

class _FitnessGoalScreenState extends State<FitnessGoalScreen> {
  String? _selectedGoal;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _goals = [
    {'label': 'Build Muscle', 'icon': Icons.fitness_center},
    {'label': 'Lose Weight', 'icon': Icons.trending_down},
    {'label': 'Stay Healthy', 'icon': Icons.favorite},
    {'label': 'Improve Endurance', 'icon': Icons.directions_run},
  ];

  void _handleContinue() {
    if (_selectedGoal == null) return;
    
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-level');
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
                title: "What's Your Fitness Goal?",
              ),
              SizedBox(height: 40),
              ..._goals.asMap().entries.map((entry) {
                final goal = entry.value;
                final goalLabel = goal['label'] as String;
                final isLast = entry.key == _goals.length - 1;
                return Column(
                  children: [
                    SetupOptionCard(
                      label: goalLabel,
                      icon: goal['icon'] as IconData,
                      isSelected: _selectedGoal == goalLabel,
                      onTap: () => setState(() => _selectedGoal = goalLabel),
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
