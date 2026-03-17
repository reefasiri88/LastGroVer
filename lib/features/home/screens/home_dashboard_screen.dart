import 'package:flutter/material.dart';
import 'package:gromotion/app/router/route_names.dart';
import '../../events/widgets/decorative_background.dart';
import '../data/home_metrics_service.dart';
import '../models/home_metrics.dart';
import '../widgets/ai_insight_sheet.dart';
import '../widgets/user_greeting_card.dart';
import '../widgets/today_activity_widget.dart';
import '../widgets/stats_cards_grid.dart';
import '../widgets/history_preview_section.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final HomeMetricsService _homeMetricsService = HomeMetricsService();
  late Future<HomeMetrics> _metricsFuture;

  @override
  void initState() {
    super.initState();
    _metricsFuture = _homeMetricsService.loadMetrics();
  }

  void _reload() {
    setState(() {
      _metricsFuture = _homeMetricsService.loadMetrics();
    });
  }

  void _openAiInsights(HomeMetrics metrics) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AiInsightSheet(metrics: metrics),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: FutureBuilder<HomeMetrics>(
            future: _metricsFuture,
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
                    child: _HomeLoadErrorCard(onRetry: _reload),
                  ),
                );
              }

              final metrics = snapshot.data ?? const HomeMetrics.empty();
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserGreetingCard(
                      userName: metrics.userName,
                      userInitial: metrics.userInitial,
                      onAiPressed: () => _openAiInsights(metrics),
                    ),
                    const SizedBox(height: 24),
                    TodayActivityWidget(
                      date: metrics.todayDateLabel,
                      time: metrics.todayTimeLabel,
                      pointsCurrent: metrics.todayPoints,
                      pointsTotal: metrics.dailyPointsGoal,
                    ),
                    const SizedBox(height: 18),
                    StatsCardsGrid(
                      energyGeneratedKwh: metrics.energyGeneratedKwh,
                      carbonAvoidedKg: metrics.carbonAvoidedKg,
                      earnedPoints: metrics.earnedPoints,
                      caloriesBurned: metrics.caloriesBurned,
                    ),
                    const SizedBox(height: 18),
                    HistoryPreviewSection(
                      onSeeAll: () {
                        Navigator.pushNamed(context, RouteNames.history);
                      },
                    ),
                    const SizedBox(height: 24),
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

class _HomeLoadErrorCard extends StatelessWidget {
  const _HomeLoadErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF15111D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Unable to load your sustainability data right now.',
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
