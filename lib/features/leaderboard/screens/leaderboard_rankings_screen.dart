import 'package:flutter/material.dart';

import '../../events/widgets/back_button_widget.dart';
import '../../events/widgets/decorative_background.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../data/leaderboard_service.dart';
import '../models/leaderboard_summary.dart';
import '../ui/leaderboard_widgets.dart';

class LeaderboardRankingsScreen extends StatefulWidget {
  const LeaderboardRankingsScreen({super.key});

  @override
  State<LeaderboardRankingsScreen> createState() => _LeaderboardRankingsScreenState();
}

class _LeaderboardRankingsScreenState extends State<LeaderboardRankingsScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  late Future<List<LeaderboardSummary>> _rankingsFuture;

  @override
  void initState() {
    super.initState();
    _rankingsFuture = _leaderboardService.fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: LeaderboardHeader(
                  title: 'Leaderboard',
                  leading: BackButtonWidget(
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: FutureBuilder<List<LeaderboardSummary>>(
                  future: _rankingsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFFA56EFF)),
                      );
                    }

                    final rankings = snapshot.data ?? const <LeaderboardSummary>[];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PremiumCard(
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
                        child: ListView.separated(
                          itemCount: rankings.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final entry = LeaderboardEntry.fromSummary(rankings[index]);
                            return LeaderboardListTile(entry: entry);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
