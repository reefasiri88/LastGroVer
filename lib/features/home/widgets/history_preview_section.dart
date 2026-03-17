import 'package:flutter/material.dart';

import '../../../core/widgets/premium_widgets.dart';
import '../data/activity_history_service.dart';
import '../models/activity_history.dart';

class HistoryPreviewSection extends StatefulWidget {
  final VoidCallback onSeeAll;

  const HistoryPreviewSection({
    required this.onSeeAll,
    super.key,
  });

  @override
  State<HistoryPreviewSection> createState() => _HistoryPreviewSectionState();
}

class _HistoryPreviewSectionState extends State<HistoryPreviewSection> {
  final ActivityHistoryService _historyService = ActivityHistoryService();
  late Future<ActivityHistoryData> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _historyService.loadHistory(minimumEntries: 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ActivityHistoryData>(
      future: _historyFuture,
      builder: (context, snapshot) {
        final now = DateTime.now();
        final entry = snapshot.data?.latestEntry;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Alexandria',
                    decoration: TextDecoration.none,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onSeeAll,
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.6),
                      fontFamily: 'Alexandria',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PremiumCard(
              radius: 24,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry?.dateLabelRelativeTo(now) ?? 'Yesterday',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Alexandria',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                entry?.pointsLabel ?? '0 pt',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: 'Alexandria',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFAEA8B2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                entry?.distanceLabel ?? '0,0 km',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFAEA8B2),
                                  fontFamily: 'Alexandria',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFAEA8B2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                entry?.caloriesLabel ?? '0 kcal',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            entry?.stepsLabel ?? '0',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Alexandria',
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Steps',
                            style: TextStyle(
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
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
