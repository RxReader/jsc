import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/bindings/js_context_ref.dart';
import 'package:jsc/src/bindings/js_object_ref.dart';
import 'package:jsc/src/bindings/js_string_ref.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSGlobalContextCreateWithJSClass', () {
    void testCreate(JSClassRef globalObjectClass) {
      final JSGlobalContextRef globalContext = JSGlobalContextCreate(globalObjectClass);
      try {
        if (kDebugMode) {
          print('globalContext: $globalContext');
        }
        expect(globalContext.address != nullptr.address, true);
      } finally {
        JSGlobalContextRelease(globalContext);
      }
    }

    testCreate(nullptr);

    final JSClassRef clazz = JSClassCreate(JSClassDefinition.allocate(
      0,
      JSClassAttributes.kJSClassAttributeNone,
      'BuildContext'.toNativeUtf8(),
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
      nullptr,
    ));
    try {
      if (kDebugMode) {
        print('clazz: $clazz');
      }
      testCreate(clazz);
    } finally {
      JSClassRelease(clazz);
    }
  });

  test('JSGlobalContextCreateInGroup', () {
    void testCreateInGroup(JSContextGroupRef group) {
      final JSGlobalContextRef globalContext = JSGlobalContextCreateInGroup(group, nullptr);
      try {
        if (kDebugMode) {
          print('globalContext: $globalContext');
        }
        expect(globalContext.address != nullptr.address, true);
      } finally {
        JSGlobalContextRelease(globalContext);
      }
    }

    testCreateInGroup(nullptr);

    final JSContextGroupRef group = JSContextGroupCreate();
    try {
      if (kDebugMode) {
        print('group: $group');
      }
      testCreateInGroup(group);
    } finally {
      JSContextGroupRelease(group);
    }
  });

  test('JSGlobalContextRetain', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSGlobalContextRef globalContextRetain = JSGlobalContextRetain(globalContext);
    try {
      if (kDebugMode) {
        print('globalContext: $globalContext');
        print('globalContextRetain: $globalContextRetain');
      }
      expect(globalContext.address != nullptr.address, true);
      expect(globalContextRetain.address != nullptr.address, true);
      expect(globalContextRetain.address == globalContext.address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSContextGetGlobalObject', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSObjectRef globalThis = JSContextGetGlobalObject(globalContext);
    try {
      if (kDebugMode) {
        print('globalContext: $globalContext');
        print('globalThis: $globalThis');
      }
      expect(globalThis.address != nullptr.address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSContextGetGroup', () {
    void testGetGroup(JSContextGroupRef group) {
      final JSGlobalContextRef globalContext = JSGlobalContextCreateInGroup(group, nullptr);
      final JSContextGroupRef getGroup = JSContextGetGroup(globalContext);
      try {
        if (kDebugMode) {
          print('group: $group');
          print('getGroup: $getGroup');
        }
        expect(getGroup.address == group.address, group.address != nullptr.address);
      } finally {
        JSGlobalContextRelease(globalContext);
      }
    }

    testGetGroup(nullptr);
    final JSContextGroupRef group = JSContextGroupCreate();
    try {
      if (kDebugMode) {
        print('group: $group');
      }
      testGetGroup(group);
    } finally {
      JSContextGroupRelease(group);
    }
  });

  test('JSContextGetGlobalContext', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSGlobalContextRef getGlobalContext = JSContextGetGlobalContext(globalContext);
    try {
      if (kDebugMode) {
        print('globalContext: $globalContext');
        print('getGlobalContext: $getGlobalContext');
      }
      expect(getGlobalContext.address == globalContext.address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSGlobalContextCopyName', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    try {
      final JSStringRef copyName = JSGlobalContextCopyName(globalContext);
      if (kDebugMode) {
        print('name: $copyName');
      }
      expect(copyName.address == nullptr.address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSGlobalContextSetName', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    try {
      JSGlobalContextSetName(globalContext, JSStringCreateWithUTF8CString('globalContext'.toNativeUtf8()));
      final JSStringRef copyName = JSGlobalContextCopyName(globalContext);
      if (kDebugMode) {
        print('name: $copyName');
      }
      final Pointer<JSChar> characters = JSStringGetCharactersPtr(copyName);
      final int charactersLength = JSStringGetLength(copyName);
      final String name = String.fromCharCodes(Uint16List.view(characters.cast<Uint16>().asTypedList(charactersLength).buffer, 0, charactersLength));
      if (kDebugMode) {
        print('name: $name');
      }
      expect(name == 'globalContext', true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });
}
