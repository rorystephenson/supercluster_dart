import 'package:supercluster/src/layer.dart';
import 'package:supercluster/src/layer_clusterer.dart';
import 'package:supercluster/src/layer_element.dart';
import 'package:supercluster/src/util.dart' as util;
import 'package:test/test.dart';

void main() {
  Layer<TestPoint> _layer(int radius, int zoom) {
    return Layer(
      zoom: zoom,
      searchRadius: util.searchRadius(40, 512, zoom),
      maxPoints: 100,
      getX: TestPoint.getX,
      getY: TestPoint.getY,
    );
  }

  List<Layer<TestPoint>> _layers(
      int maxZoom, int radius, List<TestPoint> points) {
    final layers = List<Layer<TestPoint>>.generate(
      maxZoom + 2,
      (index) => _layer(radius, index),
    );
    final layerClusterer =
        LayerClusterer<TestPoint>(radius: radius, extent: 512);

    var clusters = points
        .map(
          (point) => LayerElement.initializePoint(
            point: point,
            lon: point.longitude,
            lat: point.latitude,
            zoom: maxZoom + 1,
          ),
        )
        .map((layerPoint) => layerPoint.positionRBushPoint())
        .toList();

    layers[maxZoom + 1].load(clusters);
    for (int z = maxZoom; z >= 0; z--) {
      clusters = layerClusterer
          .cluster(clusters, z, layers[z + 1])
          .map((c) => c.positionRBushPoint())
          .toList(); // create a new set of clusters for the zoom
      layers[z].load(clusters); // index input points into an R-tree
    }

    return layers;
  }

  final testData = [
    TestPoint(longitude: 9.203368, latitude: 45.460982), // Milano
    TestPoint(longitude: 9.218777, latitude: 45.466276), // Milano east
    TestPoint(longitude: 9.507878, latitude: 45.303647), // Lodi
    TestPoint(longitude: 10.222456, latitude: 45.534990), // Brescia
    TestPoint(longitude: 10.419535, latitude: 45.511298), // Bedizzole
  ];

  test('temp', () {
    final maxZoom = 10;
    final layers = _layers(maxZoom, 40, testData);
    expect(layers.map((e) => e.numPoints).toSet().single, testData.length);
    expect(layers.map((e) => e.numLayerElements).toList(),
        [1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 5]);

    final toRemove = testData[3];

    var modification =
        layers[maxZoom + 1].removePointWithoutClustering(toRemove);
    expect(layers[maxZoom + 1].numPoints, testData.length - 1);
    expect(layers[maxZoom + 1].numLayerElements, testData.length - 1);

    //modification = layers[maxZoom].modify(modification);
    //modification = layers[maxZoom - 1].modify(modification);

    print('done');
  });
}

class TestPoint {
  static int _sequence = 0;
  final int id;
  final double longitude;
  final double latitude;

  TestPoint._(
      {required this.id, required this.longitude, required this.latitude});

  factory TestPoint({required double longitude, required double latitude}) {
    final int id = _sequence;
    _sequence++;
    return TestPoint._(id: id, longitude: longitude, latitude: latitude);
  }

  static double getX(TestPoint p) => p.longitude;

  static double getY(TestPoint p) => p.latitude;
}
