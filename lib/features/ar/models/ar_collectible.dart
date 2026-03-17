class ArCollectible {
  ArCollectible({
    required this.id,
    required this.stop,
    required this.value,
    this.lateralOffset = 0,
    this.collected = false,
  });

  final String id;
  final double stop;
  final int value;
  final double lateralOffset;
  bool collected;
}