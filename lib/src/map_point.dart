class MapPoint {
  static const _maxInt = 9007199254740992; // 2^53

  final double x;
  final double y;
  final int index;
  int parentId;
  int zoom;

  MapPoint({
    required this.x,
    required this.y,
    required this.index,
    this.zoom = _maxInt,
  }) : parentId = -1;
}
