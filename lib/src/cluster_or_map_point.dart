import 'package:supercluster/src/cluster.dart';
import 'package:supercluster/src/map_point.dart';

class ClusterOrMapPoint {
  final Cluster? cluster;
  final MapPoint? mapPoint;

  ClusterOrMapPoint.cluster(this.cluster) : mapPoint = null;

  ClusterOrMapPoint.mapPoint(this.mapPoint) : cluster = null;

  T handle<T>({
    required T Function(Cluster) cluster,
    required T Function(MapPoint) mapPoint,
  }) {
    return this.cluster != null
        ? cluster(this.cluster!)
        : mapPoint(this.mapPoint!);
  }

  double get x => handle(
        cluster: (cluster) => cluster.x,
        mapPoint: (mapPoint) => mapPoint.x,
      );

  double get y => handle(
        cluster: (cluster) => cluster.y,
        mapPoint: (mapPoint) => mapPoint.y,
      );

  int get parentId => handle(
        cluster: (cluster) => cluster.parentId,
        mapPoint: (mapPoint) => mapPoint.parentId,
      );

  int get zoom => handle(
        cluster: (cluster) => cluster.zoom,
        mapPoint: (mapPoint) => mapPoint.zoom,
      );

  set zoom(int newZoom) {
    if (cluster != null) {
      cluster!.zoom = newZoom;
    } else {
      mapPoint!.zoom = newZoom;
    }
  }

  set parentId(int newParentId) {
    if (cluster != null) {
      cluster!.parentId = newParentId;
    } else {
      mapPoint!.parentId = newParentId;
    }
  }

  int get numPoints => cluster?.numPoints ?? 1;

  static double getX(ClusterOrMapPoint clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(ClusterOrMapPoint clusterOrMapPoint) =>
      clusterOrMapPoint.y;
}
