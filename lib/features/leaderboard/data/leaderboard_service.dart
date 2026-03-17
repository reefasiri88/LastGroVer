import 'package:flutter/foundation.dart';

import '../../../core/supabase/supabase_client.dart';
import '../../home/data/sustainability_calculation_service.dart';
import '../models/leaderboard_summary.dart';

typedef _ProfileMap = Map<String, Map<String, dynamic>>;

class LeaderboardService {
  LeaderboardService({
    SustainabilityCalculationService? calculationService,
  }) : _calculationService =
            calculationService ?? const SustainabilityCalculationService();

  final SustainabilityCalculationService _calculationService;

  Future<List<LeaderboardSummary>> fetchLeaderboard() async {
    try {
      await _backfillLeaderboardSummaryIfNeeded();
    } catch (error) {
      debugPrint('Leaderboard summary backfill skipped: $error');
    }

    final currentUser = supabase.auth.currentUser;
    try {
      final profilesById = await _loadProfilesById();
      final summaryResponse = await supabase.from('leaderboard_summary').select(
        'user_id, username, total_points, total_energy_kwh, total_carbon_avoided_kg, total_steps, total_coins',
          );
      final summaryRows = (summaryResponse as List).cast<Map<String, dynamic>>();
      final entries = summaryRows
          .where((row) => (row['user_id']?.toString() ?? '').isNotEmpty)
          .map(
            (row) => _LeaderboardSortableRow(
              userId: row['user_id'].toString(),
              displayName: _displayNameForProfile(
                summaryRow: row,
                profile: profilesById[row['user_id']?.toString()],
                fallbackEmail:
                    currentUser?.id == row['user_id']?.toString() ? currentUser?.email : null,
              ),
              aggregate: _LeaderboardAggregate.fromSummaryRow(row),
              isCurrentUser: currentUser?.id == row['user_id']?.toString(),
            ),
          )
          .toList();

      _sortEntries(entries);
      return _toSummaries(entries);
    } catch (error) {
      debugPrint('Leaderboard summary read failed, falling back: $error');
      return _buildLeaderboardFromSources(currentUser: currentUser);
    }
  }

