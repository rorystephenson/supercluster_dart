import 'dart:io';
import 'dart:math';

import 'package:quiver/iterables.dart';
import 'package:supercluster/supercluster.dart';
import 'package:timing/timing.dart';

import '../test/test_point.dart';

// Seed random number generator so that test data is the same across runs.
final random = Random(42);

// Create test data.
final testPoints = List<TestPoint>.unmodifiable(
  List<TestPoint>.generate(
    10000,
    (_) => TestPoint(
      longitude: (random.nextDouble() * 360) - 180,
      latitude: (random.nextDouble() * 180) - 90,
    ),
  ),
);
final testPointsSet = testPoints.toSet();

final first9000 = List<TestPoint>.unmodifiable(testPoints.sublist(0, 9000));
final last1000 = List<TestPoint>.unmodifiable(testPoints.sublist(9000, 10000));
final groupsOf1000 =
    partition(testPoints, 1000).map(List<TestPoint>.unmodifiable);

void main() {
  var result = withPrintedOutput(
    'SuperclusterImmutable load 10,000',
    () => SuperclusterImmutable(
      getX: TestPoint.getX,
      getY: TestPoint.getY,
    )..load(testPoints),
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable load 10,000',
    () => SuperclusterMutable(
      getX: TestPoint.getX,
      getY: TestPoint.getY,
    )..load(testPoints),
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable load 9000, add 1000',
    () {
      final supercluster = SuperclusterMutable(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
      )..load(first9000);
      for (final point in last1000) {
        supercluster.add(point);
      }
      return supercluster;
    },
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable addAll 10,000',
    () => SuperclusterMutable(
      getX: TestPoint.getX,
      getY: TestPoint.getY,
    )..addAll(testPoints),
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable addAll 10 x 1000',
    () {
      final supercluster = SuperclusterMutable(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
      );
      for (final groupOf1000 in groupsOf1000) {
        supercluster.addAll(groupOf1000);
      }
      return supercluster;
    },
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable load 10,000, remove 1000',
    () {
      final supercluster = SuperclusterMutable(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
      )..load(testPoints);
      for (final point in last1000) {
        supercluster.remove(point);
      }
      return supercluster;
    },
  );
  throwUnlessContainsPoints(result, first9000);

  result = withPrintedOutput(
    'SuperclusterMutable removeAll 10,000',
    () {
      return SuperclusterMutable(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
      )
        ..load(testPoints)
        ..removeAll(testPoints);
    },
  );
  throwUnlessContainsPoints(result, []);

  result = withPrintedOutput(
    'SuperclusterMutable removeAll 10 x 1000',
    () {
      final supercluster = SuperclusterMutable(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
      )..load(testPoints);
      for (final groupOf1000 in groupsOf1000) {
        supercluster.removeAll(groupOf1000);
      }
      return supercluster;
    },
  );
  throwUnlessContainsPoints(result, []);
}

Supercluster<TestPoint> withPrintedOutput(
  String benchmarkName,
  Supercluster<TestPoint> Function() benchmark,
) {
  stdout.write('Starting $benchmarkName benchmark...');
  final tracker = SyncTimeTracker();
  final result = tracker.track(benchmark);
  stdout.write(' took: ${tracker.duration}\n');
  return result;
}

void throwUnlessContainsAllPoints(Supercluster<TestPoint> supercluster) {
  final containedPoints = supercluster.getLeaves().toSet();
  if (containedPoints.length != testPoints.length ||
      containedPoints.difference(testPointsSet).isNotEmpty) {
    throw 'Supercluster only contains ${containedPoints.length}/${testPointsSet.length} points';
  }
}

void throwUnlessContainsPoints(
  Supercluster<TestPoint> supercluster,
  Iterable<TestPoint> expectedPoints,
) {
  final expectedPointsSet = expectedPoints.toSet();
  final containedPoints = supercluster.getLeaves().toSet();
  if (containedPoints.length != expectedPoints.length ||
      containedPoints.difference(expectedPointsSet).isNotEmpty) {
    throw 'Supercluster only contains ${containedPoints.length}/${expectedPointsSet.length} points';
  }
}
