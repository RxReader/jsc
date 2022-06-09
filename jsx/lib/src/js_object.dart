import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:jsx/src/bindings/js_base.dart' hide JSTypedArrayBytesDeallocator;
import 'package:jsx/src/bindings/js_base.dart' as js_bd show JSTypedArrayBytesDeallocator;
import 'package:jsx/src/bindings/js_object_ref.dart' as js_bd;
import 'package:jsx/src/bindings/js_typed_array.dart' as js_bd;
import 'package:jsx/src/js_class.dart';
import 'package:jsx/src/js_context.dart';
import 'package:jsx/src/js_property_name_accumulator.dart';
import 'package:jsx/src/js_property_name_array.dart';
import 'package:jsx/src/js_string.dart';
import 'package:jsx/src/js_typed_array.dart';
import 'package:jsx/src/js_value.dart';

enum JSPropertyAttributes {
  kJSPropertyAttributeNone,
  kJSPropertyAttributeReadOnly,
  kJSPropertyAttributeDontEnum,
  kJSPropertyAttributeDontDelete,
}

enum JSClassAttributes {
  kJSClassAttributeNone,
  kJSClassAttributeNoAutomaticPrototype,
}

void convertJSObjectInitializeCallback(
  JSContextRef ctx,
  JSObjectRef object,
  void Function(JSContext context, JSObject object) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, object));
}

// void convertJSObjectFinalizeCallback(JSObjectRef object, void Function(JSObjectRef object) fn) {
//   return fn(object);
// }

bool convertJSObjectHasPropertyCallback(
  JSContextRef ctx,
  JSObjectRef object,
  JSStringRef propertyName,
  bool Function(JSContext context, JSObject object, JSString propertyName) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, object), JSString(propertyName));
}

JSValueRef convertJSObjectGetPropertyCallback(
  JSContextRef ctx,
  JSObjectRef object,
  JSStringRef propertyName,
  Pointer<JSValueRef> exception,
  JSValue Function(JSContext context, JSObject object, JSString propertyName, JSException exception) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, object), JSString(propertyName), JSException(context, exception)).ref;
}

bool convertJSObjectSetPropertyCallback(
  JSContextRef ctx,
  JSObjectRef object,
  JSStringRef propertyName,
  JSValueRef value,
  Pointer<JSValueRef> exception,
  bool Function(JSContext context, JSObject object, JSString propertyName, JSValue value, JSException exception) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, object), JSString(propertyName), JSValue(context, value), JSException(context, exception));
}

bool convertJSObjectDeletePropertyCallback(
  JSContextRef ctx,
  JSObjectRef object,
  JSStringRef propertyName,
  Pointer<JSValueRef> exception,
  bool Function(JSContext context, JSObject object, JSString propertyName, JSException exception) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, object), JSString(propertyName), JSException(context, exception));
}

void convertJSObjectGetPropertyNamesCallback(
  JSContextRef ctx,
  JSObjectRef object,
  JSPropertyNameAccumulatorRef propertyNames,
  void Function(JSContext context, JSObject object, JSPropertyNameAccumulator propertyNames) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, object), JSPropertyNameAccumulator(propertyNames));
}

JSValueRef convertJSObjectCallAsFunctionCallback(
  JSContextRef ctx,
  JSObjectRef function,
  JSObjectRef thisObject,
  int argumentCount,
  Pointer<JSValueRef> arguments,
  Pointer<JSValueRef> exception,
  JSValue Function(JSContext context, JSObject function, JSObject thisObject, List<JSValue> arguments, JSException exception) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, function), JSObject(context, thisObject), JSValueConverter.toJSValues(context, argumentCount, arguments), JSException(context, exception)).ref;
}

JSObjectRef convertJSObjectCallAsConstructorCallback(
  JSContextRef ctx,
  JSObjectRef constructor,
  int argumentCount,
  Pointer<JSValueRef> arguments,
  Pointer<JSValueRef> exception,
  JSObject Function(JSContext context, JSObject constructor, List<JSValue> arguments, JSException exception) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, constructor), JSValueConverter.toJSValues(context, argumentCount, arguments), JSException(context, exception)).ref;
}

bool convertJSObjectHasInstanceCallback(
  JSContextRef ctx,
  JSObjectRef constructor,
  JSValueRef possibleInstance,
  Pointer<JSValueRef> exception,
  bool Function(JSContext context, JSObject constructor, JSValue possibleInstance, JSException exception) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, constructor), JSValue(context, possibleInstance), JSException(context, exception));
}

