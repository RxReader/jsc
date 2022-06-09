import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/bindings/js_value_ref.dart' as js_bd;
import 'package:jsx/src/js_class.dart';
import 'package:jsx/src/js_context.dart';
import 'package:jsx/src/js_error.dart';
import 'package:jsx/src/js_object.dart';
import 'package:jsx/src/js_string.dart';

enum JSType {
  kJSTypeUndefined,
  kJSTypeNull,
  kJSTypeBoolean,
  kJSTypeNumber,
  kJSTypeString,
  kJSTypeObject,
  kJSTypeSymbol, // iOS 13.0
}

// iOS 10.0
enum JSTypedArrayType {
  kJSTypedArrayTypeInt8Array,
  kJSTypedArrayTypeInt16Array,
  kJSTypedArrayTypeInt32Array,
  kJSTypedArrayTypeUint8Array,
  kJSTypedArrayTypeUint8ClampedArray,
  kJSTypedArrayTypeUint16Array,
  kJSTypedArrayTypeUint32Array,
  kJSTypedArrayTypeFloat32Array,
  kJSTypedArrayTypeFloat64Array,
  kJSTypedArrayTypeArrayBuffer,
  kJSTypedArrayTypeNone,
  kJSTypedArrayTypeBigInt64Array,
  kJSTypedArrayTypeBigUint64Array,
}

@immutable
class JSValue {
  const JSValue(JSContext context, JSValueRef ref)
      : _context = context,
        _ref = ref;

  factory JSValue.makeUndefined(JSContext context) {
    return JSValue(context, js_bd.JSValueMakeUndefined(context.ref));
  }

  factory JSValue.makeNull(JSContext context) {
    return JSValue(context, js_bd.JSValueMakeNull(context.ref));
  }

  factory JSValue.makeBoolean(
    JSContext context, {
    required bool boolean,
  }) {
    return JSValue(context, js_bd.JSValueMakeBoolean(context.ref, boolean));
  }

  factory JSValue.makeNumber(
    JSContext context, {
    required double number,
  }) {
    return JSValue(context, js_bd.JSValueMakeNumber(context.ref, number));
  }

  factory JSValue.makeString(
    JSContext context, {
    required String string,
  }) {
    final JSString jsString = JSString.fromString(string);
    try {
      return JSValue(context, js_bd.JSValueMakeString(context.ref, jsString.ref));
    } finally {
      jsString.release();
    }
  }

  // iOS 13.0
  factory JSValue.makeSymbol(
    JSContext context, {
    required String description,
  }) {
    final JSString jsString = JSString.fromString(description);
    try {
      return JSValue(context, js_bd.JSValueMakeSymbol(context.ref, jsString.ref));
    } finally {
      jsString.release();
    }
  }

  factory JSValue.makeFromJSONString(
    JSContext context, {
    required String jsonString,
  }) {
    final JSString jsString = JSString.fromString(jsonString);
    try {
      return JSValue(context, js_bd.JSValueMakeFromJSONString(context.ref, jsString.ref));
    } finally {
      jsString.release();
    }
  }

  final JSContext _context;
  final JSValueRef _ref;

  JSType get type {
    final int type = js_bd.JSValueGetType(_context.ref, _ref);
    return JSType.values[type];
  }

  bool get isUndefined {
    return js_bd.JSValueIsUndefined(_context.ref, _ref);
  }

  bool get isNull {
    return js_bd.JSValueIsNull(_context.ref, _ref);
  }

  bool get isBoolean {
    return js_bd.JSValueIsBoolean(_context.ref, _ref);
  }

  bool get isNumber {
    return js_bd.JSValueIsNumber(_context.ref, _ref);
  }

  bool get isString {
    return js_bd.JSValueIsString(_context.ref, _ref);
  }

  // iOS 13.0
  bool get isSymbol {
    return js_bd.JSValueIsSymbol(_context.ref, _ref);
  }

  bool get isObject {
    return js_bd.JSValueIsObject(_context.ref, _ref);
  }

  bool isObjectOfClass(JSClass clazz) {
    return js_bd.JSValueIsObjectOfClass(_context.ref, _ref, clazz.ref);
  }

  // iOS 9.0
  bool get isArray {
    return js_bd.JSValueIsArray(_context.ref, _ref);
  }

  // iOS 9.0
  bool get isDate {
    return js_bd.JSValueIsDate(_context.ref, _ref);
  }

  bool get isPromise {
    final JSObject func;
    if (_context.globalObject.hasProperty('_flutter_js_inject_isPromise')) {
      func = _context.globalObject.getProperty('_flutter_js_inject_isPromise').object;
    } else {
      func = JSObject.makeFunction(
        _context,
        parameterNames: <String>['v'],
        body: '''
        var t = typeof v;
        if(t === 'object'){
          return v instanceof Promise;
        }
        return false;
        ''',
      );
      _context.globalObject.setProperty('_flutter_js_inject_isPromise', func.value);
    }
    final JSValue result = func.callAsFunction(arguments: <JSValue>[this]);
    return result.isBoolean && result.boolean;
  }

  bool get isError {
    final JSObject func;
    if (_context.globalObject.hasProperty('_flutter_js_inject_isError')) {
      func = _context.globalObject.getProperty('_flutter_js_inject_isError').object;
    } else {
      func = JSObject.makeFunction(
        _context,
        parameterNames: <String>['v'],
        body: '''
        var t = typeof v;
        if(t === 'object'){
          return v instanceof Error;
        }
        return false;
        ''',
      );
      _context.globalObject.setProperty('_flutter_js_inject_isError', func.value);
    }
    final JSValue result = func.callAsFunction(arguments: <JSValue>[this]);
    return result.isBoolean && result.boolean;
  }

