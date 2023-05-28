import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

import 'test_lat_lng.dart';

void main() async {
  final minZoom = 0;
  final maxZoom = 20;

  final points = <TestLatLng>[
    TestLatLng(50.813443, 12.931275),
    TestLatLng(50.813362, 12.931059),
    TestLatLng(50.814048, 12.931202),
    TestLatLng(50.814171, 12.931484),
    TestLatLng(50.814273, 12.931415),
    TestLatLng(50.813756, 12.93058),
    TestLatLng(50.813559, 12.930912),
    TestLatLng(50.813859, 12.930643),
    TestLatLng(50.813898, 12.930761),
    TestLatLng(50.813623, 12.931012),
  ];

  int stableCompare(LayerElement a, LayerElement b) {
    final xCompare = a.x.compareTo(b.x);
    if (xCompare != 0) return xCompare;
    return a.y.compareTo(b.y);
  }

  void testCluster(
    int zoom,
    SuperclusterMutable<TestLatLng> mutableSupercluster,
    SuperclusterImmutable<TestLatLng> immutableSupercluster,
  ) {
    final mutableElements = mutableSupercluster.search(-180, -85, 180, 85, zoom)
      ..sort(stableCompare);
    final immutableElements = immutableSupercluster.search(
        -180, -85, 180, 85, zoom)
      ..sort(stableCompare);

    expect(mutableElements.length, equals(immutableElements.length));

    for (var i = 0; i < mutableElements.length; i++) {
      final mutableElement = mutableElements[i];
      final immutableElement = immutableElements[i];

      // Check the clusters have matching numbers of children.
      if (mutableElement is MutableLayerCluster<TestLatLng>) {
        expect(immutableElement, isA<LayerCluster>());
        immutableElement as ImmutableLayerCluster<TestLatLng>;
        final mutableChildren = mutableSupercluster.childrenOf(mutableElement);
        final immutableChildren =
            immutableSupercluster.childrenOf(immutableElement);
        expect(mutableChildren, isNotEmpty);
        expect(immutableChildren, isNotEmpty);
        expect(mutableChildren.length, equals(immutableChildren.length));
      }

      expect(
        mutableElement.numPoints,
        equals(immutableElement.numPoints),
      );
      expect(mutableElement.x, equals(immutableElement.x));
      expect(mutableElement.y, equals(immutableElement.y));
    }
  }

  test('clusters match', () {
    final mutableSupercluster = SuperclusterMutable<TestLatLng>(
      getX: (p) => p.longitude,
      getY: (p) => p.latitude,
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 120,
      extent: 512,
      nodeSize: 64,
    )..load(points);

    final immutableSupercluster = SuperclusterImmutable<TestLatLng>(
      getX: (p) => p.longitude,
      getY: (p) => p.latitude,
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 120,
      extent: 512,
      nodeSize: 64,
    )..load(points);

    for (int i = maxZoom; i >= minZoom; i--) {
      testCluster(i, mutableSupercluster, immutableSupercluster);
    }
  });
}
