import 'dart:ui';

import 'package:flutter/material.dart';

class ArGlassPanel extends StatelessWidget {
  const ArGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.radius = 12,
    this.backgroundColor = const Color(0x80000000),
    this.borderColor = const Color(0x26FFFFFF),
    this.blurSigma = 8,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color backgroundColor;
  final Color borderColor;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

class ArGlassIconButton extends StatelessWidget {
  const ArGlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ArGlassPanel(
        padding: EdgeInsets.all((size - 24) / 2),
        radius: 12,
        blurSigma: 2,
        backgroundColor: const Color(0x80000000),
        child: Icon(
          icon,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}