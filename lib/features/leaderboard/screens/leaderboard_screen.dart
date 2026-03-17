import 'package:flutter/material.dart';

import '../../../app/router/route_names.dart';
import '../../events/widgets/decorative_background.dart';
import '../data/leaderboard_service.dart';
import '../models/leaderboard_summary.dart';
import '../ui/leaderboard_widgets.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  late Future<List<LeaderboardSummary>> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = _leaderboardService.fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: FutureBuilder<List<LeaderboardSummary>>(
            future: _leaderboardFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFA56EFF)),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Unable to load leaderboard.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final leaderboard = snapshot.data ?? const <LeaderboardSummary>[];
              final currentUser = leaderboard.where((entry) => entry.isCurrentUser).firstOrNull;
              final topThree = leaderboard.take(3).toList();
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LeaderboardHeader(
                      title: 'Leaderboard',
                    ),
                    const SizedBox(height: 28),
                    LeaderboardInsightCard(
                      text: _insightText(
                        currentUser: currentUser,
                        totalPlayers: leaderboard.length,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: LeaderboardTimeChip(label: '${leaderboard.length} players'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 396,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildPodiumEntry(topThree, 1, rank: 2, height: 166),
                              const SizedBox(width: 8),
                              _buildPodiumEntry(topThree, 0, rank: 1, height: 206),
                              const SizedBox(width: 8),
                              _buildPodiumEntry(topThree, 2, rank: 3, height: 148),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (currentUser != null)
                      LeaderboardListTile(
                        entry: LeaderboardEntry.fromSummary(currentUser),
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.leaderboardRankings);
                        },
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

  Widget _buildPodiumEntry(
    List<LeaderboardSummary> topThree,
    int index, {
    required int rank,
    required double height,
    bool showCrown = false,
  }) {
    if (topThree.length <= index) {
      return const Expanded(child: SizedBox.shrink());
    }

    final entry = LeaderboardEntry.fromSummary(topThree[index]);
    return PodiumColumn(
      rank: rank,
      height: height,
      label: entry.name,
      points: '${entry.points} QP',
      avatarColor: entry.avatarColor,
      avatarLabel: entry.avatarLabel,
      showCrown: showCrown,
    );
  }

  String _insightText({
    required LeaderboardSummary? currentUser,
    required int totalPlayers,
  }) {
    if (currentUser == null || totalPlayers <= 1) {
      return 'Complete more sessions to join the live leaderboard rankings.';
    }

    final betterThan = (((totalPlayers - currentUser.rank) / totalPlayers) * 100)
        .clamp(0, 100)
        .round();
    return 'You are doing better than\n$betterThan% of active players!';
  }
}