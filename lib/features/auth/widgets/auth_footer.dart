import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final String mainText;
  final String linkText;
  final VoidCallback onLinkTapped;

  const AuthFooter({
    super.key,
    required this.mainText,
    required this.linkText,
    required this.onLinkTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLinkTapped,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: mainText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.w300,
                letterSpacing: 0.15,
              ),
            ),
            TextSpan(
              text: ' ',
            ),
            TextSpan(
              text: linkText,
              style: TextStyle(
                color: Color(0xFFffa434),
                fontSize: 15,
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.w300,
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
