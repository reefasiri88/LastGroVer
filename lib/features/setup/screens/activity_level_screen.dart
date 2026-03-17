import 'package:flutter/material.dart';
import '../widgets/setup_header.dart';
import '../widgets/setup_button.dart';
import '../widgets/setup_background.dart';
import '../widgets/setup_option_card.dart';

class ActivityLevelScreen extends StatefulWidget {
  const ActivityLevelScreen({super.key});

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  String? _selectedActivity;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _activities = [
    {'label': 'Sedentary', 'desc': 'Little or no exercise'},
    {'label': 'Lightly Active', 'desc': '1-3 days per week'},
    {'label': 'Moderately Active', 'desc': '3-5 days per week'},
    {'label': 'Very Active', 'desc': '6-7 days per week'},
  ];

  void _handleContinue() {
    if (_selectedActivity == null) return;
    
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/setup-community');
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
                title: "What's Your Activity Level?",
              ),
              SizedBox(height: 40),
              ..._activities.asMap().entries.map((entry) {
                final activity = entry.value;
                final activityLabel = activity['label'] as String;
                final isLast = entry.key == _activities.length - 1;
                return Column(
                  children: [
                    SetupOptionCard(
                      label: activityLabel,
                      isSelected: _selectedActivity == activityLabel,
                      onTap: () =>
                          setState(() => _selectedActivity = activityLabel),
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
