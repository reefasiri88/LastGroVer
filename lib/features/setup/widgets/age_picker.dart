import 'package:flutter/material.dart';

class AgePicker extends StatefulWidget {
  final int initialAge;
  final int minAge;
  final int maxAge;
  final ValueChanged<int> onAgeChanged;

  const AgePicker({
    required this.initialAge,
    this.minAge = 18,
    this.maxAge = 100,
    required this.onAgeChanged,
    super.key,
  });

  @override
  State<AgePicker> createState() => _AgePickerState();
}

class _AgePickerState extends State<AgePicker> {
  late FixedExtentScrollController _scrollController;
  late int _selectedAge;

  @override
  void initState() {
    super.initState();
    _selectedAge = widget.initialAge;
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedAge - widget.minAge,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected age display
          Container(
            alignment: Alignment.center,
            height: 80,
            child: Text(
              _selectedAge.toString(),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Alexandria',
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Triangle indicator
          Transform.translate(
            offset: const Offset(0, 10),
            child: CustomPaint(
              size: const Size(24, 16),
              painter: _TrianglePainter(color: Colors.white),
            ),
          ),
          // Wheel picker container
          Container(
            height: 120,
            color: const Color(0xFF8A3FFC),
            child: ListWheelScrollView(
              controller: _scrollController,
              itemExtent: 60,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedAge = widget.minAge + index;
                });
                widget.onAgeChanged(_selectedAge);
              },
              children: List.generate(
                widget.maxAge - widget.minAge + 1,
                (index) {
                  final age = widget.minAge + index;
                  return Center(
                    child: Text(
                      age.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Alexandria',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
