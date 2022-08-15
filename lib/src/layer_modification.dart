import 'layer.dart';
import 'layer_element.dart';

class LayerModification<T> {
  final Layer<T> zoomCluster;
  final List<LayerElement<T>> removed;
  final List<LayerElement<T>> added;

  LayerModification({
    required this.zoomCluster,
    required this.removed,
    required this.added,
  });

  void recordRemoval(LayerElement<T> point) {
    removed.add(point.copyWith());
  }

  void recordInsertion(LayerElement<T> point) {
    added.add(point.copyWith());
  }

  void removeFromAddedOrRecordRemoval(LayerElement<T> point) {
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
