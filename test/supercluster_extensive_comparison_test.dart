import 'package:supercluster/src/uuid_stub.dart';
import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';

void main() async {
  final pointsCount = Fixtures.features.length;

  int stableCompare(LayerElement a, LayerElement b) {
    final xCompare = a.x.compareTo(b.x);
    if (xCompare != 0) return xCompare;
    return a.y.compareTo(b.y);
  }

  void testCluster(
    int zoom,
    SuperclusterMutable<Map<String, dynamic>> mutableSupercluster,
    SuperclusterImmutable<Map<String, dynamic>> immutableSupercluster,
  ) {
    final mutableElements = mutableSupercluster.search(-180, -85, 180, 85, zoom)
      ..sort(stableCompare);
    final immutableElements = immutableSupercluster.search(
        -180, -85, 180, 85, zoom)
      ..sort(stableCompare);

    expect(mutableElements.length, equals(immutableElements.length));

    expect(
      mutableElements.map((e) => e.numPoints).reduce((acc, e) => acc + e),
      pointsCount,
    );
    expect(
      immutableElements.map((e) => e.numPoints).reduce((acc, e) => acc + e),
      pointsCount,
    );

    for (var i = 0; i < mutableElements.length; i++) {
      final mutableElement = mutableElements[i];
      final immutableElement = immutableElements[i];

      try {
        if (mutableElement is LayerCluster) {
          // Check the clusters have matching numbers of children.
          mutableElement as MutableLayerCluster<Map<String, dynamic>>;
          immutableElement as ImmutableLayerCluster<Map<String, dynamic>>;
          expect(mutableElement.numPoints, equals(immutableElement.numPoints));

          final mutableChildren =
              mutableSupercluster.childrenOf(mutableElement);
          final immutableChildren =
              immutableSupercluster.childrenOf(immutableElement);

          expect(mutableChildren.fold(0, (acc, e) => acc + e.numPoints),
              mutableElement.numPoints);
          expect(immutableChildren.fold(0, (acc, e) => acc + e.numPoints),
              immutableElement.numPoints);

          expect(mutableChildren, isNotEmpty);
          expect(immutableChildren, isNotEmpty);
          expect(mutableChildren.length, equals(immutableChildren.length));
        }

        expect(
          mutableElement.numPoints,
          equals(immutableElement.numPoints),
        );
        // Note that the following two comparisons use closeTo with a very low
        // delta instead of equals because a cluster's x/y are weighted values
        // calculated by summing the weighted x/y of the cluster's points. The
        // summing may not happen in the same order (since the underlying
        // indexes are not the same for immutable/mutable superclusters) which
        // can cause tiny deviations caused by floating point precision.
        expect(
          mutableElement.x,
          closeTo(immutableElement.x, 0.000000000000001),
        );
        expect(
          mutableElement.y,
          closeTo(immutableElement.y, 0.000000000000001),
        );
      } catch (_) {
        print('Failure at zoom: $zoom with elements:');
        print(
            'Mutable: ${mutableElement.runtimeType} uuid ${mutableElement.uuid}');
        print(
            'Immutable: ${immutableElement.runtimeType} uuid ${immutableElement.uuid}');
        rethrow;
      }
    }
  }

  test('clusters match', () {
    final mutableSupercluster = SuperclusterMutable<Map<String, dynamic>>(
      getX: (json) {
        return json['geometry']?['coordinates'][0].toDouble();
      },
      getY: (json) {
        return json['geometry']?['coordinates'][1].toDouble();
      },
      generateUuid: UuidStub.v4,
    )..load(Fixtures.features);

    final immutableSupercluster = SuperclusterImmutable<Map<String, dynamic>>(
      getX: (json) {
        return json['geometry']?['coordinates'][0].toDouble();
      },
      getY: (json) {
        return json['geometry']?['coordinates'][1].toDouble();
      },
    )..load(Fixtures.features);
    expect(mutableSupercluster.minZoom, equals(immutableSupercluster.minZoom));
    expect(mutableSupercluster.maxZoom, equals(immutableSupercluster.maxZoom));
    final minZoom = mutableSupercluster.minZoom;
    final maxZoom = mutableSupercluster.maxZoom;

    for (int i = maxZoom; i >= minZoom; i--) {
      testCluster(i, mutableSupercluster, immutableSupercluster);
    }
  });
}
