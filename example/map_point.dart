class MapPoint {
  String name;
  final double lat;
  final double lon;

  MapPoint({
    required this.name,
    required this.lat,
    required this.lon,
  });

  @override
  String toString() => '"$name" ($lat, $lon)';
}
