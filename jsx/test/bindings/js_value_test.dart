import 'dart:ffi';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/bindings/js_context_ref.dart';
import 'package:jsx/src/bindings/js_value_ref.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSValueMakeUndefined', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    try {
      final JSValueRef value = JSValueMakeUndefined(globalContext);
      expect(JSValueIsUndefined(globalContext, value), true);
      expect(JSValueMakeUndefined(globalContext).address == JSValueMakeUndefined(globalContext).address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });
  test('JSValueMakeNull', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    try {
      final JSValueRef value = JSValueMakeNull(globalContext);
      expect(JSValueIsNull(globalContext, value), true);
      expect(JSValueMakeNull(globalContext).address == JSValueMakeNull(globalContext).address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });
  test('JSValueMakeBoolean', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    try {
      final JSValueRef value = JSValueMakeBoolean(globalContext, true);
      expect(JSValueIsBoolean(globalContext, value), true);
      expect(JSValueToBoolean(globalContext, value) == true, true);
      expect(JSValueMakeBoolean(globalContext, true).address == JSValueMakeBoolean(globalContext, true).address, true);
      expect(JSValueMakeBoolean(globalContext, false).address == JSValueMakeBoolean(globalContext, false).address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });
}
