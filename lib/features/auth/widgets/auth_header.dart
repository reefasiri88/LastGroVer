import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final String title;
  final String? subtitle;

  const AuthHeader({
    super.key,
    this.onBackPressed,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBackPressed != null)
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(13),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.chevron_left, color: Colors.white, size: 24),
            ),
          ),
        if (onBackPressed != null) SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Alexandria',
            letterSpacing: -0.3,
            height: 1.3,
          ),
        ),
        if (subtitle != null) SizedBox(height: 12),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.64),
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),
      ],
    );
  }
}
