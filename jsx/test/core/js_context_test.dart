import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsx/src/js_context.dart';
import 'package:jsx/src/js_context_group.dart';
import 'package:jsx/src/js_value.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSGlobalContext.create', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSGlobalContext globalContextRetain = globalContext.retain();
    globalContext.setName('abc');
    expect(globalContext.copyName(), 'abc');
    expect(globalContext, globalContextRetain);
    globalContext.release();
    globalContextRetain.release();
  });
  test('JSGlobalContext.createInGroup', () {
    final JSContextGroup group = JSContextGroup.create();
    final JSGlobalContext globalContext = JSGlobalContext.createInGroup(
      group: group,
    );
    expect(globalContext.group, group);
    expect(globalContext.globalContext, globalContext);
    final JSValue value = globalContext.evaluate('Math.trunc(Math.random() * 100).toString();');
    if (kDebugMode) {
      print(value.string);
    }
    expect(value.isString, true);
    globalContext.release();
    group.release();
  });
}
