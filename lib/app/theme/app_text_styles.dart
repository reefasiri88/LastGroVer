import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const body = TextStyle(
    fontFamily: 'Alexandria',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 23.5 / 14,
    letterSpacing: -0.5,
    color: AppColors.textSecondary,
  );

  static const title = TextStyle(
    fontFamily: 'Alexandria',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}