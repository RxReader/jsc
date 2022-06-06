import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/bindings/js_context_ref.dart';
import 'package:jsx/src/bindings/js_object_ref.dart';
import 'package:jsx/src/bindings/js_string_ref.dart';
import 'package:jsx/src/bindings/js_value_ref.dart';

JSValueRef _kNewLine_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception) {
  return JSValueMakeString(ctx, JSStringCreateWithUTF8CString('\n'.toNativeUtf8()));
}

JSValueRef _toDBC_callAsFunction(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) {
  assert(argumentCount == 1);
  final JSValueRef text = arguments[0];
  assert(JSValueIsString(ctx, text));
  final JSStringRef stringCopy = JSValueToStringCopy(ctx, text, exception);
  final Pointer<JSChar> characters = JSStringGetCharactersPtr(stringCopy);
  final int charactersLength = JSStringGetLength(stringCopy);
  final String string = String.fromCharCodes(Uint16List.view(characters.cast<Uint16>().asTypedList(charactersLength).buffer, 0, charactersLength));
  return JSValueMakeString(ctx, JSStringCreateWithUTF8CString(_toDBC(string).toNativeUtf8()));
}

/// 全角转换为半角
/// 空格: 全角 - 半角
/// '\u3000' - '\u0020'
String _toDBC(String text) {
  return String.fromCharCodes(text.codeUnits.map((int element) {
    // 全角空格
    if (element == 12288) {
      return 32;
    }
    // 65281-65374
    if (element > 65280 && element < 65375) {
      return element - 65248;
    }
    return element;
  }));
}

/// 半角转换为全角
String _toSBC(String text) {
  return String.fromCharCodes(text.codeUnits.map((int element) {
    // 半角空格
    if (element == 32) {
      return 12288;
    }
    // 33-126
    if (element > 32 && element < 127) {
      return element + 65248;
    }
    return element;
  }));
}

JSObjectRef _anonymous_Constructor(JSContextRef ctx, JSObjectRef constructor, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) {
  return nullptr;
}

