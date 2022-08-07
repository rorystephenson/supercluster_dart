// longitude/latitude to spherical mercator in [0..1] range
import 'dart:math';

import 'mutable_cluster_or_point.dart';

double lngX(lng) {
  return lng / 360 + 0.5;
}

double latY(lat) {
  final latSin = sin(lat * pi / 180);
  final y = (0.5 - 0.25 * log((1 + latSin) / (1 - latSin)) / pi);
  return y < 0
      ? 0
      : y > 1
          ? 1
          : y;
}

// spherical mercator to longitude/latitude
double xLng(x) {
  return (x - 0.5) * 360;
}

double yLat(y) {
  final y2 = (180 - y * 360) * pi / 180;
  return 360 * atan(exp(y2)) / pi - 90;
}

// TODO: Make the distance measure customisable e.g. haversine
// squared distance between two points
double distSq(MutableClusterOrPoint a, MutableClusterOrPoint b) {
  var dx = a.wX - b.wX;
  var dy = a.wY - b.wY;
  return dx * dx + dy * dy;
}

const int maxInt = 9007199254740991; // 2^53
