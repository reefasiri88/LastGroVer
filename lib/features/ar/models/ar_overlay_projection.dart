class ArOverlayProjection {
  const ArOverlayProjection({
    required this.id,
    required this.screenX,
    required this.screenY,
    required this.scale,
    required this.opacity,
    required this.depth,
  });

  final String id;
  final double screenX;
  final double screenY;
  final double scale;
  final double opacity;
  final double depth;
}