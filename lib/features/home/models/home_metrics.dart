class HomeMetrics {
  const HomeMetrics({
    required this.userName,
    required this.userInitial,
    required this.energyGeneratedKwh,
    required this.carbonAvoidedKg,
    required this.caloriesBurned,
    required this.earnedPoints,
    required this.leaderboardRank,
    required this.recommendationLines,
    required this.todayDate,
    required this.todayTimeLabel,
    required this.todayDurationSeconds,
    required this.todayPoints,
    required this.dailyPointsGoal,
    required this.todayEnergyKwh,
    required this.todayCaloriesBurned,
    required this.weeklyAverageEnergyKwh,
    required this.recentAverageCaloriesBurned,
    required this.totalSteps,
    required this.totalCoins,
    required this.pointsToNextRank,
  });

  const HomeMetrics.empty()
      : userName = 'Welcome back',
        userInitial = 'G',
        energyGeneratedKwh = 0,
        carbonAvoidedKg = 0,
        caloriesBurned = 0,
        earnedPoints = 0,
        leaderboardRank = null,
        recommendationLines = const [
          'Complete an AR route to start building your sustainability profile.',
        ],
        todayDate = null,
        todayTimeLabel = '',
        todayDurationSeconds = 0,
        todayPoints = 0,
        dailyPointsGoal = 500,
        todayEnergyKwh = 0,
        todayCaloriesBurned = 0,
        weeklyAverageEnergyKwh = 0,
        recentAverageCaloriesBurned = 0,
        totalSteps = 0,
        totalCoins = 0,
        pointsToNextRank = null;

  final String userName;
  final String userInitial;
  final double energyGeneratedKwh;
  final double carbonAvoidedKg;
  final double caloriesBurned;
  final int earnedPoints;
  final int? leaderboardRank;
  final List<String> recommendationLines;
  final DateTime? todayDate;
  final String todayTimeLabel;
  final int todayDurationSeconds;
  final int todayPoints;
  final int dailyPointsGoal;
  final double todayEnergyKwh;
  final double todayCaloriesBurned;
  final double weeklyAverageEnergyKwh;
  final double recentAverageCaloriesBurned;
  final int totalSteps;
  final int totalCoins;
  final int? pointsToNextRank;

  bool get hasActivity =>
      totalSteps > 0 || totalCoins > 0 || earnedPoints > 0 || energyGeneratedKwh > 0;

  String get todayDateLabel {
    final date = todayDate ?? DateTime.now();
    return '${date.day} ${_monthLabels[date.month - 1]}';
  }

  String get todayDurationLabel {
    final hours = (todayDurationSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((todayDurationSeconds % 3600) ~/ 60)
        .toString()
        .padLeft(2, '0');
    final seconds = (todayDurationSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  static const List<String> _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}