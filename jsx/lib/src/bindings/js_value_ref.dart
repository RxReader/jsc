import 'dart:ffi';

import 'package:jsx/src/bindings/dylib.dart';
import 'package:jsx/src/bindings/js_base.dart';

/// A constant identifying the type of a JSValue.
class JSType {
  const JSType._();

  /// The unique undefined value.
  static const int kJSTypeUndefined = 0;

  /// The unique null value.
  static const int kJSTypeNull = 1;

  /// A primitive boolean value, one of true or false.
  static const int kJSTypeBoolean = 2;

  /// A primitive number value.
  static const int kJSTypeNumber = 3;

  /// A primitive string value.
  static const int kJSTypeString = 4;

  /// An object value (meaning that this JSValueRef is a JSObjectRef).
  static const int kJSTypeObject = 5;

  /// MacOS 10.15, iOS 13.0
  /// A primitive symbol value.
  static const int kJSTypeSymbol = 6;
}

/// MacOS 10.12, iOS 10.0
/// A constant identifying the Typed Array type of a JSObjectRef.
class JSTypedArrayType {
  const JSTypedArrayType._();

  /// Int8Array
  static const int kJSTypedArrayTypeInt8Array = 0;

  /// Int16Array
  static const int kJSTypedArrayTypeInt16Array = 1;

  /// Int32Array
  static const int kJSTypedArrayTypeInt32Array = 2;

  /// Uint8Array
  static const int kJSTypedArrayTypeUint8Array = 3;

  /// Uint8ClampedArray
  static const int kJSTypedArrayTypeUint8ClampedArray = 4;

  /// Uint16Array
  static const int kJSTypedArrayTypeUint16Array = 5;

  /// Uint32Array
  static const int kJSTypedArrayTypeUint32Array = 6;

  /// Float32Array
  static const int kJSTypedArrayTypeFloat32Array = 7;

  /// Float64Array
  static const int kJSTypedArrayTypeFloat64Array = 8;

  /// ArrayBuffer
  static const int kJSTypedArrayTypeArrayBuffer = 9;

  /// Not a Typed Array
  static const int kJSTypedArrayTypeNone = 10;

  /// BigInt64Array
  static const int kJSTypedArrayTypeBigInt64Array = 11;

  /// BigUint64Array
  static const int kJSTypedArrayTypeBigUint64Array = 12;
}

/// Returns a JavaScript value's type.
/// [ctx] The execution context to use.
/// [value] The JSValue whose type you want to obtain.
/// [@result] A value of type JSType that identifies value's type.
final int /*JSType*/ Function(JSContextRef ctx, JSValueRef value) JSValueGetType =
    jscLib.lookup<NativeFunction<Uint32 /*JSType*/ Function(JSContextRef ctx, JSValueRef value)>>('JSValueGetType').asFunction();

/// Tests whether a JavaScript value's type is the undefined type.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value's type is the undefined type, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsUndefined = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsUndefined').asFunction();

/// Tests whether a JavaScript value's type is the null type.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value's type is the null type, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsNull = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsNull').asFunction();

/// Tests whether a JavaScript value's type is the boolean type.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value's type is the boolean type, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsBoolean = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsBoolean').asFunction();

/// Tests whether a JavaScript value's type is the number type.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value's type is the number type, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsNumber = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsNumber').asFunction();

/// Tests whether a JavaScript value's type is the string type.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value's type is the string type, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsString = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsString').asFunction();

/// MacOS 10.15, iOS 13.0
/// Tests whether a JavaScript value's type is the symbol type.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value's type is the symbol type, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsSymbol = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsSymbol').asFunction();

/// Tests whether a JavaScript value's type is the object type.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value's type is the object type, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsObject = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsObject').asFunction();

/// Tests whether a JavaScript value is an object with a given class in its class chain.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [jsClass] The JSClass to test against.
/// [@result] true if value is an object and has jsClass in its class chain, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value, JSClassRef jsClass) JSValueIsObjectOfClass =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value, JSClassRef jsClass)>>('JSValueIsObjectOfClass').asFunction();

/// MacOS 10.11, iOS 9.0
/// Tests whether a JavaScript value is an array.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value is an array, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsArray = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsArray').asFunction();

