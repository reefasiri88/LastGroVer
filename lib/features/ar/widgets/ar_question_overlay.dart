import 'dart:ui';

import 'package:flutter/material.dart';

import 'ar_glass_panel.dart';

class ArQuestionOverlay extends StatelessWidget {
  const ArQuestionOverlay({
    super.key,
    required this.onCorrectChoice,
    required this.onWrongChoice,
  });

  final VoidCallback onCorrectChoice;
  final VoidCallback onWrongChoice;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.28),
              ),
            ),
          ),
          Center(
            child: ArGlassPanel(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 22),
              radius: 24,
              backgroundColor: const Color(0x85524B46),
              borderColor: const Color(0xFF8647FF),
              blurSigma: 18,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Every drop has a past; every step ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: _AnswerPill(
                            label: 'A chance',
                            selected: true,
                            onPressed: onCorrectChoice,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AnswerPill(
                            label: 'A cost',
                            selected: false,
                            onPressed: onWrongChoice,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerPill extends StatelessWidget {
  const _AnswerPill({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0x2BF4C9FF)
              : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFF8647FF)
                : Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}