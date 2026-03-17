class SustainabilityFormulaConstants {
  const SustainabilityFormulaConstants._();

  // Centralized deterministic formulas for all sustainability metrics.
  static const double piezoWhPerStep = 0.08;
  static const double solarWhPerSession = 0;
  static const double gridEmissionFactorKgPerKwh = 0.43;
  static const double caloriesPerStep = 0.04;
  static const int stepsPerPoint = 20;
  static const int pointsPerCoin = 5;
  static const double pointsPerKwh = 120;
}

class CalculatedActivityMetrics {
  const CalculatedActivityMetrics({
    required this.steps,
    required this.coinsCollected,
    required this.piezoEnergyWh,
    required this.solarEnergyWh,
    required this.totalEnergyKwh,
    required this.carbonAvoidedKg,
    required this.caloriesBurned,
    required this.earnedPoints,
  });

  final int steps;
  final int coinsCollected;
  final double piezoEnergyWh;
  final double solarEnergyWh;
  final double totalEnergyKwh;
  final double carbonAvoidedKg;
  final double caloriesBurned;
  final int earnedPoints;
}

class SustainabilityCalculationService {
  const SustainabilityCalculationService();

  CalculatedActivityMetrics calculate({
    required int steps,
    required int coinsCollected,
    double solarEnergyWh = SustainabilityFormulaConstants.solarWhPerSession,
  }) {
    final piezoEnergyWh = steps * SustainabilityFormulaConstants.piezoWhPerStep;
    final totalEnergyKwh = (piezoEnergyWh + solarEnergyWh) / 1000;
    final carbonAvoidedKg =
        totalEnergyKwh * SustainabilityFormulaConstants.gridEmissionFactorKgPerKwh;
    final caloriesBurned =
        steps * SustainabilityFormulaConstants.caloriesPerStep;
    final pointsFromSteps = steps ~/ SustainabilityFormulaConstants.stepsPerPoint;
    final pointsFromEnergy =
        (totalEnergyKwh * SustainabilityFormulaConstants.pointsPerKwh).round();
    final pointsFromCoins =
        coinsCollected * SustainabilityFormulaConstants.pointsPerCoin;

    return CalculatedActivityMetrics(
      steps: steps,
      coinsCollected: coinsCollected,
      piezoEnergyWh: piezoEnergyWh,
      solarEnergyWh: solarEnergyWh,
      totalEnergyKwh: totalEnergyKwh,
      carbonAvoidedKg: carbonAvoidedKg,
      caloriesBurned: caloriesBurned,
      earnedPoints: pointsFromSteps + pointsFromEnergy + pointsFromCoins,
    );
  }

  CalculatedActivityMetrics fromActivityLog(Map<String, dynamic> row) {
    final steps = _toInt(row['steps']);
    final coinsCollected = _toInt(row['coins_collected']);
    if (steps > 0 || coinsCollected > 0) {
      return calculate(
        steps: steps,
        coinsCollected: coinsCollected,
      );
    }

    final energyGenerated = _toDouble(row['energy_generated']);
    final carbonSaved = _toDouble(row['carbon_saved']);
    final caloriesBurned = _toDouble(row['calories_burned']);
    final earnedPoints = _toInt(row['earned_points']);

    return CalculatedActivityMetrics(
      steps: steps,
      coinsCollected: coinsCollected,
      piezoEnergyWh: energyGenerated * 1000,
      solarEnergyWh: 0,
      totalEnergyKwh: energyGenerated,
      carbonAvoidedKg: carbonSaved,
      caloriesBurned: caloriesBurned,
      earnedPoints: earnedPoints,
    );
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

  double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}