JSValueRef convertJSObjectConvertToTypeCallback(
  JSContextRef ctx,
  JSObjectRef object,
  int /*JSType*/ type,
  Pointer<JSValueRef> exception,
  JSValue Function(JSContext context, JSObject object, JSType type, JSException exception) fn,
) {
  final JSContext context = JSContext(ctx);
  return fn(context, JSObject(context, object), JSType.values[type], JSException(context, exception)).ref;
}

// void convertJSTypedArrayBytesDeallocator(Pointer<Void> bytes, Pointer<Void> deallocatorContext, void Function(Pointer<Void> bytes, Pointer<Void> deallocatorContext) fn) {
//   return fn(bytes, deallocatorContext);
// }

class JSStaticValue {
  const JSStaticValue(
    this.name, {
    this.getProperty,
    this.setProperty,
    this.attributes = JSPropertyAttributes.kJSPropertyAttributeNone,
  });

  final String name;
  final Pointer<NativeFunction<js_bd.JSObjectGetPropertyCallback>>? getProperty;
  final Pointer<NativeFunction<js_bd.JSObjectSetPropertyCallback>>? setProperty;
  final JSPropertyAttributes attributes;
}

extension JSStaticValueDelegate on JSStaticValue {
  js_bd.JSStaticValueDelegate toDelegate() {
    return js_bd.JSStaticValueDelegate(
      name.toNativeUtf8(),
      getProperty,
      setProperty,
      JSPropertyAttributes.values.indexOf(attributes),
    );
  }
}

extension JSStaticValueExtension on JSStaticValue {
  Pointer<js_bd.JSStaticValue> get ref {
    return js_bd.JSStaticValue.allocate(toDelegate());
  }
}

extension JSStaticValueIterable on Iterable<JSStaticValue> {
  Pointer<js_bd.JSStaticValue> get ref {
    return js_bd.JSStaticValue.allocateArray(map((JSStaticValue element) => element.toDelegate()));
  }
}

class JSStaticFunction {
  const JSStaticFunction(
    this.name, {
    this.callAsFunction,
    this.attributes = JSPropertyAttributes.kJSPropertyAttributeNone,
  });

  final String name;
  final Pointer<NativeFunction<js_bd.JSObjectCallAsFunctionCallback>>? callAsFunction;
  final JSPropertyAttributes attributes;
}

extension JSStaticFunctionDelegate on JSStaticFunction {
  js_bd.JSStaticFunctionDelegate toDelegate() {
    return js_bd.JSStaticFunctionDelegate(
      name.toNativeUtf8(),
      callAsFunction,
      JSPropertyAttributes.values.indexOf(attributes),
    );
  }
}

extension JSStaticFunctionExtension on JSStaticFunction {
  Pointer<js_bd.JSStaticFunction> get ref {
    return js_bd.JSStaticFunction.allocate(toDelegate());
  }
}

extension JSStaticFunctionIterable on Iterable<JSStaticFunction> {
  Pointer<js_bd.JSStaticFunction> get ref {
    return js_bd.JSStaticFunction.allocateArray(map((JSStaticFunction element) => element.toDelegate()));
  }
}

class JSClassDefinition {
  const JSClassDefinition(
    Pointer<js_bd.JSClassDefinition> ref,
    Pointer<js_bd.JSStaticValue>? staticValuesRef,
    Pointer<js_bd.JSStaticFunction>? staticFunctionsRef,
  )   : _ref = ref,
        _staticValuesRef = staticValuesRef,
        _staticFunctionsRef = staticFunctionsRef;

