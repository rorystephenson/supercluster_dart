class Cluster {
  static const _maxInt = 9007199254740992; // 2^53

  final double x;
  final double y;
  int zoom;
  int id;
  int parentId;
  int numPoints;

  Cluster({
    required this.x,
    required this.y,
    required this.id,
    required this.numPoints,
  })  : zoom = _maxInt,
        parentId = -1;
}