  bool get isRegExp {
    final JSObject func;
    if (_context.globalObject.hasProperty('_flutter_js_inject_isRegExp')) {
      func = _context.globalObject.getProperty('_flutter_js_inject_isRegExp').object;
    } else {
      func = JSObject.makeFunction(
        _context,
        parameterNames: <String>['v'],
        body: '''
        var t = typeof v;
        if(t === 'object'){
          return v instanceof RegExp;
        }
        return false;
        ''',
      );
      _context.globalObject.setProperty('_flutter_js_inject_isRegExp', func.value);
    }
    final JSValue result = func.callAsFunction(arguments: <JSValue>[this]);
    return result.isBoolean && result.boolean;
  }

  // iOS 10.0
  JSTypedArrayType get typedArrayType {
    final JSException exception = JSException.create(_context);
    try {
      final int type = js_bd.JSValueGetTypedArrayType(_context.ref, _ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSTypedArrayType.values[type];
    } finally {
      exception.release();
    }
  }

  bool isEqual(JSValue other) {
    final JSException exception = JSException.create(_context);
    try {
      final bool result = js_bd.JSValueIsEqual(_context.ref, _ref, other.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return result;
    } finally {
      exception.release();
    }
  }

  bool isInstanceOfConstructor(JSObject constructor) {
    final JSException exception = JSException.create(_context);
    try {
      final bool result = js_bd.JSValueIsInstanceOfConstructor(_context.ref, _ref, constructor.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return result;
    } finally {
      exception.release();
    }
  }

  String? get jsonString {
    final JSString string = createJSONString(indent: 0);
    try {
      return string.string;
    } finally {
      string.release();
    }
  }

  JSString createJSONString({
    int indent = 2,
  }) {
    final JSException exception = JSException.create(_context);
    try {
      final JSStringRef stringRef = js_bd.JSValueCreateJSONString(_context.ref, _ref, indent, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSString(stringRef);
    } finally {
      exception.release();
    }
  }

  bool get boolean {
    return js_bd.JSValueToBoolean(_context.ref, _ref);
  }

  double get number {
    final JSException exception = JSException.create(_context);
    try {
      final double result = js_bd.JSValueToNumber(_context.ref, _ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return result;
    } finally {
      exception.release();
    }
  }

  String? get string {
    final JSString string = stringCopy;
    try {
      return string.string;
    } finally {
      string.release();
    }
  }

  JSString get stringCopy {
    final JSException exception = JSException.create(_context);
    try {
      final JSStringRef stringRef = js_bd.JSValueToStringCopy(_context.ref, _ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSString(stringRef);
    } finally {
      exception.release();
    }
  }

  JSObject get object {
    final JSException exception = JSException.create(_context);
    try {
      final JSObjectRef objectRef = js_bd.JSValueToObject(_context.ref, _ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSObject(_context, objectRef);
    } finally {
      exception.release();
    }
  }

  void protect() {
    js_bd.JSValueProtect(_context.ref, _ref);
  }

  void unprotect() {
    js_bd.JSValueUnprotect(_context.ref, _ref);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSValue && runtimeType == other.runtimeType && js_bd.JSValueIsStrictEqual(_context.ref, ref, other.ref);

  @override
  int get hashCode => _context.hashCode ^ _ref.hashCode;

  @override
  String toString() {
    return string ?? 'JSValue{context: $_context, ref: $_ref}';
  }
}

extension JSValueExtension on JSValue {
  JSValueRef get ref => _ref;
}

extension JSValueIterable on Iterable<JSValue> {
  Pointer<JSValueRef> get ref {
    final Pointer<JSValueRef> result = calloc.call(length);
    for (int i = 0; i < length; i++) {
      result[i] = elementAt(i).ref;
    }
    return result;
  }
}

class JSValueConverter {
  const JSValueConverter._();

  static List<JSValue> toJSValues(JSContext context, int count, Pointer<JSValueRef> values) {
    return List<JSValue>.generate(count, (int index) {
      return JSValue(context, values[index]);
    });
  }
}

class JSException {
  const JSException(JSContext context, Pointer<JSValueRef> ref)
      : _context = context,
        _ref = ref;

  factory JSException.create(JSContext context, [JSValue? error]) {
    final Pointer<JSValueRef> ref = calloc.call(1);
    ref.value = error?.ref ?? nullptr;
    return JSException(context, ref);
  }

  final JSContext _context;
  final Pointer<JSValueRef> _ref;

  void invoke(JSObject error) {
    _ref.value = error.value.ref;
  }

  bool get shouldThrow {
    return _ref[0] != nullptr;
  }

  JSError get error {
    assert(shouldThrow);
    final JSValue exceptionValue = JSValue(_context, _ref[0]);
    final JSObject object = exceptionValue.object;
    if (exceptionValue.isError) {
      final JSValue message = object.getProperty('message');
      final JSValue stack = object.getProperty('stack');
      final JSValue name = object.getProperty('name');
      final String? stackString = stack.string;
      return JSError(name.string, message.string ?? '', stackString != null ? StackTrace.fromString(stackString) : null);
    } else {
      return JSError(null, object.value.string ?? '');
    }
  }

  void release() {
    calloc.free(_ref);
  }

  @override
  String toString() {
    return error.toString();
  }
}

extension JSExceptionExtension on JSException {
  Pointer<JSValueRef> get ref => _ref;
}
