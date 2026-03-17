import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/supabase/supabase_client.dart';
import '../../home/data/sustainability_calculation_service.dart';
import '../../leaderboard/data/leaderboard_service.dart';
import 'activity_log_service.dart';

class ArSessionSummary {
  const ArSessionSummary({
    required this.steps,
    required this.coinsCollected,
    required this.distanceMeters,
  });

  final int steps;
  final int coinsCollected;
  final int distanceMeters;
}

class ArSessionService {
  ArSessionService({
    ActivityLogService? activityLogService,
    SustainabilityCalculationService? calculationService,
    LeaderboardService? leaderboardService,
  })  : _activityLogService = activityLogService ?? ActivityLogService(),
        _calculationService =
            calculationService ?? const SustainabilityCalculationService(),
        _leaderboardService = leaderboardService ?? LeaderboardService();

  static const _sessionIdKey = 'ar_session_service.current_ar_session_id';
  static const _sessionStartedAtKey =
      'ar_session_service.current_ar_session_started_at';

  final ActivityLogService _activityLogService;
  final SustainabilityCalculationService _calculationService;
  final LeaderboardService _leaderboardService;

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String?> startSession() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return null;
    }

    await _endStoredSession(summary: const ArSessionSummary(
      steps: 0,
      coinsCollected: 0,
      distanceMeters: 0,
    ));

    final startedAt = DateTime.now().toUtc();
    final response = await supabase
        .from('ar_sessions')
        .insert({
          'user_id': user.id,
          'started_at': startedAt.toIso8601String(),
          'created_at': startedAt.toIso8601String(),
        })
        .select('id')
        .single();

    final sessionId = response['id']?.toString();
    if (sessionId == null || sessionId.isEmpty) {
      throw StateError('AR session was created without an id.');
    }

    final prefs = await _prefs;
    await prefs.setString(_sessionIdKey, sessionId);
    await prefs.setString(_sessionStartedAtKey, startedAt.toIso8601String());
    return sessionId;
  }

  Future<void> endSession({required ArSessionSummary summary}) async {
    await _endStoredSession(summary: summary);
  }

  Future<void> _endStoredSession({required ArSessionSummary summary}) async {
    final prefs = await _prefs;
    final sessionId = prefs.getString(_sessionIdKey);
    if (sessionId == null || sessionId.isEmpty) {
      return;
    }

    final endedAt = DateTime.now().toUtc();
    final startedAt = DateTime.tryParse(
          prefs.getString(_sessionStartedAtKey) ?? '',
        ) ??
        endedAt;
    final calculatedMetrics = _calculationService.calculate(
      steps: summary.steps,
      coinsCollected: summary.coinsCollected,
    );

    await supabase.from('ar_sessions').update({
      'ended_at': endedAt.toIso8601String(),
      'duration_seconds': endedAt.difference(startedAt).inSeconds,
      'coins_collected': summary.coinsCollected,
      'earned_points': calculatedMetrics.earnedPoints,
      'energy_generated': calculatedMetrics.totalEnergyKwh,
      'distance_meters': summary.distanceMeters,
    }).eq('id', sessionId);

    final user = supabase.auth.currentUser;
    if (user != null) {
      await _activityLogService.insertLog(
        userId: user.id,
        payload: ActivityLogPayload(
          steps: summary.steps,
          energyGenerated: calculatedMetrics.totalEnergyKwh,
          carbonSaved: calculatedMetrics.carbonAvoidedKg,
          earnedPoints: calculatedMetrics.earnedPoints,
          caloriesBurned: calculatedMetrics.caloriesBurned,
          challengesJoinedCount: 0,
          coinsCollected: summary.coinsCollected,
        ),
        createdAt: endedAt,
      );
      await _leaderboardService.refreshCurrentUserSummary();
    }

    await clearLocalSession();
  }

  Future<void> clearLocalSession() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionIdKey);
    await prefs.remove(_sessionStartedAtKey);
  }
}