import 'package:flutter/material.dart';

class WeightPicker extends StatefulWidget {
  final double initialWeight;
  final double minWeight;
  final double maxWeight;
  final ValueChanged<double> onWeightChanged;

  const WeightPicker({
    required this.initialWeight,
    this.minWeight = 40,
    this.maxWeight = 150,
    required this.onWeightChanged,
    super.key,
  });

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late double _selectedWeight;

  @override
  void initState() {
    super.initState();
    _selectedWeight = widget.initialWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          // Displayed weight value
          Text(
            _selectedWeight.toStringAsFixed(0),
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
            'kg',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontFamily: 'Alexandria',
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 40),
          // Slider
          SizedBox(
            height: 80,
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
                value: _selectedWeight,
                min: widget.minWeight,
                max: widget.maxWeight,
                divisions: (widget.maxWeight - widget.minWeight).toInt(),
                onChanged: (value) {
                  setState(() {
                    _selectedWeight = value;
                  });
                  widget.onWeightChanged(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Weight labels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.minWeight.toStringAsFixed(0)} kg',
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
                '${widget.maxWeight.toStringAsFixed(0)} kg',
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
