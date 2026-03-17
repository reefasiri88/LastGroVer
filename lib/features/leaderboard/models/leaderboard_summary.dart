class LeaderboardSummary {
  const LeaderboardSummary({
    required this.userId,
    required this.displayName,
    required this.rank,
    required this.totalPoints,
    required this.totalEnergyKwh,
    required this.totalCarbonAvoidedKg,
    required this.totalSteps,
    required this.totalCoins,
    required this.totalCaloriesBurned,
    required this.isCurrentUser,
  });

  final String userId;
  final String displayName;
  final int rank;
  final int totalPoints;
  final double totalEnergyKwh;
  final double totalCarbonAvoidedKg;
  final int totalSteps;
  final int totalCoins;
  final double totalCaloriesBurned;
  final bool isCurrentUser;
}