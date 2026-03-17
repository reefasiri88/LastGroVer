import 'package:flutter/material.dart';

class HomeIndicator extends StatelessWidget {
  final double height;

  const HomeIndicator({
    super.key,
    this.height = 34,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }
}
