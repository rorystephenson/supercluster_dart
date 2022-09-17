import 'dart:convert';
import 'dart:io';

dynamic loadFixture(String name) => jsonDecode(
      File('test/fixtures/$name').readAsStringSync(),
    );

final features = List.castFrom<dynamic, Map<String, dynamic>>(
    loadFixture('places.json')['features']);
