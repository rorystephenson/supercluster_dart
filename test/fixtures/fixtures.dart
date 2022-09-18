import 'dart:convert';
import 'dart:io';

dynamic _loadFixture(String name) => jsonDecode(
      File('test/fixtures/$name').readAsStringSync(),
    );

class Fixtures {
  Fixtures._();

  static List<Map<String, dynamic>>? _featuresMemo;

  // Avoid loading the fixtures multiple times.
  static List<Map<String, dynamic>> get features {
    if (_featuresMemo != null) return _featuresMemo!;
    _featuresMemo = List<Map<String, dynamic>>.unmodifiable(
        (List.castFrom<dynamic, Map<String, dynamic>>(
            _loadFixture('places.json')['features'])));
    return _featuresMemo!;
  }
}
