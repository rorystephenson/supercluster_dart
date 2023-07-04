import 'package:supercluster/src/mutable/supercluster_mutable.dart';
import 'package:test/test.dart';

import 'fixtures/osm_dense_data.dart';
import 'validate_mutable_supercluster.dart';

void main() {
  /// This is a test for convenience when running this from an IDE.
  ///
  /// Paste a long list of elements in [elements] below and then make sure
  /// the supercluster config matches that of the failing supercluster. When
  /// run a minimal test case will be calculated. The [verify] function can be
  /// customised to validate that the supercluster is correct. It should throw
  /// if there is problem.
  test('reduce failure case', () {
    int removals = 0;
    SuperclusterMutable<(double, double)> createSupercluster() {
      removals = 0;
      return SuperclusterMutable<(double, double)>(
        getX: (p) => p.$2,
        getY: (p) => p.$1,
      )..load(osmDenseData);
    }

    void action(
      SuperclusterMutable<(double, double)> supercluster,
      (double, double) element,
    ) {
      supercluster.remove(element);
      removals++;
    }

    var elements = List.from(osmDenseData); //<(double lat, double lon)>[];

    void verify(SuperclusterMutable<(double, double)> supercluster) {
      validateMutableSupercluster(
        supercluster,
        expectedPoints: osmDenseData.length - removals,
      );
    }

    final originalLength = elements.length;
    print('Beginning binary search...');

    bool failedAtLeastOnce = false;
    int removeCount = osmDenseData.length ~/ 2;
    do {
      final supercluster = createSupercluster();

      final reducedElements = elements.sublist(0, removeCount);
      print('Trying with ${reducedElements.length} elements...');

      for (int j = 0; j < reducedElements.length; j++) {
        try {
          action(supercluster, reducedElements[j]);
          verify(supercluster);
        } catch (e) {
          elements = reducedElements;
          failedAtLeastOnce = true;
          print('${elements.length}/$originalLength');
          break;
        }
      }
      removeCount ~/= 2;
    } while (removeCount > 0);

    print('Beginning linear search...');
    bool failed;
    do {
      failed = false;

      for (int i = 0; i < elements.length; i++) {
        final supercluster = createSupercluster();

        final reducedElements = List<(double, double)>.from(elements)
          ..removeAt(i);

        for (int j = 0; j < reducedElements.length; j++) {
          try {
            action(supercluster, reducedElements[j]);
            verify(supercluster);
          } catch (e) {
            elements = reducedElements;
            failed = true;
            failedAtLeastOnce = true;
            print('${elements.length}/$originalLength');
            break;
          }
        }
        if (failed) break;
      }
    } while (failed);

    if (!failedAtLeastOnce) throw 'Never failed';

    print('\n[');
    for (final element in elements) {
      print('  $element,\n');
    }
    print(']');
  });
}