  factory JSClassDefinition.create({
    int version = 0,
    JSClassAttributes attributes = JSClassAttributes.kJSClassAttributeNone,
    required String className,
    JSClass? parentClass,
    List<JSStaticValue>? staticValues,
    List<JSStaticFunction>? staticFunctions,
    Pointer<NativeFunction<js_bd.JSObjectInitializeCallback>>? initialize,
    Pointer<NativeFunction<js_bd.JSObjectFinalizeCallback>>? finalize,
    Pointer<NativeFunction<js_bd.JSObjectHasPropertyCallback>>? hasProperty,
    Pointer<NativeFunction<js_bd.JSObjectGetPropertyCallback>>? getProperty,
    Pointer<NativeFunction<js_bd.JSObjectSetPropertyCallback>>? setProperty,
    Pointer<NativeFunction<js_bd.JSObjectDeletePropertyCallback>>? deleteProperty,
    Pointer<NativeFunction<js_bd.JSObjectGetPropertyNamesCallback>>? getPropertyNames,
    Pointer<NativeFunction<js_bd.JSObjectCallAsFunctionCallback>>? callAsFunction,
    Pointer<NativeFunction<js_bd.JSObjectCallAsConstructorCallback>>? callAsConstructor,
    Pointer<NativeFunction<js_bd.JSObjectHasInstanceCallback>>? hasInstance,
    Pointer<NativeFunction<js_bd.JSObjectConvertToTypeCallback>>? convertToType,
  }) {
    final Pointer<js_bd.JSStaticValue>? staticValuesRef = staticValues?.ref;
    final Pointer<js_bd.JSStaticFunction>? staticFunctionsRef = staticFunctions?.ref;
    return JSClassDefinition(
      js_bd.JSClassDefinition.allocate(
        version,
        JSClassAttributes.values.indexOf(attributes),
        className.toNativeUtf8(),
        parentClass?.ref ?? nullptr,
        staticValuesRef ?? nullptr,
        staticFunctionsRef ?? nullptr,
        initialize ?? nullptr,
        finalize ?? nullptr,
        hasProperty ?? nullptr,
        getProperty ?? nullptr,
        setProperty ?? nullptr,
        deleteProperty ?? nullptr,
        getPropertyNames ?? nullptr,
        callAsFunction ?? nullptr,
        callAsConstructor ?? nullptr,
        hasInstance ?? nullptr,
        convertToType ?? nullptr,
      ),
      staticValuesRef,
      staticFunctionsRef,
    );
  }

  final Pointer<js_bd.JSClassDefinition> _ref;
  final Pointer<js_bd.JSStaticValue>? _staticValuesRef;
  final Pointer<js_bd.JSStaticFunction>? _staticFunctionsRef;

  void release() {
    if (_staticValuesRef != null) {
      calloc.free(_staticValuesRef!);
    }
    if (_staticFunctionsRef != null) {
      calloc.free(_staticFunctionsRef!);
    }
    calloc.free(_ref);
  }
}

extension JSClassDefinitionExtension on JSClassDefinition {
  Pointer<js_bd.JSClassDefinition> get ref => _ref;
}

@immutable
class JSObject {
  const JSObject(JSContext context, JSObjectRef ref)
      : _context = context,
        _ref = ref;

  factory JSObject.make(
    JSContext context, {
    JSClass? clazz,
    Pointer<Void>? data,
  }) {
    return JSObject(
      context,
      js_bd.JSObjectMake(context.ref, clazz?.ref ?? nullptr, data ?? nullptr),
    );
  }

  factory JSObject.makeFunctionWithCallback(
    JSContext context, {
    String? name,
    Pointer<NativeFunction<js_bd.JSObjectCallAsFunctionCallback>>? callAsFunction,
  }) {
    final JSString? jsName = name != null ? JSString.fromString(name) : null;
    try {
      return JSObject(
        context,
        js_bd.JSObjectMakeFunctionWithCallback(
          context.ref,
          jsName?.ref ?? nullptr,
          callAsFunction ?? nullptr,
        ),
      );
    } finally {
      jsName?.release();
    }
  }

  factory JSObject.makeConstructor(
    JSContext context, {
    JSClass? clazz,
    Pointer<NativeFunction<js_bd.JSObjectCallAsConstructorCallback>>? callAsConstructor,
  }) {
    return JSObject(
      context,
      js_bd.JSObjectMakeConstructor(
        context.ref,
        clazz?.ref ?? nullptr,
        callAsConstructor ?? nullptr,
      ),
    );
  }

