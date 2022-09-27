import 'package:supercluster/src/mutable/mutable_layer.dart';

import 'mutable_layer_element.dart';

class LayerElementModification<T> {
  final MutableLayer<T> layer;
  final MutableLayerElement<T> oldLayerElement;
  final MutableLayerElement<T> newLayerElement;

  LayerElementModification({
    required this.layer,
    required this.oldLayerElement,
    required this.newLayerElement,
  });
}
