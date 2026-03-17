import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.white, size: 12),
            ],
          ),
        ],
      ),
    );
  }
}
