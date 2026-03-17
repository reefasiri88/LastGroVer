import 'package:flutter/material.dart';

class SetupOptionCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const SetupOptionCard({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ??
        (isSelected ? const Color(0xFFA56EFF) : Colors.transparent);
    final effectiveBorderColor = isSelected
        ? const Color(0xFFA56EFF)
        : Colors.white.withValues(alpha: 0.17);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(38),
          border: Border.all(
            color: effectiveBorderColor,
            width: 1,
          ),
          color: isSelected
              ? effectiveBackgroundColor
              : Colors.white.withValues(alpha: 0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 16),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Alexandria',
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  