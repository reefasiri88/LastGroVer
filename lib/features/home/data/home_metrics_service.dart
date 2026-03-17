import '../../../core/supabase/supabase_client.dart';
import '../../leaderboard/data/leaderboard_service.dart';
import '../../leaderboard/models/leaderboard_summary.dart';
import '../../profile/data/profile_service.dart';
import '../models/home_metrics.dart';
import 'sustainability_calculation_service.dart';

class HomeMetricsService {
  HomeMetricsService({
    ProfileService? profileService,
    SustainabilityCalculationService? calculationService,
    LeaderboardService? leaderboardService,
  })  : _profileService = profileService ?? ProfileService(),
        _calculationService =
            calculationService ?? const SustainabilityCalculationService(),
        _leaderboardService = leaderboardService ?? LeaderboardService();

  static const int _dailyPointsGoal = 500;

  final ProfileService _profileService;
  final SustainabilityCalculationService _calculationService;
  final LeaderboardService _leaderboardService;

  Future<HomeMetrics> loadMetrics() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return const HomeMetrics.empty();
    }

    Map<String, dynamic>? profile;
    List<Map<String, dynamic>> activityRows = const [];
    List<Map<String, dynamic>> arSessionRows = const [];
    List<LeaderboardSummary> leaderboard = const [];

    try {
      profile = await _profileService.getMyProfile();
    } catch (_) {
      profile = null;
    }

    try {
      final activityResponse = await supabase
          .from('user_activity_logs')
          .select(
            'steps, energy_generated, carbon_saved, earned_points, calories_burned, coins_collected, created_at',
          )
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      activityRows = (activityResponse as List).cast<Map<String, dynamic>>();
    } catch (_) {
      activityRows = const [];
    }

    try {
      final arSessionsResponse = await supabase
          .from('ar_sessions')
          .select('duration_seconds, started_at, created_at')
          .eq('user_id', user.id)
          .order('started_at', ascending: false);
      arSessionRows = (arSessionsResponse as List).cast<Map<String, dynamic>>();
    } catch (_) {
      arSessionRows = const [];
    }

    try {
      leaderboard = await _leaderboardService.fetchLeaderboard();
    } catch (_) {
      leaderboard = const [];
    }
    final totalAggregate = _ActivityAggregate();
    final todayAggregate = _ActivityAggregate();
    final perDayAggregates = <String, _ActivityAggregate>{};
    final now = DateTime.now();
    DateTime? latestTodayActivityAt;

    for (final row in activityRows) {
      final metrics = _calculationService.fromActivityLog(row);
      final createdAt = DateTime.tryParse(row['created_at']?.toString() ?? '')?.toLocal();
      totalAggregate.add(metrics);

      if (createdAt != null) {
        final dayKey = _dayKey(createdAt);
        perDayAggregates.putIfAbsent(dayKey, _ActivityAggregate.new).add(metrics);
        if (_isSameDay(createdAt, now)) {
          todayAggregate.add(metrics);
          latestTodayActivityAt = _latestOf(latestTodayActivityAt, createdAt);
        }
      }
    }

    var todayDurationSeconds = 0;
    for (final row in arSessionRows) {
      final startedAt = DateTime.tryParse(
            row['started_at']?.toString() ?? row['created_at']?.toString() ?? '',
          )
          ?.toLocal();
      if (startedAt != null && _isSameDay(startedAt, now)) {
        todayDurationSeconds += _toInt(row['duration_seconds']);
        latestTodayActivityAt = _latestOf(latestTodayActivityAt, startedAt);
      }
    }

    final weeklyAverageEnergyKwh = _averageForWindow(
      aggregates: perDayAggregates,
      metricSelector: (aggregate) => aggregate.energyGeneratedKwh,
      now: now,
    );
    final recentAverageCaloriesBurned = _averageForWindow(
      aggregates: perDayAggregates,
      metricSelector: (aggregate) => aggregate.caloriesBurned,
      now: now,
    );

    final currentUserEntry = leaderboard.where((entry) => entry.isCurrentUser).firstOrNull;
    final pointsToNextRank = _pointsToNextRank(
      currentUserEntry: currentUserEntry,
      leaderboard: leaderboard,
    );

    return HomeMetrics(
      userName: _resolveUserName(profile, user.email),
      userInitial: _resolveUserInitial(profile, user.email),
      energyGeneratedKwh: totalAggregate.energyGeneratedKwh,
      carbonAvoidedKg: totalAggregate.carbonAvoidedKg,
      caloriesBurned: totalAggregate.caloriesBurned,
      earnedPoints: totalAggregate.earnedPoints,
      leaderboardRank: currentUserEntry?.rank,
      recommendationLines: _buildRecommendations(
        currentUserEntry: currentUserEntry,
        pointsToNextRank: pointsToNextRank,
        totalAggregate: totalAggregate,
        todayAggregate: todayAggregate,
        weeklyAverageEnergyKwh: weeklyAverageEnergyKwh,
        recentAverageCaloriesBurned: recentAverageCaloriesBurned,
      ),
      todayDate: now,
      todayTimeLabel: _formatTimeLabel(latestTodayActivityAt ?? now),
      todayDurationSeconds: todayDurationSeconds,
      todayPoints: todayAggregate.earnedPoints,
      dailyPointsGoal: _dailyPointsGoal,
      todayEnergyKwh: todayAggregate.energyGeneratedKwh,
      todayCaloriesBurned: todayAggregate.caloriesBurned,
      weeklyAverageEnergyKwh: weeklyAverageEnergyKwh,
      recentAverageCaloriesBurned: recentAverageCaloriesBurned,
      totalSteps: totalAggregate.totalSteps,
      totalCoins: totalAggregate.totalCoins,
      pointsToNextRank: pointsToNextRank,
    );
  }

  String _resolveUserName(Map<String, dynamic>? profile, String? fallbackEmail) {
    final username = profile?['username']?.toString().trim() ?? '';
    if (username.isNotEmpty) {
      return username;
    }

    final email = profile?['email']?.toString().trim() ?? fallbackEmail?.trim() ?? '';
    if (email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'Welcome back';
  }

  String _resolveUserInitial(Map<String, dynamic>? profile, String? fallbackEmail) {
    final userName = _resolveUserName(profile, fallbackEmail).trim();
    return userName.isEmpty ? 'G' : userName[0].toUpperCase();
  }

  List<String> _buildRecommendations({
    required LeaderboardSummary? currentUserEntry,
    required int? pointsToNextRank,
    required _ActivityAggregate totalAggregate,
    required _ActivityAggregate todayAggregate,
    required double weeklyAverageEnergyKwh,
    required double recentAverageCaloriesBurned,
  }) {
    final recommendations = <String>[];

    if (currentUserEntry != null &&
        pointsToNextRank != null &&
        pointsToNextRank > 0 &&
        pointsToNextRank <= 100) {
      recommendations.add(
        'You are only $pointsToNextRank points away from the next leaderboard rank.',
      );
    }

    if (todayAggregate.energyGeneratedKwh > 0 &&
        weeklyAverageEnergyKwh > 0 &&
        todayAggregate.energyGeneratedKwh > weeklyAverageEnergyKwh) {
      recommendations.add(
        'Your energy generation today is above your weekly average.',
      );
    }

    if (todayAggregate.caloriesBurned > 0 &&
        recentAverageCaloriesBurned > 0 &&
        todayAggregate.caloriesBurned > recentAverageCaloriesBurned) {
      recommendations.add(
        'Your calorie burn today is above your recent average.',
      );
    }

    if (totalAggregate.totalSteps > 0 && recommendations.length < 3) {
      recommendations.add(
        'Increasing your walking sessions will improve your carbon savings.',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        'Complete another walking session to start building energy and carbon savings.',
      );
    }

    return recommendations.take(3).toList(growable: false);
  }

  double _averageForWindow({
    required Map<String, _ActivityAggregate> aggregates,
    required double Function(_ActivityAggregate aggregate) metricSelector,
    required DateTime now,
  }) {
    final values = <double>[];
    for (var offset = 1; offset <= 7; offset++) {
      final day = now.subtract(Duration(days: offset));
      final aggregate = aggregates[_dayKey(day)];
      if (aggregate != null) {
        values.add(metricSelector(aggregate));
      }
    }

    if (values.isEmpty) {
      return 0;
    }

    return values.reduce((left, right) => left + right) / values.length;
  }

  int? _pointsToNextRank({
    required LeaderboardSummary? currentUserEntry,
    required List<LeaderboardSummary> leaderboard,
  }) {
    if (currentUserEntry == null || currentUserEntry.rank <= 1) {
      return null;
    }

    final nextEntry = leaderboard.where((entry) => entry.rank == currentUserEntry.rank - 1).firstOrNull;
    if (nextEntry == null) {
      return null;
    }

    return nextEntry.totalPoints - currentUserEntry.totalPoints;
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  String _dayKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DateTime? _latestOf(DateTime? current, DateTime candidate) {
    if (current == null || candidate.isAfter(current)) {
      return candidate;
    }
    return current;
  }

  String _formatTimeLabel(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minutes = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minutes $suffix';
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class _ActivityAggregate {
  int earnedPoints = 0;
  double energyGeneratedKwh = 0;
  double carbonAvoidedKg = 0;
  double caloriesBurned = 0;
  int totalSteps = 0;
  int totalCoins = 0;

  void add(CalculatedActivityMetrics metrics) {
    earnedPoints += metrics.earnedPoints;
    energyGeneratedKwh += metrics.totalEnergyKwh;
    carbonAvoidedKg += metrics.carbonAvoidedKg;
    caloriesBurned += metrics.caloriesBurned;
    totalSteps += metrics.steps;
    totalCoins += metrics.coinsCollected;
  }
}