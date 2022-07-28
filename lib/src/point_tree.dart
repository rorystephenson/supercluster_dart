import '../supercluster.dart';

abstract class PointTree<T> {
  void initialize(List<ClusterOrMapPoint<T>> clusters);

  int get size;

  ClusterOrMapPoint<T> pointWithId(int id);

  ClusterOrMapPoint<T> firstPointWhere(
      bool Function(ClusterOrMapPoint<T>) test);

  List<ClusterOrMapPoint<T>> withinBounds(
      double minX, double minY, double maxX, double maxY);

  List<ClusterOrMapPoint<T>> withinRadius(double x, double y, double radius);
}
