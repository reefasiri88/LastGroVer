import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';
import '../../events/widgets/back_button_widget.dart';
import '../../events/widgets/decorative_background.dart';
import '../data/activity_history_service.dart';
import '../models/activity_history.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ActivityHistoryService _historyService = ActivityHistoryService();
  late Future<ActivityHistoryData> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _historyService.loadHistory();
  }

  void _reload() {
    setState(() {
      _historyFuture = _historyService.loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: FutureBuilder<ActivityHistoryData>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFA56EFF)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _HistoryLoadErrorCard(onRetry: _reload),
                  ),
                );
              }

              final history = snapshot.data ?? const ActivityHistoryData(entries: []);
              final now = DateTime.now();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButtonWidget(
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'History',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 44),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const _HistorySummaryCard(),
                    const SizedBox(height: 18),
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        for (final activity in history.entries) ...[
                          _ActivityCard(
                            date: activity.dateLabelRelativeTo(now),
                            distance: activity.distanceLabel,
                            calories: activity.caloriesLabel,
                            steps: activity.stepsLabel,
                            stepsUnit: 'Steps',
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HistoryLoadErrorCard extends StatelessWidget {
  const _HistoryLoadErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Unable to load your activity history right now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF8A47FF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _HistorySummaryCard extends StatelessWidget {
  const _HistorySummaryCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Row(
        children: const [
          Expanded(
            child: _SummaryStatColumn(
              icon: Icons.schedule_rounded,
              value: '18,3 h',
              label: 'Time',
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _SummaryStatColumn(
              icon: Icons.route_rounded,
              value: '48,7 km',
              label: 'Distance',
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _SummaryStatColumn(
              icon: Icons.favorite_outline_rounded,
              value: '123 bpm',
              label: 'Heart Beat',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatColumn extends StatelessWidget {
  const _SummaryStatColumn({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PremiumGradientIconBox(
          icon: icon,
          size: 38,
          iconSize: 18,
        ),
        const SizedBox(height: 12),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.68),
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 84,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white.withValues(alpha: 0.1),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.date,
    required this.distance,
    required this.calories,
    required this.steps,
    required this.stepsUnit,
  });

  final String date;
  final String distance;
  final String calories;
  final String steps;
  final String stepsUnit;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const PremiumGradientIconBox(
            icon: Icons.directions_walk_rounded,
            size: 42,
            iconSize: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _MetricText(label: distance),
                    _MetricDot(),
                    _MetricText(label: calories),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                steps,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stepsUnit,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricText extends StatelessWidget {
  const _MetricText({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Alexandria',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.68),
      ),
    );
  }
}

class _MetricDot extends StatelessWidget {
  const _MetricDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.4),
      ),
    );
  }
}
