import 'layer_element.dart';

abstract class Supercluster<T> {
  Iterable<LayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
  );

  Iterable<T> getLeaves();
}
