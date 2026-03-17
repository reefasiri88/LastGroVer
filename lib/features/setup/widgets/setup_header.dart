import 'package:flutter/material.dart';

class SetupHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const SetupHeader({
    required this.title,
    this.onBackPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onBackPressed ?? () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(13),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Alexandria',
            letterSpacing: -0.3,
            height: 1.3,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