/// MacOS 10.11, iOS 9.0
/// Tests whether a JavaScript value is a date.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [@result] true if value is a date, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueIsDate = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueIsDate').asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns a JavaScript value's Typed Array type.
/// [ctx] The execution context to use.
/// [value] The JSValue whose Typed Array type to return.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A value of type JSTypedArrayType that identifies value's Typed Array type, or kJSTypedArrayTypeNone if the value is not a Typed Array object.
final int /*JSTypedArrayType*/ Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception) JSValueGetTypedArrayType =
    jscLib.lookup<NativeFunction<Uint32 /*JSTypedArrayType*/ Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception)>>('JSValueGetTypedArrayType').asFunction();

/* Comparing values */

/// Tests whether two JavaScript values are equal, as compared by the JS == operator.
/// [ctx] The execution context to use.
/// [a] The first value to test.
/// [b] The second value to test.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] true if the two values are equal, false if they are not equal or an exception is thrown.
final bool Function(JSContextRef ctx, JSValueRef a, JSValueRef b, Pointer<JSValueRef> exception) JSValueIsEqual =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef a, JSValueRef b, Pointer<JSValueRef> exception)>>('JSValueIsEqual').asFunction();

/// Tests whether two JavaScript values are strict equal, as compared by the JS === operator.
/// [ctx] The execution context to use.
/// [a] The first value to test.
/// [b] The second value to test.
/// [@result] true if the two values are strict equal, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef a, JSValueRef b) JSValueIsStrictEqual =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef a, JSValueRef b)>>('JSValueIsStrictEqual').asFunction();

/// Tests whether a JavaScript value is an object constructed by a given constructor, as compared by the JS instanceof operator.
/// [ctx] The execution context to use.
/// [value] The JSValue to test.
/// [constructor] The constructor to test against.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] true if value is an object constructed by constructor, as compared by the JS instanceof operator, otherwise false.
final bool Function(JSContextRef ctx, JSValueRef value, JSObjectRef constructor, Pointer<JSValueRef> exception) JSValueIsInstanceOfConstructor =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value, JSObjectRef constructor, Pointer<JSValueRef> exception)>>('JSValueIsInstanceOfConstructor').asFunction();

/* Creating values */

/// Creates a JavaScript value of the undefined type.
/// [ctx] The execution context to use.
/// [@result] The unique undefined value.
final JSValueRef Function(JSContextRef ctx) JSValueMakeUndefined = jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx)>>('JSValueMakeUndefined').asFunction();

/// Creates a JavaScript value of the null type.
/// [ctx] The execution context to use.
/// [@result] The unique null value.
final JSValueRef Function(JSContextRef ctx) JSValueMakeNull = jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx)>>('JSValueMakeNull').asFunction();

/// Creates a JavaScript value of the boolean type.
/// [ctx] The execution context to use.
/// [boolean] The bool to assign to the newly created JSValue.
/// [@result] A JSValue of the boolean type, representing the value of boolean.
final JSValueRef Function(JSContextRef ctx, bool boolean) JSValueMakeBoolean = jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, Bool boolean)>>('JSValueMakeBoolean').asFunction();

/// Creates a JavaScript value of the number type.
/// [ctx] The execution context to use.
/// [number] The double to assign to the newly created JSValue.
/// [@result] A JSValue of the number type, representing the value of number.
final JSValueRef Function(JSContextRef ctx, double number) JSValueMakeNumber = jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, Double number)>>('JSValueMakeNumber').asFunction();

/// Creates a JavaScript value of the string type.
/// [ctx] The execution context to use.
/// [string] The JSString to assign to the newly created JSValue. The
/// newly created JSValue retains string, and releases it upon garbage collection.
/// [@result] A JSValue of the string type, representing the value of string.
final JSValueRef Function(JSContextRef ctx, JSStringRef string) JSValueMakeString =
    jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSStringRef string)>>('JSValueMakeString').asFunction();

/// MacOS 10.15, iOS 13.0
/// Creates a JavaScript value of the symbol type.
/// [ctx] The execution context to use.
/// [description] A description of the newly created symbol value.
/// [@result] A unique JSValue of the symbol type, whose description matches the one provided.
final JSValueRef Function(JSContextRef ctx, JSStringRef description) JSValueMakeSymbol =
    jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSStringRef description)>>('JSValueMakeSymbol').asFunction();