  Future<void> refreshCurrentUserSummary() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return;
    }

    await _upsertLeaderboardSummaryRows(userIds: {user.id});
  }

  Future<void> backfillLeaderboardSummary() async {
    await _upsertLeaderboardSummaryRows();
  }

  Future<void> _backfillLeaderboardSummaryIfNeeded() async {
    final relevantUserIds = await _loadRelevantUserIds();
    if (relevantUserIds.isEmpty) {
      return;
    }

    final summaryRows = await supabase.from('leaderboard_summary').select('user_id');
    final summaryUserIds = {
      for (final row in (summaryRows as List).cast<Map<String, dynamic>>())
        if ((row['user_id']?.toString() ?? '').isNotEmpty) row['user_id'].toString(),
    };

    if (summaryUserIds.length == relevantUserIds.length &&
        summaryUserIds.containsAll(relevantUserIds)) {
      return;
    }

    await _upsertLeaderboardSummaryRows(userIds: relevantUserIds);
  }

  Future<void> _upsertLeaderboardSummaryRows({Set<String>? userIds}) async {
    final relevantUserIds = userIds ?? await _loadRelevantUserIds();
    if (relevantUserIds.isEmpty) {
      return;
    }

    final aggregates = await _buildAggregatesForUsers(relevantUserIds);
    final profilesById = await _loadProfilesById();
    final rows = [
      for (final userId in relevantUserIds)
        {
          'user_id': userId,
          'username': _displayNameForProfile(
            summaryRow: null,
            profile: profilesById[userId],
            fallbackEmail: null,
          ),
          'total_points': aggregates[userId]?.totalPoints ?? 0,
          'total_energy_kwh': aggregates[userId]?.totalEnergyKwh ?? 0,
          'total_carbon_avoided_kg': aggregates[userId]?.totalCarbonAvoidedKg ?? 0,
          'total_steps': aggregates[userId]?.totalSteps ?? 0,
          'total_coins': aggregates[userId]?.totalCoins ?? 0,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
    ];

    try {
      await supabase
          .from('leaderboard_summary')
          .upsert(rows, onConflict: 'user_id');
    } catch (error) {
      debugPrint('Leaderboard summary update skipped: $error');
    }
  }

  Future<Set<String>> _loadRelevantUserIds() async {
    final profilesResponse = await supabase.from('profiles').select('id');
    final activityLogsResponse = await supabase.from('user_activity_logs').select('user_id');
    final arSessionsResponse = await supabase.from('ar_sessions').select('user_id');

    final relevantUserIds = <String>{};
    for (final row in (profilesResponse as List).cast<Map<String, dynamic>>()) {
      final id = row['id']?.toString();
      if (id != null && id.isNotEmpty) {
        relevantUserIds.add(id);
      }
    }
    for (final row in (activityLogsResponse as List).cast<Map<String, dynamic>>()) {
      final id = row['user_id']?.toString();
      if (id != null && id.isNotEmpty) {
        relevantUserIds.add(id);
      }
    }
    for (final row in (arSessionsResponse as List).cast<Map<String, dynamic>>()) {
      final id = row['user_id']?.toString();
      if (id != null && id.isNotEmpty) {
        relevantUserIds.add(id);
      }
    }
    return relevantUserIds;
  }

  Future<Map<String, _LeaderboardAggregate>> _buildAggregatesForUsers(
    Set<String> userIds,
  ) async {
    final activityLogsResponse = await supabase.from('user_activity_logs').select(
          'user_id, steps, energy_generated, carbon_saved, earned_points, calories_burned, coins_collected, created_at',
        );
    final arSessionsResponse = await supabase.from('ar_sessions').select(
          'user_id, energy_generated, earned_points, coins_collected',
        );

    final aggregates = <String, _LeaderboardAggregate>{
      for (final userId in userIds) userId: _LeaderboardAggregate(),
    };
    final hasActivityLogs = <String>{};

    for (final row in (activityLogsResponse as List).cast<Map<String, dynamic>>()) {
      final userId = row['user_id']?.toString();
      if (userId == null || !userIds.contains(userId)) {
        continue;
      }

      final metrics = _calculationService.fromActivityLog(row);
      aggregates[userId]!.add(metrics);
      hasActivityLogs.add(userId);
    }

    for (final row in (arSessionsResponse as List).cast<Map<String, dynamic>>()) {
      final userId = row['user_id']?.toString();
      if (userId == null || !userIds.contains(userId) || hasActivityLogs.contains(userId)) {
        continue;
      }

      aggregates[userId]!.addFallbackSession(
        energyGeneratedKwh: _toDoubleStatic(row['energy_generated']),
        earnedPoints: _toIntStatic(row['earned_points']),
        coinsCollected: _toIntStatic(row['coins_collected']),
        carbonAvoidedKg:
            _toDoubleStatic(row['energy_generated']) * SustainabilityFormulaConstants.gridEmissionFactorKgPerKwh,
      );
    }

    return aggregates;
  }

  Future<_ProfileMap> _loadProfilesById() async {
    final profilesResponse = await supabase
        .from('profiles')
        .select('id, username, email');
    final profilesById = <String, Map<String, dynamic>>{};
    for (final profile in (profilesResponse as List).cast<Map<String, dynamic>>()) {
      final id = profile['id']?.toString();
      if (id != null && id.isNotEmpty) {
        profilesById[id] = profile;
      }
    }
    return profilesById;
  }

  void _sortEntries(List<_LeaderboardSortableRow> entries) {
    entries.sort((left, right) {
      final byPoints = right.aggregate.totalPoints.compareTo(left.aggregate.totalPoints);
      if (byPoints != 0) {
        return byPoints;
      }
      final byEnergy = right.aggregate.totalEnergyKwh.compareTo(left.aggregate.totalEnergyKwh);
      if (byEnergy != 0) {
        return byEnergy;
      }
      return right.aggregate.totalSteps.compareTo(left.aggregate.totalSteps);
    });
  }

  Future<List<LeaderboardSummary>> _buildLeaderboardFromSources({
    required dynamic currentUser,
  }) async {
    final profilesById = await _loadProfilesById();
    final relevantUserIds = await _loadRelevantUserIds();
    final aggregates = await _buildAggregatesForUsers(relevantUserIds);
    final entries = [
      for (final userId in relevantUserIds)
        _LeaderboardSortableRow(
          userId: userId,
          displayName: _displayNameForProfile(
            summaryRow: null,
            profile: profilesById[userId],
            fallbackEmail: currentUser?.id == userId ? currentUser?.email : null,
          ),
          aggregate: aggregates[userId] ?? _LeaderboardAggregate(),
          isCurrentUser: currentUser?.id == userId,
        ),
    ];
    _sortEntries(entries);
    return _toSummaries(entries);
  }

  List<LeaderboardSummary> _toSummaries(List<_LeaderboardSortableRow> entries) {
    return [
      for (var index = 0; index < entries.length; index++)
        LeaderboardSummary(
          userId: entries[index].userId,
          displayName: entries[index].displayName,
          rank: index + 1,
          totalPoints: entries[index].aggregate.totalPoints,
          totalEnergyKwh: entries[index].aggregate.totalEnergyKwh,
          totalCarbonAvoidedKg: entries[index].aggregate.totalCarbonAvoidedKg,
          totalSteps: entries[index].aggregate.totalSteps,
          totalCoins: entries[index].aggregate.totalCoins,
          totalCaloriesBurned: entries[index].aggregate.totalCaloriesBurned,
          isCurrentUser: entries[index].isCurrentUser,
        ),
    ];
  }

  String _displayNameForProfile({
    required Map<String, dynamic>? summaryRow,
    required Map<String, dynamic>? profile,
    String? fallbackEmail,
  }) {
    final summaryUsername = summaryRow?['username']?.toString().trim() ?? '';
    if (summaryUsername.isNotEmpty) {
      return summaryUsername;
    }

    final username = profile?['username']?.toString().trim() ?? '';
    if (username.isNotEmpty) {
      return username;
    }

    final email = profile?['email']?.toString().trim() ?? fallbackEmail?.trim() ?? '';
    if (email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'GroMotion User';
  }
}

class _LeaderboardAggregate {
  _LeaderboardAggregate();

  int totalPoints = 0;
  double totalEnergyKwh = 0;
  double totalCarbonAvoidedKg = 0;
  int totalSteps = 0;
  int totalCoins = 0;
  double totalCaloriesBurned = 0;

  factory _LeaderboardAggregate.fromSummaryRow(Map<String, dynamic> row) {
    return _LeaderboardAggregate()
      ..totalPoints = _toIntStatic(row['total_points'])
      ..totalEnergyKwh = _toDoubleStatic(row['total_energy_kwh'])
      ..totalCarbonAvoidedKg = _toDoubleStatic(row['total_carbon_avoided_kg'])
      ..totalSteps = _toIntStatic(row['total_steps'])
      ..totalCoins = _toIntStatic(row['total_coins'])
      ..totalCaloriesBurned = _toDoubleStatic(row['total_calories_burned']);
  }

  void add(CalculatedActivityMetrics metrics) {
    totalPoints += metrics.earnedPoints;
    totalEnergyKwh += metrics.totalEnergyKwh;
    totalCarbonAvoidedKg += metrics.carbonAvoidedKg;
    totalSteps += metrics.steps;
    totalCoins += metrics.coinsCollected;
    totalCaloriesBurned += metrics.caloriesBurned;
  }

  void addFallbackSession({
    required double energyGeneratedKwh,
    required double carbonAvoidedKg,
    required int earnedPoints,
    required int coinsCollected,
  }) {
    totalPoints += earnedPoints;
    totalEnergyKwh += energyGeneratedKwh;
    totalCarbonAvoidedKg += carbonAvoidedKg;
    totalCoins += coinsCollected;
  }
}

class _LeaderboardSortableRow {
  const _LeaderboardSortableRow({
    required this.userId,
    required this.displayName,
    required this.aggregate,
    required this.isCurrentUser,
  });

  final String userId;
  final String displayName;
  final _LeaderboardAggregate aggregate;
  final bool isCurrentUser;
}

int _toIntStatic(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDoubleStatic(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}