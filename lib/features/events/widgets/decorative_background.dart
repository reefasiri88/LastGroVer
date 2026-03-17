import 'package:flutter/material.dart';

class DecorativeBackground extends StatelessWidget {
  final Widget child;

  const DecorativeBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Black background
        Container(
          color: Colors.black,
        ),
        // Top-left decorative circle (blurred purple)
        Positioned(
          top: -74,
          left: -98,
          child: Container(
            width: 359,
            height: 359,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.purple.withValues(alpha: 0.3),
                  Colors.purple.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.2),
                  blurRadius: 40,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),
        // Bottom-left decorative circle (blurred purple)
        Positioned(
          bottom: -150,
          left: -76,
          child: Container(
            width: 488,
            height: 437,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.purple.withValues(alpha: 0.2),
                  Colors.purple.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.15),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),
        // Child content
        child,
      ],
    );
  }
}
