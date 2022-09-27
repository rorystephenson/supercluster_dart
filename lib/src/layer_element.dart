import 'package:supercluster/src/cluster_data_base.dart';

import 'util.dart' as util;

mixin LayerElement<T> {
  String get uuid;

  int get lowestZoom;

  int get highestZoom;

  double get x;

  double get y;

  TResult handle<TResult extends Object?>({
    required TResult Function(LayerCluster<T> cluster) cluster,
    required TResult Function(LayerPoint<T> point) point,
  });
}

mixin LayerCluster<T> on LayerElement<T> {
  ClusterDataBase? clusterData;

  int get childPointCount;

  double get latitude => util.yLat(y);

  double get longitude => util.xLng(x);
}

mixin LayerPoint<T> on LayerElement<T> {
  T get originalPoint;
}
