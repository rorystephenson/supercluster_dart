import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:supercluster/supercluster.dart';

class TestAppMarkerLayer extends StatefulWidget {
  final void Function(double currentZoom) onZoomChange;
  final List<(double, double)> initialPoints;
  final int maxZoom;
  final int minZoom;
  final int minPoints;
  final int radius;
  final int extent;
  final int nodeSize;

  const TestAppMarkerLayer({
    Key? key,
    required this.initialPoints,
    required this.onZoomChange,
    required this.maxZoom,
    required this.minZoom,
    required this.minPoints,
    required this.radius,
    required this.extent,
    required this.nodeSize,
  }) : super(key: key);

  @override
  State<TestAppMarkerLayer> createState() => TestAppMarkerLayerState();
}

class TestAppMarkerLayerState extends State<TestAppMarkerLayer> {
  static const clusterSize = 35.0;

  double? _currentZoom;

  final _boundsPixelPadding = const CustomPoint(
    clusterSize / 2,
    clusterSize / 2,
  );

  late final SuperclusterMutable<(double, double)> supercluster;

  late StreamSubscription<void> _onMoveListener;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onMoveListener = FlutterMapState.maybeOf(context)!
          .mapController
          .mapEventStream
          .listen((event) {
        final newZoom = FlutterMapState.maybeOf(context)!.zoom;
        if (newZoom != _currentZoom) {
          _currentZoom = newZoom;
          widget.onZoomChange(newZoom);
        }
      });
    });

    supercluster = SuperclusterMutable<(double, double)>(
      generateUuid: UuidStub.v4,
      getX: (point) => point.$2,
      getY: (point) => point.$1,
      maxZoom: widget.maxZoom,
      minZoom: widget.minZoom,
      minPoints: widget.minPoints,
      radius: widget.radius,
      extent: widget.extent,
      nodeSize: widget.nodeSize,
    )..load(widget.initialPoints);
  }

  @override
  void dispose() {
    _onMoveListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = FlutterMapState.maybeOf(context)!;
    final bounds = mapState.pixelBounds;
    final paddedBounds = LatLngBounds(
      mapState.unproject(bounds.topLeft - _boundsPixelPadding),
      mapState.unproject(bounds.bottomRight + _boundsPixelPadding),
    );

    return StreamBuilder<void>(
      stream: mapState.mapController.mapEventStream,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        final points = supercluster.search(
          paddedBounds.west,
          paddedBounds.south,
          paddedBounds.east,
          paddedBounds.north,
          mapState.zoom.ceil(),
        );

        List<Widget> markers = [];

        final center = mapState.center;
        final clusterZoom = mapState.zoom.ceil();
        final searchSize =
            (widget.radius) / ((widget.extent) * pow(2, clusterZoom));
        final centerX = center.longitude / 360 + 0.5;
        final offsetX = centerX - searchSize;
        final offsetLat = (offsetX - 0.5) * 360;
        final offsetLatLng = LatLng(center.latitude, offsetLat);
        final centerPoint = mapState.project(center);
        final offsetPoint = mapState.project(offsetLatLng);
        final pointSize = 2 * (centerPoint.x - offsetPoint.x);

        for (final point in points) {
          final pointPosition = mapState.project(
            point.map(
              cluster: (cluster) => LatLng(cluster.latitude, cluster.longitude),
              point: (point) => LatLng(
                point.originalPoint.$1,
                point.originalPoint.$2,
              ),
            ),
          );
          final position = pointPosition - mapState.pixelOrigin;

          markers.add(
            Positioned(
              width: pointSize,
              height: pointSize,
              left: position.x - (pointSize / 2),
              top: position.y - (pointSize / 2),
              child: Container(
                width: pointSize,
                height: pointSize,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: point.map(
                  cluster: (cluster) => Center(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            width: clusterSize,
                            height: clusterSize,
                          ),
                        ),
                        Center(
                          child: Text(
                            "${cluster.uuid}<${cluster.parentUuid}\n"
                            "${cluster.numPoints}\n"
                            "${cluster.highestZoom}-${cluster.lowestZoom}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  point: (point) => GestureDetector(
                    onTap: () {
                      final latLng = LatLng(
                        point.originalPoint.$1,
                        point.originalPoint.$2,
                      );
                      debugPrint('Removing point at $latLng');
                      setState(() {
                        supercluster.remove(point.originalPoint);
                      });
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 4,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${point.uuid}<${point.parentUuid}\n${point.highestZoom}-${point.lowestZoom}',
                            style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.white)
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Stack(children: markers);
      },
    );
  }

  void addAt(LatLng latLng) {
    setState(() {
      supercluster.add((latLng.latitude, latLng.longitude));
    });
  }

  void remove((double, double) point) {
    setState(() {
      supercluster.remove(point);
    });
  }

  void zoomTo(int zoom) {
    final mapState = FlutterMapState.maybeOf(context)!;
    mapState.move(mapState.center, zoom.toDouble(),
        source: MapEventSource.custom);
  }
}

class UuidStub {
  static int _sequence = 0;

  static String v4() {
    final result = _sequence.toString();
    _sequence++;
    return result;
  }
}
