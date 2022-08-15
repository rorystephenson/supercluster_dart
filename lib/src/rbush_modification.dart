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

  void recordRemoval(MutableClusterOrPoint<T> point) {
    removed.add(point.copyWith());
  }

  void recordInsertion(MutableClusterOrPoint<T> point) {
    added.add(point.copyWith());
  }

  void removeFromAddedOrRecordRemoval(MutableClusterOrPoint<T> point) {
    final addedIndex = added.indexWhere((e) => e.uuid == point.uuid);

    if (addedIndex == -1) {
      recordRemoval(point);
    } else {
      added.removeAt(addedIndex);
    }
  }

  int get numPointsChange =>
      added.fold<int>(
          0, (previousValue, element) => previousValue + element.numPoints) -
      removed.fold<int>(
          0, (previousValue, element) => previousValue + element.numPoints);

  String get summary => "$numPointsChange: "
      "Add ${added.map((e) => "${e.uuid} (${e.parentUuid})").join(',')} "
      "Remove ${removed.map((e) => "${e.uuid} (${e.parentUuid})").join(',')}";
}
