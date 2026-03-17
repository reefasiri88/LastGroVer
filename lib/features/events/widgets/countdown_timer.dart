import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final String days;
  final String hours;
  final String minutes;
  final String seconds;

  const CountdownTimer({
    super.key,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timer numbers
        Text(
          '${widget.days}    :    ${widget.hours}    :    ${widget.minutes}    :    ${widget.seconds}',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        // Timer labels (Arabic)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'ثواني',
              style: TextStyle(
                fontFamily: 'Noto Sans Arabic',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            Text(
              'دقائق',
              style: TextStyle(
                fontFamily: 'Noto Sans Arabic',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            Text(
              'ساعات',
              style: TextStyle(
                fontFamily: 'Noto Sans Arabic',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            Text(
              'أيام',
              style: TextStyle(
                fontFamily: 'Noto Sans Arabic',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
