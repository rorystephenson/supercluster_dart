import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_app/lat_lon_grid.dart';

import 'map_color_background.dart';
import 'test_app_marker_layer.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestAppMap(),
    );
  }
}

class TestAppMap extends StatefulWidget {
  static final initialPoints = <(double lat, double lon)>[];
  static final addPoints = <(double lat, double lon)>[
    (53.3498, -6.2603),
    (53.3488, -6.2613),
    (53.347312, -6.24508),
  ];

  static final removalPoints = <(double lat, double lon)>[
    (53.347312, -6.24508),
  ];
  static final pointEvents = [
    ...addPoints.map((e) => TestPointEvent.add(e)),
    ...removalPoints.map((e) => TestPointEvent.removal(e))
  ];

  const TestAppMap({Key? key}) : super(key: key);

  @override
  State<TestAppMap> createState() => _TestAppMapState();
}

class _TestAppMapState extends State<TestAppMap> {
  static const int initialZoom = 11;
  static const int maxZoom = 16; // Default is 16
  static const int minZoom = 0; // Default is 0
  static const int minPoints = 2; // Default is 2
  static const int radius = 40; // Default 40
  static const int extent = 512; // Default 512
  static const int nodeSize = 16; // Default 16
  late final (double, double) initialCenter;

  final GlobalKey<TestAppMarkerLayerState> _markerLayerKey =
      GlobalKey<TestAppMarkerLayerState>();

  late final MapController _mapController;

  int _currentZoom = initialZoom;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    var latSum = 0.0;
    var lonSum = 0.0;
    final pointEventPoints = TestAppMap.pointEvents
        .map((e) => e.point)
        .whereType<(double, double)>()
        .toList();
    for (final point in pointEventPoints) {
      latSum += point.$1;
      lonSum += point.$2;
    }
    initialCenter = pointEventPoints.isEmpty
        ? (45.4, 9.8)
        : (
            latSum / pointEventPoints.length,
            lonSum / pointEventPoints.length,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey.shade300,
            width: 70,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = maxZoom; i >= minZoom; i--)
                      Flexible(
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor: MaterialStateProperty.all(
                                _currentZoom.floor() == i
                                    ? Colors.blue.shade200
                                    : Colors.white),
                          ),
                          onPressed: () {
                            _markerLayerKey.currentState!.zoomTo(i);
                          },
                          child: Text(i.toString()),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      minZoom: minZoom.toDouble(),
                      maxZoom: maxZoom.toDouble(),
                      center: LatLng(initialCenter.$1, initialCenter.$2),
                      interactiveFlags:
                          InteractiveFlag.all - InteractiveFlag.rotate,
                      zoom: initialZoom.toDouble(),
                      onTap: (_, latLng) {
                        debugPrint('Add marker at $latLng');
                        setState(() {
                          _markerLayerKey.currentState!.addAt(latLng);
                        });
                      },
                    ),
                    nonRotatedChildren: [
                      Builder(
                        builder: (context) => SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              FlutterMapState.maybeOf(context)!
                                  .zoom
                                  .toStringAsFixed(3),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                    children: [
                      const MapColorBackground(),
                      const LatLonGrid(),
                      TestAppMarkerLayer(
                        key: _markerLayerKey,
                        initialPoints: TestAppMap.initialPoints,
                        maxZoom: maxZoom,
                        minZoom: minZoom,
                        minPoints: minPoints,
                        radius: radius,
                        extent: extent,
                        nodeSize: nodeSize,
                        onZoomChange: (newZoom) {
                          final newRoundedZoom = newZoom.ceil();
                          if (_currentZoom != newRoundedZoom) {
                            setState(() {
                              _currentZoom = newRoundedZoom;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey.shade300,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: TestAppMap.pointEvents.isEmpty
                            ? null
                            : () {
                                final event =
                                    TestAppMap.pointEvents.removeAt(0);
                                if (event.isAdd) {
                                  _markerLayerKey.currentState!.addAt(
                                    LatLng(event.point.$1, event.point.$2),
                                  );
                                } else {
                                  _markerLayerKey.currentState!
                                      .remove((event.point.$1, event.point.$2));
                                }
                                setState(() {});
                              },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: const Text('step'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TestPointEvent {
  final (double, double) point;
  final bool isAdd;

  TestPointEvent.add(this.point) : isAdd = true;

  TestPointEvent.removal(this.point) : isAdd = false;
}
