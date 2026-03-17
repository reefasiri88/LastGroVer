import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD9D9D9),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Center(
          child: Icon(
            Icons.chevron_left,
            color: Color(0xFFD9D9D9),
            size: 24,
          ),
        ),
      ),
    );
  }
}
