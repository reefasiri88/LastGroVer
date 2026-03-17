import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'ar_glass_panel.dart';

class ArRewardOverlay extends StatefulWidget {
  const ArRewardOverlay({
    super.key,
    required this.onDismiss,
  });

  final VoidCallback onDismiss;

  @override
  State<ArRewardOverlay> createState() => _ArRewardOverlayState();
}

class _ArRewardOverlayState extends State<ArRewardOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.22),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: _RewardConfetti(animation: _fadeAnimation),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: ArGlassPanel(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
                      radius: 26,
                      backgroundColor: const Color(0x85524B46),
                      borderColor: const Color(0xFF8647FF),
                      blurSigma: 20,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: const Text(
                          'Correct! You earned +2 SAR Energy\nCoins.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardConfetti extends StatelessWidget {
  const _RewardConfetti({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const specs = [
      _ArcSpec(28, 114, 0.0, Color(0xFFF2BE4B), 0.5),
      _ArcSpec(92, 76, 0.9, Color(0xFFA87BF3), 0.6),
      _ArcSpec(182, 104, 1.6, Color(0xFF7E42E8), 0.5),
      _ArcSpec(312, 78, -0.7, Color(0xFFA87BF3), 0.45),
      _ArcSpec(330, 214, 0.2, Color(0xFF7E42E8), 0.4),
      _ArcSpec(24, 260, -0.5, Color(0xFFF2BE4B), 0.45),
      _ArcSpec(340, 324, -0.2, Color(0xFFF2BE4B), 0.55),
      _ArcSpec(70, 370, 1.1, Color(0xFF7E42E8), 0.55),
      _ArcSpec(352, 472, 0.7, Color(0xFFA87BF3), 0.45),
      _ArcSpec(104, 520, -1.0, Color(0xFFF2BE4B), 0.45),
      _ArcSpec(12, 610, 0.5, Color(0xFF7E42E8), 0.35),
      _ArcSpec(344, 708, 1.0, Color(0xFFF2BE4B), 0.58),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: specs.map((spec) {
            final drift = (1 - animation.value) * 24;
            return Positioned(
              left: spec.left,
              top: spec.top + drift,
              child: Opacity(
                opacity: animation.value,
                child: Transform.rotate(
                  angle: spec.rotation,
                  child: CustomPaint(
                    size: Size(constraints.maxWidth * 0.14, constraints.maxWidth * 0.14),
                    painter: _ArcPainter(spec.color.withValues(alpha: spec.opacity)),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.12;

    final rect = Offset.zero & size;
    canvas.drawArc(rect, -math.pi * 0.2, math.pi * 0.9, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _ArcSpec {
  const _ArcSpec(this.left, this.top, this.rotation, this.color, this.opacity);

  final double left;
  final double top;
  final double rotation;
  final Color color;
  final double opacity;
}