import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_app/lat_lon_grid.dart';

import 'map_color_background.dart';
import 'test_app_marker_layer.dart';
import 'test_point.dart';

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
  static final initialPoints = [
    TestPoint(longitude: 9.203368, latitude: 45.460982), // Milano
    TestPoint(longitude: 9.218777, latitude: 45.466276), // Milano east
    TestPoint(longitude: 9.507878, latitude: 45.303647), // Lodi
    TestPoint(longitude: 10.222456, latitude: 45.534990), // Brescia
    TestPoint(longitude: 10.419535, latitude: 45.511298), // Bedizzole
  ];

  static final pointEvents = [
    TestPointEvent.insertion(
        TestPoint(latitude: 46.805213, longitude: 9.448094)),
    TestPointEvent.insertion(
        TestPoint(latitude: 46.775243, longitude: 9.711766)),
    TestPointEvent.insertion(
        TestPoint(latitude: 46.75637, longitude: 9.942479)),
  ];

  const TestAppMap({Key? key}) : super(key: key);

  @override
  State<TestAppMap> createState() => _TestAppMapState();
}

class _TestAppMapState extends State<TestAppMap> {
  static const initialZoom = 7;
  static const maxZoom = 15;
  static const minZoom = 0;

  final GlobalKey<TestAppMarkerLayerState> _markerLayerKey =
      GlobalKey<TestAppMarkerLayerState>();

  late final MapController _mapController;

  int _currentZoom = initialZoom;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                              _currentZoom == i
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
                      center: LatLng(45.4, 9.8),
                      interactiveFlags:
                          InteractiveFlag.all - InteractiveFlag.rotate,
                      zoom: initialZoom.toDouble(),
                      onTap: (_, latLng) {
                        debugPrint('Insert marker at $latLng');
                        setState(() {
                          _markerLayerKey.currentState!.insertAt(latLng);
                        });
                      }),
                  children: [
                    MapColorBackground(),
                    const LatLonGrid(),
                    TestAppMarkerLayer(
                      key: _markerLayerKey,
                      initialPoints: TestAppMap.initialPoints,
                      maxZoom: maxZoom,
                      minZoom: minZoom,
                      onZoomChange: (newZoom) {
                        debugPrint('newZoom: $newZoom');
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
                              final event = TestAppMap.pointEvents.removeAt(0);
                              if (event.isInsertion) {
                                _markerLayerKey.currentState!.insertAt(
                                  LatLng(
                                    event.point!.latitude,
                                    event.point!.longitude,
                                  ),
                                );
                              } else {
                                _markerLayerKey.currentState!
                                    .remove(event.point!);
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
    );
  }
}

class TestPointEvent {
  final TestPoint? point;
  final bool isInsertion;

  TestPointEvent.insertion(this.point) : isInsertion = true;

  TestPointEvent.removal(this.point) : isInsertion = false;
}
