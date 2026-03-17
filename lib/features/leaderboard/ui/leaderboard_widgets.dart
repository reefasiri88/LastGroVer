import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';
import '../models/leaderboard_summary.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.points,
    required this.avatarColor,
    required this.avatarLabel,
    this.highlighted = false,
  });

  final int rank;
  final String name;
  final int points;
  final Color avatarColor;
  final String avatarLabel;
  final bool highlighted;

  factory LeaderboardEntry.fromSummary(LeaderboardSummary summary) {
    return LeaderboardEntry(
      rank: summary.rank,
      name: summary.displayName,
      points: summary.totalPoints,
      avatarColor: _avatarColorForUser(summary.userId),
      avatarLabel: _avatarLabelForName(summary.displayName),
      highlighted: summary.isCurrentUser,
    );
  }
}

Color _avatarColorForUser(String userId) {
  const palette = [
    Color(0xFFC6F6E5),
    Color(0xFFF7CAD9),
    Color(0xFFB7C9FF),
    Color(0xFFBB8BFF),
    Color(0xFFFFD29D),
    Color(0xFFFFA8D1),
    Color(0xFFB3ECFF),
    Color(0xFFBEF0A1),
    Color(0xFFFFC2A3),
    Color(0xFFC4C7FF),
  ];
  return palette[userId.hashCode.abs() % palette.length];
}

String _avatarLabelForName(String name) {
  final parts = name
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return 'G';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailingSpace = 44,
  });

  final String title;
  final Widget? leading;
  final double trailingSpace;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading ?? const SizedBox(width: 44, height: 44),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
        SizedBox(width: trailingSpace, height: 44),
      ],
    );
  }
}

class LeaderboardInsightCard extends StatelessWidget {
  const LeaderboardInsightCard({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      radius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 15,
            height: 1.45,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LeaderboardTimeChip extends StatelessWidget {
  const LeaderboardTimeChip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return PremiumChip(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardAvatar extends StatelessWidget {
  const LeaderboardAvatar({
    super.key,
    required this.size,
    required this.backgroundColor,
    required this.label,
    this.showCrown = false,
  });

  final double size;
  final Color backgroundColor;
  final String label;
  final bool showCrown;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + (showCrown ? 18 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          if (showCrown)
            Positioned(
              top: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF7B3CFF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          Positioned(
            top: showCrown ? 14 : 0,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF0C092A),
                  fontSize: size * 0.34,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PodiumColumn extends StatelessWidget {
  const PodiumColumn({
    super.key,
    required this.rank,
    required this.height,
    required this.label,
    required this.points,
    required this.avatarColor,
    required this.avatarLabel,
    this.showCrown = false,
  });

  final int rank;
  final double height;
  final String label;
  final String points;
  final Color avatarColor;
  final String avatarLabel;
  final bool showCrown;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LeaderboardAvatar(
            size: rank == 1 ? 60 : 54,
            backgroundColor: avatarColor,
            label: avatarLabel,
            showCrown: showCrown,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          PremiumChip(
            child: Text(
              points,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFA574FF),
                  const Color(0xFF6B2FF2),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 64,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardListTile extends StatelessWidget {
  const LeaderboardListTile({
    super.key,
    required this.entry,
    this.onTap,
  });

  final LeaderboardEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tile = PremiumCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB8B8BE)),
            ),
            alignment: Alignment.center,
            child: Text(
              '${entry.rank}',
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          LeaderboardAvatar(
            size: 56,
            backgroundColor: entry.avatarColor,
            label: entry.avatarLabel,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.points} points',
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF858494),
                  ),
                ),
              ],
            ),
          ),
          if (entry.highlighted)
            const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
        ],
      ),
    );

    if (onTap == null) {
      return tile;
    }

    return GestureDetector(onTap: onTap, child: tile);
  }
}
