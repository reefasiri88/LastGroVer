import 'package:flutter/material.dart';

import '../logic/ar_experience_controller.dart';
import '../models/ar_overlay_mode.dart';
import '../widgets/ar_camera_preview.dart';
import '../widgets/ar_glass_panel.dart';
import '../widgets/ar_lane_overlay.dart';
import '../widgets/ar_question_overlay.dart';
import '../widgets/ar_reward_overlay.dart';

class ArScreen extends StatefulWidget {
  const ArScreen({
    super.key,
    this.onExit,
  });

  final VoidCallback? onExit;

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  late final ArExperienceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ArExperienceController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_controller.hasStarted) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: _ArStartScreen(
              controller: _controller,
              onStart: _controller.startExperience,
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _controller.registerFallbackStep,
                  child: ArCameraPreview(
                    controller: _controller.cameraController,
                    isReady: _controller.isPathPlaced,
                    errorMessage: _controller.errorMessage,
                  ),
                ),
              ),
              if (_controller.isPathPlaced)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ArLaneOverlay(
                      coinProjections: _controller.coinProjections,
                      cueProjections: _controller.cueProjections,
                      routeProgress: _controller.routeProgress,
                    ),
                  ),
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _LocationChip(),
                              const SizedBox(height: 10),
                              Opacity(
                                opacity: _controller.isPathPlaced ? 1 : 0.6,
                                child: ArGlassIconButton(
                                  icon: Icons.question_mark_rounded,
                                  onPressed: _controller.isPathPlaced
                                      ? _controller.openQuestionOverlay
                                      : () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: _StatsPanel(controller: _controller),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ArGlassIconButton(
                            icon: Icons.close_rounded,
                            onPressed: () => _handleExit(context),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (!_controller.isPathPlaced)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _SurfacePromptCard(
                            controller: _controller,
                            onRetry: _controller.retryCameraInitialization,
                            onExit: () => _handleExit(context),
                          ),
                        ),
                      _DistancePanel(controller: _controller),
                    ],
                  ),
                ),
              ),
              if (_controller.overlayMode == ArOverlayMode.question)
                ArQuestionOverlay(
                  onCorrectChoice: () {
                    _controller.submitQuestionAnswer(isCorrect: true);
                  },
                  onWrongChoice: () {
                    _controller.submitQuestionAnswer(isCorrect: false);
                  },
                ),
              if (_controller.overlayMode == ArOverlayMode.reward)
                ArRewardOverlay(
                  onDismiss: _controller.dismissOverlay,
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleExit(BuildContext context) async {
    if (_controller.hasStarted) {
      await _controller.returnToStartScreen();
      return;
    }

    final onExit = widget.onExit;
    if (onExit != null) {
      onExit();
      return;
    }
    Navigator.of(context).maybePop();
  }
}

class _ArStartScreen extends StatelessWidget {
  const _ArStartScreen({
    required this.controller,
    required this.onStart,
  });

  final ArExperienceController controller;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF141019),
                Color(0xFF110B18),
                Color(0xFF09070E),
              ],
            ),
          ),
        ),
        Positioned(
          left: -40,
          top: 120,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0x668947FF),
                  Color(0x008947FF),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -60,
          bottom: 100,
          child: Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0x44F6B8FF),
                  Color(0x00F6B8FF),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                ArGlassPanel(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  radius: 24,
                  blurSigma: 14,
                  backgroundColor: const Color(0x8A15111D),
                  borderColor: const Color(0x52FFFFFF),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'AR Route Demo',
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.placementMessage,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const _StartModeRow(
                        icon: Icons.camera_alt_rounded,
                        label: 'Live camera preview with route overlay',
                      ),
                      const SizedBox(height: 12),
                      const _StartModeRow(
                        icon: Icons.monetization_on_rounded,
                        label: 'Coins collect automatically when you get close',
                      ),
                      const SizedBox(height: 12),
                      const _StartModeRow(
                        icon: Icons.directions_walk_rounded,
                        label: 'Walk to progress, with fallback step mode available if motion sensing is unavailable',
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onStart,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF8A47FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Start Route'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StartModeRow extends StatelessWidget {
  const _StartModeRow({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0x2B9B6DFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.86),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip();

  @override
  Widget build(BuildContext context) {
    return ArGlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      radius: 12,
      blurSigma: 2,
      backgroundColor: const Color(0x80000000),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 4),
          Text(
            'Sedra',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.controller});

  final ArExperienceController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 186,
      child: ArGlassPanel(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        radius: 12,
        blurSigma: 2,
        backgroundColor: const Color(0x80000000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.monetization_on_rounded,
                  color: Color(0xFFF1C94F),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${controller.coinTotal} SAR coins',
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.18),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${controller.energyTotal.toStringAsFixed(2)} kWh',
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '|',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.36),
                    ),
                  ),
                ),
                const Icon(
                  Icons.directions_walk_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${controller.stepsTotal} steps',
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SurfacePromptCard extends StatelessWidget {
  const _SurfacePromptCard({
    required this.controller,
    required this.onRetry,
    required this.onExit,
  });

  final ArExperienceController controller;
  final Future<void> Function() onRetry;
  final Future<void> Function() onExit;

  @override
  Widget build(BuildContext context) {
    final isWebFallback = controller.isWebCameraFallback;
    final canRetry = controller.hasCameraFailure;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: ArGlassPanel(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          radius: 18,
          backgroundColor: const Color(0xA1333138),
          borderColor: const Color(0x4CFFFFFF),
          blurSigma: 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                controller.isPlacingPath
                    ? Icons.camera_alt_rounded
                    : Icons.warning_amber_rounded,
                size: 28,
                color: const Color(0xFFD6C3FF),
              ),
              const SizedBox(height: 10),
              Text(
                controller.placementMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                controller.isPlacingPath
                    ? 'The live camera feed is initializing'
                    : isWebFallback
                        ? 'This GitHub Pages web build can fall back when Safari cannot keep the camera stream active. The full AR demo is more reliable in the mobile app build.'
                        : 'Camera access is required after you press Start',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
                textAlign: TextAlign.center,
              ),
              if (canRetry) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: onRetry,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF8A47FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onExit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DistancePanel extends StatelessWidget {
  const _DistancePanel({required this.controller});

  final ArExperienceController controller;

  @override
  Widget build(BuildContext context) {
    return ArGlassPanel(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      radius: 12,
      backgroundColor: const Color(0x99515151),
      borderColor: const Color(0x4CFFFFFF),
      blurSigma: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0x84D4BBFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_walk_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${controller.distanceMeters} meters',
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              controller.guidanceLabel,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}