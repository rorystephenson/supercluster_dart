import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

List<MutableLayerElement<T>> layerElementsAtZoom<T>(
        SuperclusterMutable<T> index, int zoom) =>
    index.search(-180, -90, 180, 90, zoom).toList();

Map<int, int> numPointsAtZooms(SuperclusterMutable index) {
  return {
    for (int z = index.maxZoom; z >= index.minZoom; z--)
      z: layerElementsAtZoom(index, z).fold(
        0,
        (previousValue, element) => previousValue + element.numPoints,
      )
  };
}

void validateMutableSupercluster(
  SuperclusterMutable supercluster, {
  int? expectedPoints,
}) {
  if (expectedPoints != null) {
    expect(
      numPointsAtZooms(supercluster),
      equals({
        for (int z = supercluster.maxZoom; z >= supercluster.minZoom; z--)
          z: expectedPoints
      }),
    );
  }

  final elementsAtZooms = {
    for (var z in [
      for (int z = supercluster.maxZoom + 1; z >= supercluster.minZoom; z--) z
    ])
      z: layerElementsAtZoom(supercluster, z)
  };

  for (int z = supercluster.maxZoom + 1; z >= supercluster.minZoom; z--) {
    for (final elementAtZoom in elementsAtZooms[z]!) {
      final lowestZoom = elementAtZoom.lowestZoom;
      final highestZoom = elementAtZoom.highestZoom;

      if (lowestZoom != supercluster.minZoom) {
        expect(
          elementAtZoom.parentUuid,
          isNotNull,
          reason:
              'Element $elementAtZoom at zoom $z should be present at the minimum zoom or have a parent',
        );
      }

      if (lowestZoom - 1 >= supercluster.minZoom) {
        expect(
          elementsAtZooms[lowestZoom - 1]!.contains(elementAtZoom),
          isFalse,
          reason:
              'Element should not be present below its lowest zoom $lowestZoom.',
        );
      }
      if (highestZoom + 1 <= supercluster.maxZoom + 1) {
        expect(
          elementsAtZooms[highestZoom + 1]!.contains(elementAtZoom),
          isFalse,
          reason:
              'Element should not be present above its highest zoom $highestZoom',
        );
      }
      for (int i = highestZoom; i >= lowestZoom; i--) {
        if (highestZoom > supercluster.maxZoom + 1) continue;
        expect(
          elementsAtZooms[i],
          contains(elementAtZoom),
          reason:
              'Element ${elementAtZoom.summary} should be present at all zooms from its highest to lowest',
        );
      }
      if (elementAtZoom.parentUuid != null) {
        final parentZoom = elementAtZoom.lowestZoom - 1;
        expect(
          elementsAtZooms[parentZoom]!
              .where((element) => element.uuid == elementAtZoom.parentUuid),
          hasLength(1),
          reason:
              'Element\'s (${elementAtZoom.uuid}) parent (${elementAtZoom.parentUuid}) should exist at zoom $parentZoom',
        );
      }

      if (elementAtZoom is MutableLayerCluster) {
        final descendantsZoom = elementAtZoom.highestZoom + 1;

        expect(
          elementsAtZooms[descendantsZoom]!
              .any((element) => element.parentUuid == elementAtZoom.uuid),
          isTrue,
          reason: 'Element\'s children should exist',
        );
      }
    }
  }
}
