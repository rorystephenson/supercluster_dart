import 'dart:math';

import 'package:supercluster/supercluster.dart';
import 'package:timing/timing.dart';

import 'test_point.dart';

void main() {
  var random = Random(42);

  print('Generating test points');
  final testPoints = List<TestPoint>.generate(
    10000,
    (_) => TestPoint(
      longitude: (random.nextDouble() * 360) - 180,
      latitude: (random.nextDouble() * 180) - 90,
    ),
  );

  print('Starting SuperclusterMutable profiling');
  print('Building clusters');
  var tracker = SyncTimeTracker();
  tracker.track(
    () => SuperclusterMutable(
      getX: TestPoint.getX,
      getY: TestPoint.getY,
    )..load(testPoints),
  );
  print('Clusters built, took: ${tracker.duration}');
  print('Finished SuperclusterMutable profiling');

  print('Starting SuperclusterImmutable profiling');
  print('Building clusters');
  tracker = SyncTimeTracker();
  tracker.track(
    () => Supercluster(
      points: testPoints,
      getX: TestPoint.getX,
      getY: TestPoint.getY,
      minPoints: 1,
    ),
  );
  print('Clusters built, took: ${tracker.duration}');
  print('Finished SuperclusterImmutable profiling');
}
