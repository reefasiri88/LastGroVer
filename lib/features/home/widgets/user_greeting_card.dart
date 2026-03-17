import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';

class UserGreetingCard extends StatelessWidget {
  final String userName;
  final String userInitial;
  final VoidCallback onAiPressed;

  const UserGreetingCard({
    required this.userName,
    required this.userInitial,
    required this.onAiPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFA56EFF),
                      Color(0xFF4D4FD7),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    userInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$userName !',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'have a great day',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.68),
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: onAiPressed,
            child: const PremiumGradientIconBox(
              icon: Icons.auto_awesome_rounded,
              size: 42,
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
