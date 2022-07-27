import '../supercluster.dart';

abstract class PointTree<T> {
  void initialize(List<ClusterOrMapPoint<T>> clusters);

  int get size;

  ClusterOrMapPoint<T> point(int id);

  ClusterOrMapPoint<T> firstPointWhere(
      bool Function(ClusterOrMapPoint<T>) test);

  List<int> withinBounds(double minX, double minY, double maxX, double maxY);

  List<int> idsWithinRadius(double x, double y, double radius);
}
