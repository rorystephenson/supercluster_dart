import 'layer.dart';
import 'layer_element.dart';

class LayerModification<T> {
  final Layer<T> layer;
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

  void recordOrphan(LayerElement<T> element) {
    orphaned.add(element);
  }

  List<LayerElement<T>> get removedAndOrphaned =>
      List.from(removed)..addAll(orphaned);

  String get summary => "Remove ${removed.map((e) => e.summary).join(',')} "
      "Ophan ${orphaned.map((e) => e.summary).join(',')}";
}