/* Converting to and from JSON formatted strings */

/// Creates a JavaScript value from a JSON formatted string.
/// [ctx] The execution context to use.
/// [string] The JSString containing the JSON string to be parsed.
/// [@result] A JSValue containing the parsed value, or NULL if the input is invalid.
final JSValueRef Function(JSContextRef ctx, JSStringRef string) JSValueMakeFromJSONString =
    jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSStringRef string)>>('JSValueMakeFromJSONString').asFunction();

/// Creates a JavaScript string containing the JSON serialized representation of a JS value.
/// [ctx] The execution context to use.
/// [value] The value to serialize.
/// [indent] The number of spaces to indent when nesting.  If 0, the resulting JSON will not contains newlines.  The size of the indent is clamped to 10 spaces.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSString with the result of serialization, or NULL if an exception is thrown.
final JSStringRef Function(JSContextRef ctx, JSValueRef value, int indent, Pointer<JSValueRef> exception) JSValueCreateJSONString =
    jscLib.lookup<NativeFunction<JSStringRef Function(JSContextRef ctx, JSValueRef value, Uint32 indent, Pointer<JSValueRef> exception)>>('JSValueCreateJSONString').asFunction();

/* Converting to primitive values */

/// Converts a JavaScript value to boolean and returns the resulting boolean.
/// [ctx] The execution context to use.
/// [value] The JSValue to convert.
/// [@result] The boolean result of conversion.
final bool Function(JSContextRef ctx, JSValueRef value) JSValueToBoolean = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSValueRef value)>>('JSValueToBoolean').asFunction();

/// Converts a JavaScript value to number and returns the resulting number.
/// [ctx] The execution context to use.
/// [value] The JSValue to convert.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The numeric result of conversion, or NaN if an exception is thrown.
/// JS_EXPORT double JSValueToNumber(JSContextRef ctx, JSValueRef value, JSValueRef* exception);
final double Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception) JSValueToNumber =
    jscLib.lookup<NativeFunction<Double Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception)>>('JSValueToNumber').asFunction();

/// Converts a JavaScript value to string and copies the result into a JavaScript string.
/// [ctx] The execution context to use.
/// [value] The JSValue to convert.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSString with the result of conversion, or NULL if an exception is thrown. Ownership follows the Create Rule.
final JSStringRef Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception) JSValueToStringCopy =
    jscLib.lookup<NativeFunction<JSStringRef Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception)>>('JSValueToStringCopy').asFunction();

/// Converts a JavaScript value to object and returns the resulting object.
/// [ctx] The execution context to use.
/// [value] The JSValue to convert.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The JSObject result of conversion, or NULL if an exception is thrown.
final JSObjectRef Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception) JSValueToObject =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, JSValueRef value, Pointer<JSValueRef> exception)>>('JSValueToObject').asFunction();

/* Garbage collection */

/// Protects a JavaScript value from garbage collection.
/// [ctx] The execution context to use.
/// [value] The JSValue to protect.
/// [@discussion] Use this method when you want to store a JSValue in a global or on the heap, where the garbage collector will not be able to discover your reference to it.
///
/// A value may be protected multiple times and must be unprotected an equal number of times before becoming eligible for garbage collection.
final void Function(JSContextRef ctx, JSValueRef value) JSValueProtect = jscLib.lookup<NativeFunction<Void Function(JSContextRef ctx, JSValueRef value)>>('JSValueProtect').asFunction();

/// Unprotects a JavaScript value from garbage collection.
/// [ctx] The execution context to use.
/// [value] The JSValue to unprotect.
/// [@discussion] A value may be protected multiple times and must be unprotected an equal number of times before becoming eligible for garbage collection.
/// JS_EXPORT void JSValueUnprotect(JSContextRef ctx, JSValueRef value);
final void Function(JSContextRef ctx, JSValueRef value) JSValueUnprotect = jscLib.lookup<NativeFunction<Void Function(JSContextRef ctx, JSValueRef value)>>('JSValueUnprotect').asFunction();
