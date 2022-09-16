import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:supercluster/supercluster.dart';

import 'test_point.dart';

class TestAppMarkerLayer extends StatefulWidget {
  final void Function(double currentZoom) onZoomChange;
  final List<TestPoint> initialPoints;
  final int maxZoom;
  final int minZoom;

  const TestAppMarkerLayer({
    Key? key,
    required this.initialPoints,
    required this.onZoomChange,
    required this.maxZoom,
    required this.minZoom,
  }) : super(key: key);

  @override
  State<TestAppMarkerLayer> createState() => TestAppMarkerLayerState();
}

class TestAppMarkerLayerState extends State<TestAppMarkerLayer> {
  static const markerSize = 30.0;
  static const clusterSize = 50.0;

  double? _currentZoom;

  final _boundsPixelPadding = const CustomPoint(
    clusterSize / 2,
    clusterSize / 2,
  );

  late final SuperclusterMutable<TestPoint> supercluster;

  late StreamSubscription<void> _onMoveListener;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onMoveListener = MapState.maybeOf(context)!.onMoved.listen((event) {
        final newZoom = MapState.maybeOf(context)!.zoom;
        if (newZoom != _currentZoom) {
          _currentZoom = newZoom;
          widget.onZoomChange(newZoom);
        }
      });
    });

    supercluster = SuperclusterMutable<TestPoint>(
      getX: TestPoint.getX,
      getY: TestPoint.getY,
      maxZoom: widget.maxZoom,
      minZoom: widget.minZoom,
    )..load(widget.initialPoints);
  }

  @override
  void dispose() {
    _onMoveListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    final bounds = mapState.pixelBounds;
    final paddedBounds = LatLngBounds(
      mapState.unproject(bounds.topLeft - _boundsPixelPadding),
      mapState.unproject(bounds.bottomRight + _boundsPixelPadding),
    );

    return StreamBuilder<void>(
      stream: mapState.onMoved,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        final points = supercluster.search(
          paddedBounds.west,
          paddedBounds.south,
          paddedBounds.east,
          paddedBounds.north,
          mapState.zoom.ceil(),
        );

        List<Widget> markers = [];

        for (final point in points) {
          final pointPosition = mapState.project(
            point.map(
              cluster: (cluster) => LatLng(cluster.latitude, cluster.longitude),
              point: (point) => LatLng(
                point.originalPoint.latitude,
                point.originalPoint.longitude,
              ),
            ),
          );
          final position = pointPosition - mapState.getPixelOrigin();
          final pointSize = point.map(
              cluster: (cluster) => clusterSize, point: (point) => markerSize);

          markers.add(
            Positioned(
              width: clusterSize,
              height: pointSize,
              left: position.x - (pointSize / 2),
              top: position.y - (pointSize / 2),
              child: point.map(
                cluster: (cluster) => Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(pointSize / 2),
                  ),
                  width: pointSize,
                  height: pointSize,
                  child: Center(
                    child: GestureDetector(
                      child: Text(
                        "${cluster.numPoints}\n${cluster.uuid} ${cluster.parentUuid}",
                        style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.none,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                point: (point) => GestureDetector(
                  onTap: () {
                    final latLng = LatLng(point.originalPoint.latitude,
                        point.originalPoint.longitude);
                    debugPrint('Removing point at $latLng');
                    setState(() {
                      supercluster.remove(point.originalPoint);
                    });
                  },
                  child: Stack(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: pointSize,
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: Text(
                            '${point.uuid}\n${point.parentUuid}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade400,
                                decoration: TextDecoration.none,
                                fontSize: 14,
                                shadows: const [
                                  Shadow(blurRadius: 10, color: Colors.white)
                                ]),
                          )),
                    ],
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

  void insertAt(LatLng latLng) {
    setState(() {
      supercluster.insert(
        TestPoint(
          longitude: latLng.longitude,
          latitude: latLng.latitude,
        ),
      );
    });
  }

  void remove(TestPoint point) {
    setState(() {
      supercluster.remove(point);
    });
  }

  void zoomTo(int zoom) {
    final mapState = MapState.maybeOf(context)!;
    mapState.move(mapState.center, zoom.toDouble(),
        source: MapEventSource.custom);
  }
}
