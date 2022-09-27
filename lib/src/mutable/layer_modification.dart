import 'mutable_layer.dart';
import 'mutable_layer_element.dart';

class LayerModification<T> {
  final MutableLayer<T> layer;
  final List<MutableLayerElement<T>> removed = [];
  final List<MutableLayerElement<T>> orphaned = [];

  LayerModification({
    required this.layer,
  });

  void recordRemoval(MutableLayerElement<T> element) {
    removed.add(element);
  }

  void recordRemovals(Iterable<MutableLayerElement<T>> elements) {
    removed.addAll(elements);
  }

  void recordOrphan(MutableLayerElement<T> element) {
    orphaned.add(element);
  }

  List<MutableLayerElement<T>> get removedAndOrphaned =>
      List.from(removed)..addAll(orphaned);

  String get summary => "Remove ${removed.map((e) => e.summary).join(',')} "
      "Ophan ${orphaned.map((e) => e.summary).join(',')}";
}
