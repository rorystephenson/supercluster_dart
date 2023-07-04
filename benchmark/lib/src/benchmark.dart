import 'dart:io';
import 'dart:math';

import 'package:quiver/iterables.dart';
import 'package:supercluster/supercluster.dart';
import 'package:timing/timing.dart';

// Seed random number generator so that test data is the same across runs.
final random = Random(42);

double getX((double, double) point) => point.$2;
double getY((double, double) point) => point.$1;

// Create test data.
final testPoints = List<(double, double)>.unmodifiable(
  List<(double, double)>.generate(
    10000,
    (_) => (
      (random.nextDouble() * 360) - 180,
      (random.nextDouble() * 180) - 90,
    ),
  ),
);
final testPointsSet = testPoints.toSet();

final first9000 =
    List<(double, double)>.unmodifiable(testPoints.sublist(0, 9000));
final last1000 =
    List<(double, double)>.unmodifiable(testPoints.sublist(9000, 10000));
final groupsOf1000 =
    partition(testPoints, 1000).map(List<(double, double)>.unmodifiable);

void main() {
  var result = withPrintedOutput(
    'SuperclusterImmutable load 10,000',
    () => SuperclusterImmutable(
      getX: getX,
      getY: getY,
    )..load(testPoints),
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable load 10,000',
    () => SuperclusterMutable(
      getX: getX,
      getY: getY,
    )..load(testPoints),
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable load 9000, add 1000',
    () {
      final supercluster = SuperclusterMutable(
        getX: getX,
        getY: getY,
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
      getX: getX,
      getY: getY,
    )..addAll(testPoints),
  );
  throwUnlessContainsAllPoints(result);

  result = withPrintedOutput(
    'SuperclusterMutable addAll 10 x 1000',
    () {
      final supercluster = SuperclusterMutable(
        getX: getX,
        getY: getY,
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
        getX: getX,
        getY: getY,
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
        getX: getX,
        getY: getY,
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
        getX: getX,
        getY: getY,
      )..load(testPoints);
      for (final groupOf1000 in groupsOf1000) {
        supercluster.removeAll(groupOf1000);
      }
      return supercluster;
    },
  );
  throwUnlessContainsPoints(result, []);
}

Supercluster<(double, double)> withPrintedOutput(
  String benchmarkName,
  Supercluster<(double, double)> Function() benchmark,
) {
  stdout.write('Starting $benchmarkName benchmark...');
  final tracker = SyncTimeTracker();
  final result = tracker.track(benchmark);
  stdout.write(' took: ${tracker.duration}\n');
  return result;
}

void throwUnlessContainsAllPoints(Supercluster<(double, double)> supercluster) {
  final containedPoints = supercluster.getLeaves().toSet();
  if (containedPoints.length != testPoints.length ||
      containedPoints.difference(testPointsSet).isNotEmpty) {
    throw 'Supercluster only contains ${containedPoints.length}/${testPointsSet.length} points';
  }
}

void throwUnlessContainsPoints(
  Supercluster<(double, double)> supercluster,
  Iterable<(double, double)> expectedPoints,
) {
  final expectedPointsSet = expectedPoints.toSet();
  final containedPoints = supercluster.getLeaves().toSet();
  if (containedPoints.length != expectedPoints.length ||
      containedPoints.difference(expectedPointsSet).isNotEmpty) {
    throw 'Supercluster only contains ${containedPoints.length}/${expectedPointsSet.length} points';
  }
}
