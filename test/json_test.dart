// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.
library json_test;

import 'dart:convert';
import 'package:protobuf/protobuf.dart' as protobuf;
import 'package:test/test.dart';

import 'mock_util.dart' show T;

main() {
  T example = new T()
    ..val = 123
    ..str = "hello"
    ..int32s.addAll(<int>[1, 2, 3]);

  test('testWriteToJson', () {
    String json = example.writeToJson();
    checkJsonMap(jsonDecode(json));
  });

  test('testWriteFrozenToJson', () {
    final frozen = example.clone()..freeze();
    final json = frozen.writeToJson();
    checkJsonMap(jsonDecode(json));
  });

  test('writeToJsonMap', () {
    Map m = example.writeToJsonMap();
    checkJsonMap(m);
  });

  test('testMergeFromJson', () {
    var t = new T();
    t.mergeFromJson('''{"1": 123, "2": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonMap', () {
    var t = new T();
    t.mergeFromJsonMap({"1": 123, "2": "hello"});
    checkMessage(t);
  });

  test('testWriteToJsonProto3', () {
    String json = example.writeToProto3Json();
    checkJsonMapProto3(jsonDecode(json));
  });

  test('writeToJsonMapProto3', () {
    Map m = example.writeToProto3JsonMap();
    checkJsonMapProto3(m);
  });

  test('testMergeFromJsonProto3', () {
    var t = new T();
    t.mergeFromProto3Json('''{"val": 123, "str": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonMapProto3', () {
    var t = new T();
    t.mergeFromProto3JsonMap({"val": 123, "str": "hello"});
    checkMessage(t);
  });
}

checkJsonMap(Map m) {
  expect(m.length, 3);
  expect(m["1"], 123);
  expect(m["2"], "hello");
  print(m.toString());
  expect(m["4"], [1, 2, 3]);
}

checkMessage(T t) {
  expect(t.val, 123);
  expect(t.str, "hello");
}

checkJsonMapProto3(Map m) {
  expect(m.length, 2);
  expect(m["val"], 123);
  expect(m["str"], "hello");
}
