import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class SplashTransition extends StatelessWidget {
  const SplashTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ColoredBox(
        color: AppColors.background,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final logoWidth = width * 0.88;

            return Stack(
              children: [
                Positioned(
                  left: -width * 0.26,
                  top: -height * 0.10,
                  child: Container(
                    width: width * 0.96,
                    height: width * 0.96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF7F55C7).withValues(alpha: 0.85),
                          const Color(0xFF5C2D9C).withValues(alpha: 0.45),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -width * 0.18,
                  bottom: -height * 0.10,
                  child: Container(
                    width: width * 1.18,
                    height: height * 0.34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF411370).withValues(alpha: 0.30),
                          const Color(0xFF411370).withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: SizedBox.expand(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.35),
                        SizedBox(
                          width: logoWidth,
                          child: Image.asset(
                            'assets/images/GromotionLogoW.png',
                            fit: BoxFit.contain,
                            color: Colors.white,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(height: height * 0.055),
                        Text(
                          'Walk the Future',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.36,
                            height: 34 / 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 270),
                          child: Text(
                            'Turn your steps into clean, shared\nenergy.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: const Color(0xFFDDDDDD),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.5,
                              height: 23.5 / 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}