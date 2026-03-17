import '../../../core/supabase/supabase_client.dart';

class ActivityLogPayload {
  const ActivityLogPayload({
    required this.steps,
    required this.energyGenerated,
    required this.carbonSaved,
    required this.earnedPoints,
    required this.caloriesBurned,
    required this.challengesJoinedCount,
    required this.coinsCollected,
  });

  final int steps;
  final double energyGenerated;
  final double carbonSaved;
  final int earnedPoints;
  final double caloriesBurned;
  final int challengesJoinedCount;
  final int coinsCollected;
}

class ActivityLogService {
  Future<void> insertLog({
    required String userId,
    required ActivityLogPayload payload,
    DateTime? createdAt,
  }) async {
    final createdAtValue = (createdAt ?? DateTime.now().toUtc()).toIso8601String();

    await supabase.from('user_activity_logs').insert({
      'user_id': userId,
      'steps': payload.steps,
      'energy_generated': payload.energyGenerated,
      'carbon_saved': payload.carbonSaved,
      'earned_points': payload.earnedPoints,
      'calories_burned': payload.caloriesBurned,
      'challenges_joined_count': payload.challengesJoinedCount,
      'coins_collected': payload.coinsCollected,
      'created_at': createdAtValue,
    });
  }
}