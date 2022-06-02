import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jsc/src/core/js_context.dart';
import 'package:jsc/src/core/js_value.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSValue.makeUndefined', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    expect(JSValue.makeUndefined(globalContext), JSValue.makeUndefined(globalContext));
    globalContext.release();
  });
  test('JSValue.makeNull', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    expect(JSValue.makeNull(globalContext), JSValue.makeNull(globalContext));
    globalContext.release();
  });
  test('JSValue.makeBoolean', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    expect(JSValue.makeBoolean(globalContext, boolean: true), JSValue.makeBoolean(globalContext, boolean: true));
    expect(JSValue.makeBoolean(globalContext, boolean: false), JSValue.makeBoolean(globalContext, boolean: false));
    expect(JSValue.makeBoolean(globalContext, boolean: true) != JSValue.makeBoolean(globalContext, boolean: false), true);
    globalContext.release();
  });
  test('JSValue.makeNumber', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    expect(JSValue.makeNumber(globalContext, number: 1), JSValue.makeNumber(globalContext, number: 1));
    expect(JSValue.makeNumber(globalContext, number: 1) != JSValue.makeNumber(globalContext, number: 2), true);
    globalContext.release();
  });
  test('JSValue.makeString', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSValue value = JSValue.makeString(globalContext, string: '123');
    expect(value.isString, true);
    expect(value.string, '123');
    globalContext.release();
  });
  test('JSValue.makeFromJSONString', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSValue value = JSValue.makeFromJSONString(globalContext, jsonString: '{"abc": "xyz"}');
    expect(value.object.hasProperty('abc'), true);
    expect(value.object.getProperty('abc').string, 'xyz');
    globalContext.release();
  });
}
