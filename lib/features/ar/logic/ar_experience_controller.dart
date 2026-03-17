import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../models/ar_collectible.dart';
import '../models/ar_overlay_projection.dart';
import '../models/ar_overlay_mode.dart';
import '../models/ar_question_trigger.dart';
import '../../home/data/sustainability_calculation_service.dart';
import '../services/ar_session_service.dart';
import 'ar_demo_progression_controller.dart';
import '../services/ar_route_layout.dart';

class ArExperienceController extends ChangeNotifier {
  ArExperienceController({ArSessionService? arSessionService})
      : _arSessionService = arSessionService ?? ArSessionService() {
    _progressionController = ArDemoProgressionController(
      onProgressStep: _applyProgressSteps,
      onModeChanged: _handleProgressionModeChanged,
    );
  }

      final SustainabilityCalculationService _calculationService =
          const SustainabilityCalculationService();
  final ArSessionService _arSessionService;
  late final ArDemoProgressionController _progressionController;
  CameraController? _cameraController;
  bool _isDisposed = false;

  bool _hasStarted = false;
  bool _isInitializingCamera = false;
  bool _isCameraReady = false;
  ArOverlayMode _overlayMode = ArOverlayMode.none;
  String? _errorMessage;
  double _routeProgress = 0;
  int _distanceMeters = 0;
  int _stepsTotal = 0;
  double _energyTotal = ArRouteLayout.baseEnergyKwh.toDouble();
  int _totalStepsTaken = 0;
  int _collectedCoinCount = 0;
  int _nextCoinSequence = ArRouteLayout.initialVisibleCoinCount + 1;
  String _guidanceLabel = 'Ready to start';
  List<ArCollectible> _coins = ArRouteLayout.buildCoins();
  ArQuestionTrigger? _questionTrigger = ArRouteLayout.buildQuestionTrigger();
  List<ArOverlayProjection> _coinProjections = const [];
  List<ArOverlayProjection> _cueProjections = const [];

  int _coinTotal = 0;

