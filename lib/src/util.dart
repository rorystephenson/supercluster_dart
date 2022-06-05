// longitude/latitude to spherical mercator in [0..1] range
import 'dart:math';

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