void main() {
  assert(Platform.isMacOS);
  test('JSClassCreate', () {
    final JSClassRef clazz = JSClassCreate(JSClassDefinition.allocate(
      0,
      JSClassAttributes.kJSClassAttributeNone,
      'TextSymbol'.toNativeUtf8(),
      nullptr,
      JSStaticValue.allocateArray(<JSStaticValueDelegate>[
        JSStaticValueDelegate(
          'kNewLine'.toNativeUtf8(),
          Pointer.fromFunction(_kNewLine_getProperty),
          nullptr,
          JSPropertyAttributes.kJSPropertyAttributeReadOnly,
        ),
      ]),
      // nullptr,
      JSStaticFunction.allocateArray(<JSStaticFunctionDelegate>[
        JSStaticFunctionDelegate(
          'toDBC'.toNativeUtf8(),
          Pointer.fromFunction(_toDBC_callAsFunction),
          JSPropertyAttributes.kJSPropertyAttributeReadOnly,
        ),
      ]),
      // nullptr,
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
      expect(clazz.address != nullptr.address, true);
    } finally {
      JSClassRelease(clazz);
    }
  });

  test('JSClassRetain', () {
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
    final JSClassRef clazzRetain = JSClassRetain(clazz);
    try {
      if (kDebugMode) {
        print('clazz: $clazz');
        print('clazzRetain: $clazzRetain');
      }
      expect(clazz.address != nullptr.address, true);
      expect(clazzRetain.address != nullptr.address, true);
      expect(clazzRetain.address == clazz.address, true);
    } finally {
      JSClassRelease(clazz);
    }
  });

  test('JSObjectMakeWithData', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSObjectRef object = JSObjectMake(globalContext, nullptr, nullptr);
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      expect(object.address != nullptr.address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSObjectMakeFunctionWithCallback', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSObjectRef object = JSObjectMakeFunctionWithCallback(globalContext, JSStringCreateWithUTF8CString('toDBC'.toNativeUtf8()), Pointer.fromFunction(_toDBC_callAsFunction));
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      expect(JSObjectIsFunction(globalContext, object), true);
      final Pointer<JSValueRef> arguments = calloc.call(1);
      arguments[0] = JSValueMakeString(globalContext, JSStringCreateWithUTF8CString(_toSBC('4').toNativeUtf8()));
      final JSValueRef result = JSObjectCallAsFunction(globalContext, object, nullptr, 1, arguments, nullptr);
      if (kDebugMode) {
        print('result: $result');
      }
      expect(JSValueIsString(globalContext, result), true);
      final JSStringRef string = JSValueToStringCopy(globalContext, result, nullptr);
      final Pointer<JSChar> characters = JSStringGetCharactersPtr(string);
      final int charactersLength = JSStringGetLength(string);
      final String dbc = String.fromCharCodes(Uint16List.view(characters.cast<Uint16>().asTypedList(charactersLength).buffer, 0, charactersLength));
      if (kDebugMode) {
        print('dbc: $dbc');
      }
      expect(dbc == _toDBC(_toSBC('4')), true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSObjectMakeConstructor', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSObjectRef object = JSObjectMakeConstructor(globalContext, nullptr, Pointer.fromFunction(_anonymous_Constructor));
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      expect(JSObjectIsConstructor(globalContext, object), true);
      final JSObjectRef result = JSObjectCallAsConstructor(globalContext, object, 0, nullptr, nullptr);
      if (kDebugMode) {
        print('result: $result');
      }
      expect(result.address == nullptr.address, true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSObjectMakeArray', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final Pointer<JSValueRef> arguments = calloc.call(2);
    arguments[0] = JSValueMakeString(globalContext, JSStringCreateWithUTF8CString('abc'.toNativeUtf8()));
    arguments[1] = JSValueMakeString(globalContext, JSStringCreateWithUTF8CString('123'.toNativeUtf8()));
    final JSObjectRef object = JSObjectMakeArray(globalContext, 2, arguments, nullptr);
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      final JSValueRef value = object.cast();
      expect(JSValueIsArray(globalContext, value), true);
      final JSStringRef string = JSValueCreateJSONString(globalContext, value, 0, nullptr);
      final Pointer<JSChar> characters = JSStringGetCharactersPtr(string);
      final int charactersLength = JSStringGetLength(string);
      final String result = String.fromCharCodes(Uint16List.view(characters.cast<Uint16>().asTypedList(charactersLength).buffer, 0, charactersLength));
      if (kDebugMode) {
        print('result: $result');
      }
      final List<String> list = (json.decode(result) as List<dynamic>).cast();
      expect(list[0] == 'abc', true);
      expect(list[1] == '123', true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSObjectMakeDate', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final DateTime now = DateTime.now();
    final Pointer<JSValueRef> arguments = calloc.call(2);
    arguments[0] = JSValueMakeNumber(globalContext, now.millisecondsSinceEpoch.toDouble());
    final JSObjectRef object = JSObjectMakeDate(globalContext, 1, arguments, nullptr);
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      final JSValueRef value = object.cast();
      expect(JSValueIsDate(globalContext, value), true);
      if (kDebugMode) {
        print('value: ${JSValueToNumber(globalContext, value, nullptr)} - ${now.millisecondsSinceEpoch.toDouble()}');
      }
      expect(JSValueToNumber(globalContext, value, nullptr) == now.millisecondsSinceEpoch.toDouble(), true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSObjectMakeError', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSObjectRef object = JSObjectMakeError(globalContext, 0, nullptr, nullptr);
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      final JSValueRef value = object.cast();
      expect(JSValueIsObject(globalContext, value), true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSObjectMakeRegExp', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSObjectRef object = JSObjectMakeRegExp(globalContext, 0, nullptr, nullptr);
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      final JSValueRef value = object.cast();
      expect(JSValueIsObject(globalContext, value), true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });

  test('JSObjectMakeDeferredPromise', () {
    final JSGlobalContextRef globalContext = JSGlobalContextCreate(nullptr);
    final JSObjectRef object = JSObjectMakeDeferredPromise(globalContext, nullptr, nullptr, nullptr);
    try {
      if (kDebugMode) {
        print('object: $object');
      }
      final JSValueRef value = object.cast();
      expect(JSValueIsObject(globalContext, value), true);
      final JSObjectRef objectXyz = JSValueToObject(globalContext, value, nullptr);
      expect(JSObjectHasProperty(globalContext, objectXyz, JSStringCreateWithUTF8CString('then'.toNativeUtf8())), true);
      expect(JSObjectHasProperty(globalContext, objectXyz, JSStringCreateWithUTF8CString('catch'.toNativeUtf8())), true);
    } finally {
      JSGlobalContextRelease(globalContext);
    }
  });
}
