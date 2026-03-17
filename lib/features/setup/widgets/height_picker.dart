import 'package:flutter/material.dart';

class HeightPicker extends StatefulWidget {
  final double initialHeight;
  final double minHeight;
  final double maxHeight;
  final ValueChanged<double> onHeightChanged;

  const HeightPicker({
    required this.initialHeight,
    this.minHeight = 140,
    this.maxHeight = 220,
    required this.onHeightChanged,
    super.key,
  });

  @override
  State<HeightPicker> createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  late double _selectedHeight;

  @override
  void initState() {
    super.initState();
    _selectedHeight = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          // Displayed height value
          Text(
            _selectedHeight.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Alexandria',
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'cm',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontFamily: 'Alexandria',
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 40),
          // Vertical slider
          SizedBox(
            height: 250,
            child: RotatedBox(
              quarterTurns: -1,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(
                    elevation: 0,
                    enabledThumbRadius: 12,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  activeTrackColor: const Color(0xFFA56EFF),
                  inactiveTrackColor: const Color(0xFF8A3FFC),
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: _selectedHeight,
                  min: widget.minHeight,
                  max: widget.maxHeight,
                  divisions: (widget.maxHeight - widget.minHeight).toInt(),
                  onChanged: (value) {
                    setState(() {
                      _selectedHeight = value;
                    });
                    widget.onHeightChanged(value);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Height range labels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.minHeight.toStringAsFixed(0)} cm',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontFamily: 'Alexandria',
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 32),
              Text(
                '${widget.maxHeight.toStringAsFixed(0)} cm',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontFamily: 'Alexandria',
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
