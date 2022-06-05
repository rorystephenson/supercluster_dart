import 'dart:math';

import 'package:supercluster/supercluster.dart';

void main() {
  final supercluster =
      Supercluster<Point<double>>(getX: (p) => p.x, getY: (p) => p.y);
  supercluster.load([
    Point(1.5, 46),
    Point(0.9, 46.4),
    Point(10, 45),
  ]);

  // Lat is N/S
  final clustersAndPoints = supercluster
      .getClustersAndPoints(0.0, 43, 8, 47, 10)
      .map((e) => '(${e.x}, ${e.y})');
  print('result: ${clustersAndPoints.join(', ')}');
}
