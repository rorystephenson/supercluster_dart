import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable/mutable_layer_element.dart';

extension RBushBoxIterableExtension<T>
    on Iterable<RBushElement<MutableLayerElement<T>>> {
  RBushBox boundary() => _calculateBoundary(map((e) => e.data));

  RBushBox paddedBoundary(double padding) =>
      _calculateBoundary(map((e) => e.data)).._expand(padding);
}

extension MutableLayerElementIterableExtension<T>
    on Iterable<MutableLayerElement<T>> {
  RBushBox boundary() => _calculateBoundary(this);

  RBushBox paddedBoundary(double padding) =>
      _calculateBoundary(this).._expand(padding);
}

extension RBushBoxExtension on RBushBox {
  RBushBox expandBy(double expandBy) {
    return RBushBox(
      minX: minX - expandBy,
      minY: minY - expandBy,
      maxX: maxX + expandBy,
      maxY: maxY + expandBy,
    );
  }

  // Mutates the object, should only be used when this RBushBox is a fresh
  // instance to avoid modifying points in the index.
  void _expand(double amount) {
    minX -= amount;
    minY -= amount;
    maxX += amount;
    maxY += amount;
  }
}

extension MutableLayerElementExtension<T> on MutableLayerElement<T> {
  RBushBox paddedBoundary(double padding) => RBushBox(
        minX: x - padding,
        minY: y - padding,
        maxX: x + padding,
        maxY: y + padding,
      );
}

extension MutableLayerClusterExtension<T> on MutableLayerCluster<T> {
  RBushBox descendantsBounds(double clusterRadius) => RBushBox(
        minX: originX - clusterRadius,
        minY: originY - clusterRadius,
        maxX: originX + clusterRadius,
        maxY: originY + clusterRadius,
      );
}

// All boundary calculations should use this method. RBush's [extend] method
// mutates the RBushBox so a new one must be created to avoid mutating points in
// the index.
RBushBox _calculateBoundary<T>(Iterable<MutableLayerElement<T>> elements) {
  RBushBox result = elements.first.indexRBushPoint();

  for (final element in elements.skip(1)) {
    result.minX = min(result.minX, element.x);
    result.minY = min(result.minY, element.y);
    result.maxX = max(result.maxX, element.x);
    result.maxY = max(result.maxY, element.y);
  }

  return result;
}
