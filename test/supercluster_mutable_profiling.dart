import 'dart:math';

import 'package:supercluster/supercluster.dart';
import 'package:timing/timing.dart';

import 'test_point.dart';

void main() {
  final random = Random(42);

  print('Generating test points');
  final testPoints = List<TestPoint>.generate(
    10000,
    (_) => TestPoint(
      longitude: (random.nextDouble() * 360) - 180,
      latitude: (random.nextDouble() * 180) - 90,
    ),
  );

  print('Building clusters');
  final tracker = SyncTimeTracker();
  tracker.track(
    () => SuperclusterMutable(
      getX: TestPoint.getX,
      getY: TestPoint.getY,
    )..load(testPoints),
  );
  print('Clusters built, took: ${tracker.duration}');
}
