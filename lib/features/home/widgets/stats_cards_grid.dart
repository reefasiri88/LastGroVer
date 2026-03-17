import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';

class StatsCardsGrid extends StatelessWidget {
  const StatsCardsGrid({
    super.key,
    required this.energyGeneratedKwh,
    required this.carbonAvoidedKg,
    required this.earnedPoints,
    required this.caloriesBurned,
  });

  final double energyGeneratedKwh;
  final double carbonAvoidedKg;
  final int earnedPoints;
  final double caloriesBurned;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row - 2 cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: energyGeneratedKwh.toStringAsFixed(2),
                unit: 'kWh',
                label: 'Energy Generated',
                icon: Icons.bolt,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: carbonAvoidedKg.toStringAsFixed(3),
                unit: 'kg',
                label: 'Co2 Reduced',
                icon: Icons.eco,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row - 2 cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: earnedPoints.toString(),
                unit: '',
                label: 'Earned Points',
                icon: Icons.emoji_events_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: caloriesBurned.toStringAsFixed(0),
                unit: 'kcal',
                label: 'Calories',
                icon: Icons.local_fire_department,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.unit,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumGradientIconBox(
            icon: icon,
            size: 42,
            iconSize: 20,
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Alexandria',
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: unit,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFAEA8B2),
                      fontFamily: 'Alexandria',
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.68),
              fontFamily: 'Alexandria',
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
