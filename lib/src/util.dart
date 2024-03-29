import 'dart:math';

import 'mutable/mutable_layer_element.dart';

double lngX(double lng) {
  return lng / 360 + 0.5;
}

double latY(double lat) {
  final latSin = sin(lat * pi / 180);
  final y = (0.5 - 0.25 * log((1 + latSin) / (1 - latSin)) / pi);
  return y < 0
      ? 0
      : y > 1
          ? 1
          : y;
}

// spherical mercator to longitude/latitude
double xLng(double x) {
  return (x - 0.5) * 360;
}

double yLat(double y) {
  final y2 = (180 - y * 360) * pi / 180;
  return 360 * atan(exp(y2)) / pi - 90;
}

// Squared distance between two points
double distSq(MutableLayerElement a, MutableLayerElement b) {
  var dx = a.x - b.x;
  var dy = a.y - b.y;
  return dx * dx + dy * dy;
}

double searchRadius(int radius, int extent, int zoom) =>
    (radius) / ((extent) * pow(2, zoom));

const int maxInt = 9007199254740991; // 2^53
