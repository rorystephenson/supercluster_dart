import 'cluster_rbush.dart';
import 'mutable_cluster_or_point.dart';

class RBushModification<T> {
  final ClusterRBush<T> zoomCluster;
  final List<MutableClusterOrPoint<T>> removed;
  final List<MutableClusterOrPoint<T>> added;

  RBushModification({
    required this.zoomCluster,
    required this.removed,
    required this.added,
  });

  void remove(MutableClusterOrPoint<T> point) {
    if (removed.any((element) => point.uuid == element.uuid)) return;
    removed.add(point.copyWith());
    added.removeWhere((element) => element.uuid == point.uuid);
  }

  void insert(MutableClusterOrPoint<T> point) {
    if (added.any((element) => point.uuid == element.uuid)) return;
    added.add(point.copyWith());
    removed.removeWhere((element) => element.uuid == point.uuid);
  }

  int get numPointsChange =>
      added.fold<int>(
          0, (previousValue, element) => previousValue + element.numPoints) -
      removed.fold<int>(
          0, (previousValue, element) => previousValue + element.numPoints);

  String get summary =>
      "Add ${added.map((e) => "${e.uuid} (${e.parentUuid})").join(',')}\n"
      "Remove ${removed.map((e) => "${e.uuid} (${e.parentUuid})").join(',')}";
}
