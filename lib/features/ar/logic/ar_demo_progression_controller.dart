import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';

enum ArProgressionMode {
  stepSensor,
  fallbackTap,
}

class ArDemoProgressionController {
  ArDemoProgressionController({
    required this.onProgressStep,
    required this.onModeChanged,
  });

  final void Function(int stepDelta) onProgressStep;
  final VoidCallback onModeChanged;

  StreamSubscription<StepCount>? _stepSubscription;
  Timer? _sensorGraceTimer;
  int? _sensorBaseline;
  int? _latestAbsoluteStepCount;
  int _emittedRelativeSteps = 0;
  bool _hasReceivedSensorEvent = false;
  ArProgressionMode _mode = ArProgressionMode.stepSensor;

  bool get isUsingFallback => _mode == ArProgressionMode.fallbackTap;

  Future<void> start() async {
    await _stepSubscription?.cancel();
    _stepSubscription = null;
    _sensorGraceTimer?.cancel();
    _hasReceivedSensorEvent = false;
    _sensorGraceTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasReceivedSensorEvent) {
        _setMode(ArProgressionMode.fallbackTap);
      }
    });

    try {
      _stepSubscription = Pedometer.stepCountStream.listen(
        _handleStepCount,
        onError: (_) {
          _setMode(ArProgressionMode.fallbackTap);
        },
      );
    } catch (_) {
      _setMode(ArProgressionMode.fallbackTap);
    }
  }

  void resetSession() {
    if (_latestAbsoluteStepCount != null) {
      _sensorBaseline = _latestAbsoluteStepCount;
      _emittedRelativeSteps = 0;
    }
  }

  void registerFallbackStep() {
    if (!isUsingFallback) {
      return;
    }
    onProgressStep(1);
  }

  Future<void> stop() async {
    _sensorGraceTimer?.cancel();
    _sensorGraceTimer = null;
    await _stepSubscription?.cancel();
    _stepSubscription = null;
    _sensorBaseline = null;
    _latestAbsoluteStepCount = null;
    _emittedRelativeSteps = 0;
    _hasReceivedSensorEvent = false;
    _setMode(ArProgressionMode.stepSensor);
  }

  void _handleStepCount(StepCount event) {
    _hasReceivedSensorEvent = true;
    _sensorGraceTimer?.cancel();
    _latestAbsoluteStepCount = event.steps;
    _setMode(ArProgressionMode.stepSensor);

    _sensorBaseline ??= event.steps;
    final relativeSteps = event.steps - _sensorBaseline!;
    final delta = relativeSteps - _emittedRelativeSteps;
    if (delta <= 0) {
      return;
    }

    _emittedRelativeSteps = relativeSteps;
    onProgressStep(delta);
  }

  void _setMode(ArProgressionMode nextMode) {
    if (_mode == nextMode) {
      return;
    }
    _mode = nextMode;
    onModeChanged();
  }

  void dispose() {
    _sensorGraceTimer?.cancel();
    _stepSubscription?.cancel();
  }
}