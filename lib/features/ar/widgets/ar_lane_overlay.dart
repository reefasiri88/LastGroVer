import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/ar_overlay_projection.dart';
import 'ar_perspective_route_painter.dart';

class ArLaneOverlay extends StatefulWidget {
  const ArLaneOverlay({
    super.key,
    required this.coinProjections,
    required this.cueProjections,
    required this.routeProgress,
  });

  final List<ArOverlayProjection> coinProjections;
  final List<ArOverlayProjection> cueProjections;
  final double routeProgress;

  @override
  State<ArLaneOverlay> createState() => _ArLaneOverlayState();
}

class _ArLaneOverlayState extends State<ArLaneOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final spinProgress = _animationController.value;

            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ArPerspectiveRoutePainter(
                      cueProjections: widget.cueProjections,
                      routeProgress: widget.routeProgress,
                      animationValue: spinProgress,
                    ),
                  ),
                ),
                ...widget.coinProjections.map(
                  (projection) => _ProjectedCoin(
                    projection: projection,
                    width: width,
                    height: height,
                    animationValue: spinProgress,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ProjectedCoin extends StatelessWidget {
  const _ProjectedCoin({
    required this.projection,
    required this.width,
    required this.height,
    required this.animationValue,
  });

  final ArOverlayProjection projection;
  final double width;
  final double height;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    final size = (projection.scale * 52).clamp(20.0, 76.0);
    final fontSize = size * 0.4;
    final phase = (animationValue * math.pi * 2) + (projection.depth * 5.4);
    final spinScaleX = math.cos(phase * 1.3).abs().clamp(0.22, 1.0);
    final bobOffset = math.sin(phase) * (4 + (projection.scale * 2.4));
    final shadowWidth = size * 0.7;
    final shadowHeight = size * 0.16;

    return Positioned(
      left: (projection.screenX * width) - (size / 2),
      top: (projection.screenY * height) - (size / 2) + bobOffset,
      child: Opacity(
        opacity: projection.opacity,
        child: SizedBox(
          width: size,
          height: size * 1.12,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: (size - shadowWidth) / 2,
                bottom: 0,
                child: Container(
                  width: shadowWidth,
                  height: shadowHeight,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF56CFFF).withValues(alpha: 0.12),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scaleByDouble(spinScaleX, 1.0, 1.0, 1.0),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFF1A4),
                          Color(0xFFF1BE35),
                          Color(0xFFD48909),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFFFFF6CC),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFAA6800).withValues(alpha: 0.28),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFE08A),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC17900),
                            fontSize: fontSize,
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
      ),
    );
  }
}