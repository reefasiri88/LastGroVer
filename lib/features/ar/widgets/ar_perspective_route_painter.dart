import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/ar_overlay_projection.dart';

class ArPerspectiveRoutePainter extends CustomPainter {
  const ArPerspectiveRoutePainter({
    required this.cueProjections,
    required this.routeProgress,
    required this.animationValue,
  });

  final List<ArOverlayProjection> cueProjections;
  final double routeProgress;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final horizonCenter = Offset(size.width * 0.5, size.height * 0.33);
    final farLeft = Offset(size.width * 0.468, size.height * 0.44);
    final farRight = Offset(size.width * 0.532, size.height * 0.44);
    final nearLeft = Offset(size.width * 0.34, size.height * 0.88);
    final nearRight = Offset(size.width * 0.66, size.height * 0.88);

    final lanePath = Path()
      ..moveTo(farLeft.dx, farLeft.dy)
      ..lineTo(farRight.dx, farRight.dy)
      ..lineTo(nearRight.dx, nearRight.dy)
      ..lineTo(nearLeft.dx, nearLeft.dy)
      ..close();

    final laneRect = Rect.fromPoints(horizonCenter, Offset(size.width, nearLeft.dy));
    final glowPulse = 0.72 + (math.sin(animationValue * math.pi * 2) * 0.08);

    final laneShadowPaint = Paint()
      ..color = const Color(0xFF9D5CFF).withValues(alpha: 0.1 * glowPulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
    canvas.drawPath(lanePath.shift(const Offset(0, 10)), laneShadowPaint);

    final laneFillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0x10965CFF),
          const Color(0x508048F2),
          const Color(0xA56D2DDE),
        ],
      ).createShader(laneRect);
    canvas.drawPath(lanePath, laneFillPaint);

    final edgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD8C4FF),
          const Color(0xFFB47CFF),
        ],
      ).createShader(laneRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawLine(farLeft, nearLeft, edgePaint);
    canvas.drawLine(farRight, nearRight, edgePaint);

    final centerLinePaint = Paint()
      ..color = const Color(0xFFF6EFFF).withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    _drawMovingArrows(
      canvas,
      size,
      centerLinePaint,
      startY: size.height * 0.46,
      endY: size.height * 0.84,
    );

    for (final cue in cueProjections) {
      final cueY = cue.screenY * size.height;
      final cueHalfWidth = lerpDouble(size.width * 0.024, size.width * 0.11, cue.scale / 1.18)!
          .clamp(size.width * 0.024, size.width * 0.11);
      final cueAlpha = (cue.opacity * (0.7 + (math.sin((animationValue * math.pi * 2) + cue.depth) * 0.2)))
          .clamp(0.18, 1.0);

      final cuePaint = Paint()
        ..color = const Color(0xFFF2DBFF).withValues(alpha: cueAlpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset((cue.screenX * size.width) - cueHalfWidth, cueY),
        Offset((cue.screenX * size.width) + cueHalfWidth, cueY),
        cuePaint,
      );
    }

    final horizonPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xAACFADFF),
          const Color(0x006B2DDE),
        ],
      ).createShader(Rect.fromCircle(center: horizonCenter, radius: size.width * 0.16));
    canvas.drawCircle(horizonCenter, size.width * 0.12, horizonPaint);

    final progressGlowPaint = Paint()
      ..color = const Color(0xFFC78EFF).withValues(alpha: (0.18 + ((routeProgress % 1) * 0.14)).clamp(0.18, 0.32))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.87),
        width: size.width * 0.34,
        height: size.height * 0.04,
      ),
      progressGlowPaint,
    );
  }

  void _drawMovingArrows(
    Canvas canvas,
    Size size,
    Paint paint, {
    required double startY,
    required double endY,
  }) {
    const arrowCount = 5;
    for (var index = 0; index < arrowCount; index++) {
      final progress = (index / arrowCount + animationValue) % 1.0;
      final y = lerpDouble(endY, startY, progress)!;
      final scale = lerpDouble(1.0, 0.42, progress)!;
      final halfWidth = size.width * 0.02 * scale;
      final arrowHeight = size.height * 0.022 * scale;

      final path = Path()
        ..moveTo((size.width * 0.5) - halfWidth, y + arrowHeight)
        ..lineTo(size.width * 0.5, y)
        ..lineTo((size.width * 0.5) + halfWidth, y + arrowHeight);
      canvas.drawPath(path, paint);

      final glowPaint = Paint()
        ..color = const Color(0xFFDAB0FF).withValues(alpha: 0.18 * scale)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6 * scale
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawPath(path, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ArPerspectiveRoutePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.routeProgress != routeProgress ||
        oldDelegate.cueProjections != cueProjections;
  }
}