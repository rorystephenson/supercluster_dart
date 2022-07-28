abstract class PointIndex<T> {
  void load(List<T> clusterOrMapPoints);

  int get size;

  List<T> withinRadius(double x, double y, double radius);

  List<T> withinBounds(
    double minX,
    double minY,
    double maxX,
    double maxY,
  );
}
