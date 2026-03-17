import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';

class TodayActivityWidget extends StatelessWidget {
  final String date;
  final String time;
  final int pointsCurrent;
  final int pointsTotal;

  const TodayActivityWidget({
    required this.date,
    required this.time,
    required this.pointsCurrent,
    required this.pointsTotal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final progress = pointsTotal <= 0
        ? 0.0
        : (pointsCurrent / pointsTotal).clamp(0.0, 1.0);

    return PremiumCard(
      radius: 24,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Icon and text info
          Row(
            children: [
              const PremiumGradientIconBox(
                icon: Icons.directions_run,
                size: 56,
                iconSize: 26,
              ),
              const SizedBox(width: 12),
              // Text info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFAEA8B2),
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFAEA8B2),
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Right side - Points progress circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xFFFFC932),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pointsCurrent.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    '/$pointsTotal',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFAEA8B2),
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
