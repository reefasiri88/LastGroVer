import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';
import '../models/home_metrics.dart';

class AiInsightSheet extends StatelessWidget {
  const AiInsightSheet({
    super.key,
    required this.metrics,
  });

  final HomeMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF09070E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'AI Insights',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gemini is not connected yet. These insights are generated from sustainability data.',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _InsightMetricCard(
                    label: 'Energy',
                    value: '${metrics.energyGeneratedKwh.toStringAsFixed(2)} kWh',
                    icon: Icons.bolt,
                  ),
                  _InsightMetricCard(
                    label: 'Carbon Avoided',
                    value: '${metrics.carbonAvoidedKg.toStringAsFixed(3)} kg',
                    icon: Icons.eco,
                  ),
                  _InsightMetricCard(
                    label: 'Calories',
                    value: '${metrics.caloriesBurned.toStringAsFixed(0)} kcal',
                    icon: Icons.local_fire_department,
                  ),
                  _InsightMetricCard(
                    label: 'Points',
                    value: '${metrics.earnedPoints}',
                    icon: Icons.emoji_events_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              PremiumCard(
                radius: 24,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Row(
                  children: [
                    const PremiumGradientIconBox(
                      icon: Icons.leaderboard,
                      size: 46,
                      iconSize: 22,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Leaderboard Position',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFAEA8B2),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            metrics.leaderboardRank == null
                                ? 'No rank yet'
                                : '#${metrics.leaderboardRank}',
                            style: const TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              PremiumCard(
                radius: 24,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommendations',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final line in metrics.recommendationLines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 16,
                                color: Color(0xFFFFC932),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                line,
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.84),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightMetricCard extends StatelessWidget {
  const _InsightMetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      child: PremiumCard(
        radius: 22,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumGradientIconBox(
              icon: icon,
              size: 40,
              iconSize: 18,
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.66),
              ),
            ),
          ],
        ),
      ),
    );
  }
}