  factory JSObject.makeArray(
    JSContext context, {
    List<JSValue>? arguments,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(context, js_bd.JSObjectMakeArray(context.ref, arguments?.length ?? 0, arguments?.ref ?? nullptr, exception.ref));
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeDate(
    JSContext context, {
    List<JSValue>? arguments,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(context, js_bd.JSObjectMakeDate(context.ref, arguments?.length ?? 0, arguments?.ref ?? nullptr, exception.ref));
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeError(
    JSContext context, {
    List<JSValue>? arguments,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(context, js_bd.JSObjectMakeError(context.ref, arguments?.length ?? 0, arguments?.ref ?? nullptr, exception.ref));
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeRegExp(
    JSContext context, {
    List<JSValue>? arguments,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(context, js_bd.JSObjectMakeRegExp(context.ref, arguments?.length ?? 0, arguments?.ref ?? nullptr, exception.ref));
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeDeferredPromise(
    JSContext context, {
    JSResolve? resolve,
    JSReject? reject,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(context, js_bd.JSObjectMakeDeferredPromise(context.ref, resolve?.ref ?? nullptr, reject?.ref ?? nullptr, exception.ref));
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeFunction(
    JSContext context, {
    String? name,
    List<String>? parameterNames,
    required String body,
    String? sourceURL,
    int startingLineNumber = 1,
  }) {
    final JSException exception = JSException.create(context);
    final JSString? jsName = name != null ? JSString.fromString(name) : null;
    final List<JSString>? jsParameterNames = parameterNames?.map((String element) => JSString.fromString(element)).toList();
    final JSString jsBody = JSString.fromString(body);
    final JSString? jsSourceURL = sourceURL != null ? JSString.fromString(sourceURL) : null;
    try {
      final JSObject object = JSObject(
        context,
        js_bd.JSObjectMakeFunction(
          context.ref,
          jsName?.ref ?? nullptr,
          jsParameterNames?.length ?? 0,
          jsParameterNames?.ref ?? nullptr,
          jsBody.ref,
          jsSourceURL?.ref ?? nullptr,
          startingLineNumber,
          exception.ref,
        ),
      );
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      jsSourceURL?.release();
      jsBody.release();
      jsParameterNames?.release();
      jsName?.release();
      exception.release();
    }
  }

  factory JSObject.makeTypedArray(
    JSContext context, {
    required JSTypedArrayType arrayType,
    required int length,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(context, js_bd.JSObjectMakeTypedArray(context.ref, JSTypedArrayType.values.indexOf(arrayType), length, exception.ref));
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeTypedArrayWithBytesNoCopy(
    JSContext context, {
    required JSTypedArrayType arrayType,
    required JSTypedArrayBytes bytes,
    Pointer<NativeFunction<js_bd.JSTypedArrayBytesDeallocator>>? bytesDeallocator,
    required Pointer<Void> deallocatorContext,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(
        context,
        js_bd.JSObjectMakeTypedArrayWithBytesNoCopy(
          context.ref,
          JSTypedArrayType.values.indexOf(arrayType),
          bytes.bytes,
          bytes.length,
          bytesDeallocator ?? nullptr,
          deallocatorContext,
          exception.ref,
        ),
      );
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeTypedArrayWithArrayBuffer(
    JSContext context, {
    required JSTypedArrayType arrayType,
    required JSObject buffer,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(context, js_bd.JSObjectMakeTypedArrayWithArrayBuffer(context.ref, JSTypedArrayType.values.indexOf(arrayType), buffer.ref, exception.ref));
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeTypedArrayWithArrayBufferAndOffset(
    JSContext context, {
    required JSTypedArrayType arrayType,
    required JSObject buffer,
    required int byteOffset,
    required int length,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(
        context,
        js_bd.JSObjectMakeTypedArrayWithArrayBufferAndOffset(
          context.ref,
          JSTypedArrayType.values.indexOf(arrayType),
          buffer.ref,
          byteOffset,
          length,
          exception.ref,
        ),
      );
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  factory JSObject.makeArrayBufferWithBytesNoCopy(
    JSContext context, {
    required JSTypedArrayBytes bytes,
    Pointer<NativeFunction<js_bd.JSTypedArrayBytesDeallocator>>? bytesDeallocator,
    required Pointer<Void> deallocatorContext,
  }) {
    final JSException exception = JSException.create(context);
    try {
      final JSObject object = JSObject(
        context,
        js_bd.JSObjectMakeArrayBufferWithBytesNoCopy(
          context.ref,
          bytes.bytes,
          bytes.length,
          bytesDeallocator ?? nullptr,
          deallocatorContext,
          exception.ref,
        ),
      );
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return object;
    } finally {
      exception.release();
    }
  }

  //

  final JSContext _context;
  final JSObjectRef _ref;

  JSValue get prototype {
    return JSValue(_context, js_bd.JSObjectGetPrototype(_context.ref, _ref));
  }

  set prototype(JSValue value) {
    js_bd.JSObjectSetPrototype(_context.ref, _ref, value.ref);
  }

  bool hasProperty(String propertyName) {
    final JSString jsPropertyName = JSString.fromString(propertyName);
    try {
      return js_bd.JSObjectHasProperty(_context.ref, _ref, jsPropertyName.ref);
    } finally {
      jsPropertyName.release();
    }
  }

  JSValue getProperty(String propertyName) {
    final JSException exception = JSException.create(_context);
    final JSString jsPropertyName = JSString.fromString(propertyName);
    try {
      final JSValueRef valueRef = js_bd.JSObjectGetProperty(_context.ref, _ref, jsPropertyName.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSValue(_context, valueRef);
    } finally {
      jsPropertyName.release();
      exception.release();
    }
  }

  void setProperty(String propertyName, JSValue? value, {JSPropertyAttributes attributes = JSPropertyAttributes.kJSPropertyAttributeNone}) {
    final JSException exception = JSException.create(_context);
    final JSString jsPropertyName = JSString.fromString(propertyName);
    try {
      js_bd.JSObjectSetProperty(_context.ref, _ref, jsPropertyName.ref, value?.ref ?? nullptr, JSPropertyAttributes.values.indexOf(attributes), exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
    } finally {
      jsPropertyName.release();
      exception.release();
    }
  }

  bool deleteProperty(String propertyName) {
    final JSException exception = JSException.create(_context);
    final JSString jsPropertyName = JSString.fromString(propertyName);
    try {
      final bool result = js_bd.JSObjectDeleteProperty(_context.ref, _ref, jsPropertyName.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return result;
    } finally {
      jsPropertyName.release();
      exception.release();
    }
  }

  // iOS 13.0
  bool hasPropertyForKey(JSValue propertyKey) {
    final JSException exception = JSException.create(_context);
    try {
      final bool result = js_bd.JSObjectHasPropertyForKey(_context.ref, _ref, propertyKey.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return result;
    } finally {
      exception.release();
    }
  }

  // iOS 13.0
  JSValue getPropertyForKey(JSValue propertyKey) {
    final JSException exception = JSException.create(_context);
    try {
      final JSValueRef valueRef = js_bd.JSObjectGetPropertyForKey(_context.ref, _ref, propertyKey.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSValue(_context, valueRef);
    } finally {
      exception.release();
    }
  }

  // iOS 13.0
  void setPropertyForKey(JSValue propertyKey, JSValue? value, {JSPropertyAttributes attributes = JSPropertyAttributes.kJSPropertyAttributeNone}) {
    final JSException exception = JSException.create(_context);
    try {
      js_bd.JSObjectSetPropertyForKey(_context.ref, _ref, propertyKey.ref, value?.ref ?? nullptr, JSPropertyAttributes.values.indexOf(attributes), exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
    } finally {
      exception.release();
    }
  }

  // iOS 13.0
  void deletePropertyForKey(JSValue propertyKey) {
    final JSException exception = JSException.create(_context);
    try {
      js_bd.JSObjectDeletePropertyForKey(_context.ref, _ref, propertyKey.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
    } finally {
      exception.release();
    }
  }

  JSValue getPropertyAtIndex(int propertyIndex) {
    final JSException exception = JSException.create(_context);
    try {
      final JSValueRef valueRef = js_bd.JSObjectGetPropertyAtIndex(_context.ref, _ref, propertyIndex, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSValue(_context, valueRef);
    } finally {
      exception.release();
    }
  }

  void setPropertyAtIndex(int propertyIndex, JSValue value) {
    final JSException exception = JSException.create(_context);
    try {
      js_bd.JSObjectSetPropertyAtIndex(_context.ref, _ref, propertyIndex, value.ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
    } finally {
      exception.release();
    }
  }

  Pointer<Void> getPrivate() {
    return js_bd.JSObjectGetPrivate(_ref);
  }

  bool setPrivate(Pointer<Void> data) {
    return js_bd.JSObjectSetPrivate(_ref, data);
  }

  bool get isFunction {
    return js_bd.JSObjectIsFunction(_context.ref, _ref);
  }

  JSValue callAsFunction({JSObject? thisObject, List<JSValue>? arguments}) {
    final JSException exception = JSException.create(_context);
    try {
      final JSValueRef valueRef = js_bd.JSObjectCallAsFunction(_context.ref, _ref, thisObject?.ref ?? nullptr, arguments?.length ?? 0, arguments?.ref ?? nullptr, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSValue(_context, valueRef);
    } finally {
      exception.release();
    }
  }

  bool get isConstructor {
    return js_bd.JSObjectIsConstructor(_context.ref, _ref);
  }

  JSObject callAsConstructor({List<JSValue>? arguments}) {
    final JSException exception = JSException.create(_context);
    final JSObjectRef objectRef = js_bd.JSObjectCallAsConstructor(_context.ref, _ref, arguments?.length ?? 0, arguments?.ref ?? nullptr, exception.ref);
    if (exception.shouldThrow) {
      throw exception.error;
    }
    return JSObject(_context, objectRef);
  }

  JSPropertyNameArray copyPropertyNames() {
    return JSPropertyNameArray(js_bd.JSObjectCopyPropertyNames(_context.ref, _ref));
  }

  JSTypedArrayBytes get typedArrayBytes {
    final JSException exception1 = JSException.create(_context);
    final JSException exception2 = JSException.create(_context);
    try {
      final Pointer<Void> bytes = js_bd.JSObjectGetTypedArrayBytesPtr(_context.ref, _ref, exception1.ref);
      if (exception1.shouldThrow) {
        throw exception1.error;
      }
      final int length = js_bd.JSObjectGetTypedArrayLength(_context.ref, _ref, exception2.ref);
      if (exception2.shouldThrow) {
        throw exception2.error;
      }
      return JSTypedArrayBytes(bytes, length);
    } finally {
      exception2.release();
      exception1.release();
    }
  }

  int get typedArrayByteLength {
    final JSException exception = JSException.create(_context);
    try {
      final int length = js_bd.JSObjectGetTypedArrayByteLength(_context.ref, _ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return length;
    } finally {
      exception.release();
    }
  }

  int get typedArrayByteOffset {
    final JSException exception = JSException.create(_context);
    try {
      final int offset = js_bd.JSObjectGetTypedArrayByteOffset(_context.ref, _ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return offset;
    } finally {
      exception.release();
    }
  }

  JSObject get typedArrayBuffer {
    final JSException exception = JSException.create(_context);
    try {
      final JSObjectRef objectRef = js_bd.JSObjectGetTypedArrayBuffer(_context.ref, _ref, exception.ref);
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSObject(_context, objectRef);
    } finally {
      exception.release();
    }
  }

  JSTypedArrayBytes get arrayBufferBytes {
    final JSException exception1 = JSException.create(_context);
    final JSException exception2 = JSException.create(_context);
    try {
      final Pointer<Void> bytes = js_bd.JSObjectGetArrayBufferBytesPtr(_context.ref, _ref, exception1.ref);
      if (exception1.shouldThrow) {
        throw exception1.error;
      }
      final int length = js_bd.JSObjectGetArrayBufferByteLength(_context.ref, _ref, exception2.ref);
      if (exception2.shouldThrow) {
        throw exception2.error;
      }
      return JSTypedArrayBytes(bytes, length);
    } finally {
      exception2.release();
      exception1.release();
    }
  }

  JSValue get value {
    return JSValue(_context, _ref.cast());
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSObject && runtimeType == other.runtimeType && _context == other._context && _ref == other._ref;

  @override
  int get hashCode => _context.hashCode ^ _ref.hashCode;

  @override
  String toString() {
    final String? string = !isFunction && !isConstructor ? value.string : null;
    return string ?? 'JSObject{context: $_context, ref: $_ref}';
  }
}

extension JSObjectExtension on JSObject {
  JSObjectRef get ref => _ref;
}

class JSResolve {
  const JSResolve(Pointer<JSObjectRef> ref) : _ref = ref;

  factory JSResolve.create([JSObject? resolve]) {
    final Pointer<JSValueRef> ref = calloc.call(1);
    ref.value = resolve?.ref ?? nullptr;
    return JSResolve(ref);
  }

  final Pointer<JSObjectRef> _ref;

  void invoke(JSObject result) {
    _ref.value = result.ref;
  }

  void release() {
    calloc.free(_ref);
  }
}

extension JSResolveExtension on JSResolve {
  Pointer<JSObjectRef> get ref => _ref;
}

class JSReject {
  const JSReject(Pointer<JSObjectRef> ref) : _ref = ref;

  factory JSReject.create([JSObject? reject]) {
    final Pointer<JSValueRef> ref = calloc.call(1);
    ref.value = reject?.ref ?? nullptr;
    return JSReject(ref);
  }

  final Pointer<JSObjectRef> _ref;

  void invoke(JSObject error) {
    _ref.value = error.ref;
  }

  void release() {
    calloc.free(_ref);
  }
}

extension JSRejectExtension on JSReject {
  Pointer<JSObjectRef> get ref => _ref;
}