  CameraController? get cameraController => _cameraController;
  bool get hasStarted => _hasStarted;
  bool get isPlacingPath => _isInitializingCamera;
  bool get isPathPlaced => _isCameraReady;
  ArOverlayMode get overlayMode => _overlayMode;
  String? get errorMessage => _errorMessage;
  int get coinTotal => _coinTotal;
  int get stepsTotal => _stepsTotal;
  double get energyTotal => _energyTotal;
  int get distanceMeters => _distanceMeters;
  String get guidanceLabel => _guidanceLabel;
  double get routeProgress => _routeProgress;
  bool get hasPendingQuestion => _questionTrigger != null && !_questionTrigger!.isAnswered;
  bool get canOpenQuestion => _questionTrigger != null && !_questionTrigger!.isAnswered;
  bool get isRouteComplete => _routeProgress >= 0.98;
  List<ArOverlayProjection> get coinProjections => _coinProjections;
  List<ArOverlayProjection> get cueProjections => _cueProjections;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[AR] $message');
    }
  }

  String get placementMessage {
    if (_errorMessage != null) {
      return _errorMessage!;
    }
    if (!_hasStarted) {
      return 'Review the route and start when you are ready.';
    }
    if (_isCameraReady) {
      if (_progressionController.isUsingFallback) {
        return 'Fallback step mode is active while the route keeps moving forward.';
      }
      return 'Walk forward and collect rewards.';
    }
    if (_isInitializingCamera) {
      return 'Opening live camera preview...';
    }
    return 'Camera preview unavailable.';
  }

  Future<void> startExperience() async {
    if (_hasStarted && (_isInitializingCamera || _isCameraReady)) {
      return;
    }

    _hasStarted = true;
    _isInitializingCamera = true;
    _errorMessage = null;
    _updateGuidanceLabel();
    _safeNotify();
    await _arSessionService.startSession();
    await _initializeDemo();
  }

  Future<void> returnToStartScreen() async {
    if (!_hasStarted && !_isCameraReady && !_isInitializingCamera) {
      return;
    }

    final sessionSummary = _buildSessionSummary();

    _overlayMode = ArOverlayMode.none;
    _errorMessage = null;
    _hasStarted = false;
    _isInitializingCamera = false;
    _isCameraReady = false;
    await _progressionController.stop();
    await _arSessionService.endSession(summary: sessionSummary);

    final controller = _cameraController;
    _cameraController = null;
    await controller?.dispose();

    _resetRouteState(resetCoinTotal: true);
    _updateGuidanceLabel();
    _safeNotify();
  }

  Future<void> _initializeDemo() async {
    _errorMessage = null;

    try {
      final cameras = await availableCameras();
      CameraDescription? selectedCamera;
      for (final camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          selectedCamera = camera;
          break;
        }
      }
      selectedCamera ??= cameras.isNotEmpty ? cameras.first : null;

      if (selectedCamera == null) {
        _errorMessage = 'No camera was found on this device.';
        _isInitializingCamera = false;
        _isCameraReady = false;
        _updateGuidanceLabel();
        _safeNotify();
        return;
      }

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);

      if (_isDisposed) {
        await controller.dispose();
        return;
      }

      _cameraController = controller;
      _isInitializingCamera = false;
      _isCameraReady = true;
      _resetRouteState(resetCoinTotal: false);
      _updateGuidanceLabel();
      _rebuildOverlayProjections();
      _safeNotify();
      await _progressionController.start();
      _log('Live camera preview ready. True AR placement is disabled.');
    } catch (error, stackTrace) {
      _log('Camera initialization failed: $error');
      _log(stackTrace.toString());
      _errorMessage = 'Allow camera access to run the demo preview.';
      _isInitializingCamera = false;
      _isCameraReady = false;
      _updateGuidanceLabel();
      _safeNotify();
    }
  }

  Future<void> resetPlacement() async {
    if (!_isCameraReady) {
      return;
    }

    _progressionController.resetSession();
    _resetRouteState(resetCoinTotal: false);
    _updateGuidanceLabel();
    _rebuildOverlayProjections();
    _safeNotify();
  }

  void openQuestionOverlay() {
    if (!_isCameraReady ||
        _overlayMode != ArOverlayMode.none ||
        _questionTrigger == null ||
        _questionTrigger!.isAnswered) {
      return;
    }
    _questionTrigger?.isTriggered = true;
    _overlayMode = ArOverlayMode.question;
    _updateGuidanceLabel();
    _log('Question modal opened from HUD button.');
    _safeNotify();
  }

  void dismissOverlay() {
    if (_overlayMode == ArOverlayMode.none) {
      return;
    }
    _overlayMode = ArOverlayMode.none;
    _updateGuidanceLabel();
    _safeNotify();
  }

  void submitQuestionAnswer({required bool isCorrect}) {
    if (_questionTrigger == null || _questionTrigger!.isAnswered) {
      return;
    }

    _questionTrigger!
      ..isAnswered = true
      ..isTriggered = true;

    if (isCorrect) {
      _coinTotal += 2;
      _overlayMode = ArOverlayMode.reward;
      _updateEnergyTotal();
      _log('Question answered correctly. Coin total is now $_coinTotal.');
    } else {
      _overlayMode = ArOverlayMode.none;
      _log('Question answered incorrectly. No reward applied.');
    }
    _updateGuidanceLabel();
    _safeNotify();
  }

  void registerFallbackStep() {
    if (!_isCameraReady || _overlayMode != ArOverlayMode.none) {
      return;
    }
    _progressionController.registerFallbackStep();
  }

  void _applyProgressSteps(int stepDelta) {
    if (!_isCameraReady || stepDelta <= 0 || _overlayMode == ArOverlayMode.question) {
      return;
    }

    _totalStepsTaken += stepDelta;
    _routeProgress += (stepDelta / ArRouteLayout.initialSteps);
    _collectReachedCoins();
    _ensureFutureCoins();
    _updateProgressMetrics();
    _rebuildOverlayProjections();
    _updateGuidanceLabel();
    _safeNotify();
  }

  void _collectReachedCoins() {
    while (true) {
      ArCollectible? nextCoin;
      for (final coin in _coins) {
        if (!coin.collected) {
          nextCoin = coin;
          break;
        }
      }

      if (nextCoin == null ||
          _routeProgress + ArRouteLayout.coinCollectionProgressThreshold <
              nextCoin.stop) {
        return;
      }

      nextCoin.collected = true;
      _coinTotal += nextCoin.value;
      _collectedCoinCount += 1;
      _updateEnergyTotal();
      _log('Collected ${nextCoin.id}. Coin total=$_coinTotal.');
    }
  }

  void _ensureFutureCoins() {
    while (_coins.where((coin) => !coin.collected).length < ArRouteLayout.initialVisibleCoinCount) {
      final lastStop = _coins.isEmpty
          ? ArRouteLayout.initialCoinStop
          : _coins.last.stop + ArRouteLayout.coinSpacingProgress;
      _coins.add(
        ArRouteLayout.buildCoin(
          _nextCoinSequence,
          stop: lastStop,
        ),
      );
      _nextCoinSequence += 1;
    }
  }

  void _updateProgressMetrics() {
    _distanceMeters = _collectedCoinCount ~/ 12;
    _stepsTotal = _totalStepsTaken;
    _updateEnergyTotal();
  }

  void _updateEnergyTotal() {
    _energyTotal = _calculationService
        .calculate(
          steps: _stepsTotal,
          coinsCollected: _coinTotal,
        )
        .totalEnergyKwh;
  }

  ArCollectible? get _nearestUpcomingCoin {
    for (final coin in _coins) {
      if (!coin.collected) {
        return coin;
      }
    }
    return null;
  }

  void _rebuildOverlayProjections() {
    final nextCoins = <ArOverlayProjection>[];
    for (final coin in _coins.where((entry) => !entry.collected)) {
      final projection = ArRouteLayout.projectStop(
        id: coin.id,
        stop: coin.stop,
        routeProgress: _routeProgress,
        lateralOffset: coin.lateralOffset,
        verticalLift: ArRouteLayout.coinLift,
      );
      if (projection != null) {
        nextCoins.add(projection);
      }
    }

    final nextCues = <ArOverlayProjection>[];
    for (var index = 1; index <= ArRouteLayout.visibleCueCount; index++) {
      final stop = _routeProgress + (index * ArRouteLayout.cueSpacingProgress);
      final projection = ArRouteLayout.projectStop(
        id: 'cue-$stop',
        stop: stop,
        routeProgress: _routeProgress,
        verticalLift: ArRouteLayout.cueLift,
      );
      if (projection != null) {
        nextCues.add(projection);
      }
    }

    nextCoins.sort((left, right) => left.depth.compareTo(right.depth));
    nextCues.sort((left, right) => left.depth.compareTo(right.depth));
    _coinProjections = nextCoins;
    _cueProjections = nextCues;
  }

  void _handleProgressionModeChanged() {
    _updateGuidanceLabel();
    _safeNotify();
  }

  void _resetRouteState({required bool resetCoinTotal}) {
    if (resetCoinTotal) {
      _coinTotal = 0;
    }
    _overlayMode = ArOverlayMode.none;
    _routeProgress = 0;
    _distanceMeters = 0;
    _stepsTotal = 0;
    _energyTotal = ArRouteLayout.baseEnergyKwh.toDouble();
    _totalStepsTaken = 0;
    _collectedCoinCount = 0;
    _nextCoinSequence = ArRouteLayout.initialVisibleCoinCount + 1;
    _coins = ArRouteLayout.buildCoins();
    _questionTrigger = ArRouteLayout.buildQuestionTrigger();
    _coinProjections = const [];
    _cueProjections = const [];
  }

  void _updateGuidanceLabel() {
    if (!_isCameraReady) {
      _guidanceLabel = _isInitializingCamera
          ? 'Opening camera'
          : _hasStarted
              ? 'Camera unavailable'
              : 'Start the route';
      return;
    }

    if (_overlayMode == ArOverlayMode.question) {
      _guidanceLabel = 'Answer the question';
      return;
    }

    if (_overlayMode == ArOverlayMode.reward) {
      _guidanceLabel = 'Reward unlocked';
      return;
    }

    if (hasPendingQuestion) {
      _guidanceLabel = 'Question available';
      return;
    }

    if (_progressionController.isUsingFallback) {
      _guidanceLabel = 'Fallback step mode active';
      return;
    }

    final nextCoin = _nearestUpcomingCoin;
    if (nextCoin != null &&
        (nextCoin.stop - _routeProgress) <=
            ArRouteLayout.coinCollectionProgressThreshold) {
      _guidanceLabel = 'Coin within reach';
      return;
    }

    if (_routeProgress < 0.18) {
      _guidanceLabel = 'Walk forward';
      return;
    }

    _guidanceLabel = 'Collect rewards';
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  ArSessionSummary _buildSessionSummary() {
    return ArSessionSummary(
      steps: _stepsTotal,
      coinsCollected: _coinTotal,
      distanceMeters: _distanceMeters,
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_hasStarted || _isCameraReady || _isInitializingCamera) {
      unawaited(_arSessionService.endSession(summary: _buildSessionSummary()));
    }
    _progressionController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }
}