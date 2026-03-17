import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/animation.dart';

import '../models/ar_collectible.dart';
import '../models/ar_overlay_projection.dart';
import '../models/ar_question_trigger.dart';

class ArRouteLayout {
  static const double pathLengthMeters = 24.0;
  static const int initialSteps = 72;
  static const int initialVisibleCoinCount = 6;
  static const double initialCoinStop = 0.14;
  static const double coinSpacingProgress = 0.15;
  static const double coinCollectionProgressThreshold = 0.03;
  static const double cueLift = 0.018;
  static const double coinLift = 0.038;
  static const double visibleProgressWindow = 0.92;
  static const double cueSpacingProgress = 0.16;
  static const int visibleCueCount = 5;
  static const double questionTriggerStop = 0.69;
  static const int baseEnergyKwh = 0;

  static List<ArCollectible> buildCoins() {
    return List<ArCollectible>.generate(
      initialVisibleCoinCount,
      (index) => buildCoin(index + 1),
    );
  }

  static ArCollectible buildCoin(int index, {double? stop}) {
    return ArCollectible(
      id: 'coin-$index',
      stop: stop ?? coinStopForIndex(index),
      value: 1,
    );
  }

  static double coinStopForIndex(int index) {
    return initialCoinStop + ((index - 1) * coinSpacingProgress);
  }

  static ArQuestionTrigger buildQuestionTrigger() {
    return ArQuestionTrigger(
      id: 'question-1',
      stop: questionTriggerStop,
    );
  }

  static double clampProgress(double progress) {
    if (progress < 0) {
      return 0;
    }
    if (progress > 1) {
      return 1;
    }
    return progress;
  }

  static double clampVisibleDistance(double progressDistance) {
    if (progressDistance < 0) {
      return 0;
    }
    if (progressDistance > visibleProgressWindow) {
      return visibleProgressWindow;
    }
    return progressDistance;
  }

  static int stepsFromRemainingDistance(double remainingDistanceMeters) {
    return (initialSteps * (remainingDistanceMeters / pathLengthMeters))
        .clamp(0, initialSteps)
        .round();
  }

  static double metersFromProgress(double progress) {
    return progress * pathLengthMeters;
  }

  static int energyFromProgress({
    required int totalStepsTaken,
    required int collectedCoins,
    required double distanceMeters,
  }) {
    return baseEnergyKwh +
        (totalStepsTaken * 3) +
        (collectedCoins * 18) +
        distanceMeters.round();
  }

  static ArOverlayProjection? projectStop({
    required String id,
    required double stop,
    required double routeProgress,
    double lateralOffset = 0,
    double verticalLift = 0,
  }) {
    final distanceAhead = stop - routeProgress;
    if (distanceAhead < -coinCollectionProgressThreshold) {
      return null;
    }

    final normalizedDistance =
        (clampVisibleDistance(distanceAhead) / visibleProgressWindow)
            .clamp(0.0, 1.0);
    final perspective = 1 - normalizedDistance;
    final eased = Curves.easeInOutCubic.transform(perspective);
    final laneHalfWidth = lerpDouble(0.03, 0.17, eased)!;
    final screenY = lerpDouble(0.34, 0.85, math.pow(eased, 1.08).toDouble())! -
        verticalLift;
    final screenX = 0.5 + (lateralOffset * laneHalfWidth);
    final scale = lerpDouble(0.34, 1.18, eased)!;
    final opacity = lerpDouble(0.22, 1.0, eased)!;

    return ArOverlayProjection(
      id: id,
      screenX: screenX,
      screenY: screenY,
      scale: scale,
      opacity: opacity,
      depth: eased,
    );
  }
}