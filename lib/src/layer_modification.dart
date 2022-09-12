import 'layer.dart';
import 'layer_element.dart';

class LayerModification<T> {
  final Layer<T> layer;
  final List<LayerElement<T>> added = [];
  final List<LayerElement<T>> removed = [];
  final List<LayerElement<T>> orphaned = [];

  LayerModification({
    required this.layer,
  });

  void recordRemoval(LayerElement<T> element) {
    removed.add(element);
  }

  void recordRemovals(Iterable<LayerElement<T>> elements) {
    removed.addAll(elements);
  }

  void recordAddition(LayerElement<T> element) {
    added.add(element);
  }

  void recordOrphan(LayerElement<T> element) {
    orphaned.add(element);
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
