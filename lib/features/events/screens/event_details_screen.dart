import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/back_button_widget.dart';
import '../widgets/gradient_button.dart';
import '../widgets/frosted_glass_button.dart';
import '../widgets/decorative_background.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventTitle;
  final String eventDescription;
  final String eventDate;

  const EventDetailsScreen({
    super.key,
    required this.eventTitle,
    required this.eventDescription,
    required this.eventDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: BackButtonWidget(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Event details card with frosted glass effect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.13),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event description
                            Text(
                              eventDescription,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Buttons
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        GradientButton(
                          label: 'Register',
                          onPressed: () {
                            Navigator.pushNamed(context, '/events/register');
                          },
                        ),
                        const SizedBox(height: 12),
                        FrostedGlassButton(
                          label: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
