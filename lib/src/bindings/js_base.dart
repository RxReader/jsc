import 'dart:ffi';

import 'package:jsc/src/bindings/dylib.dart';

/* JavaScript engine interface */

class OpaqueJSContextGroup extends Opaque {}

/// JSContextGroupRef A group that associates JavaScript contexts with one another. Contexts in the same group may share and exchange JavaScript objects.
typedef JSContextGroupRef = Pointer<OpaqueJSContextGroup>;

class OpaqueJSContext extends Opaque {}

/// JSContextRef A JavaScript execution context. Holds the global object and other execution state.
typedef JSContextRef = Pointer<OpaqueJSContext>;

/// JSGlobalContextRef A global JavaScript execution context. A JSGlobalContext is a JSContext.
typedef JSGlobalContextRef = JSContextRef; // Pointer<OpaqueJSContext>;

class OpaqueJSString extends Opaque {}

/// JSStringRef A UTF16 character buffer. The fundamental string representation in JavaScript.
typedef JSStringRef = Pointer<OpaqueJSString>;

class OpaqueJSClass extends Opaque {}

/// JSClassRef A JavaScript class. Used with JSObjectMake to construct objects with custom behavior.
typedef JSClassRef = Pointer<OpaqueJSClass>;

class OpaqueJSPropertyNameArray extends Opaque {}

/// JSPropertyNameArrayRef An array of JavaScript property names.
typedef JSPropertyNameArrayRef = Pointer<OpaqueJSPropertyNameArray>;

class OpaqueJSPropertyNameAccumulator extends Opaque {}

/// JSPropertyNameAccumulatorRef An ordered set used to collect the names of a JavaScript object's properties.
typedef JSPropertyNameAccumulatorRef = Pointer<OpaqueJSPropertyNameAccumulator>;

/// JSTypedArrayBytesDeallocator A function used to deallocate bytes passed to a Typed Array constructor. The function should take two arguments. The first is a pointer to the bytes that were originally passed to the Typed Array constructor. The second is a pointer to additional information desired at the time the bytes are to be freed.
///
/// typedef void (*JSTypedArrayBytesDeallocator)(void* bytes, void* deallocatorContext);
typedef JSTypedArrayBytesDeallocator = Void Function(Pointer<Void> bytes, Pointer<Void> deallocatorContext);

/* JavaScript data types */

class OpaqueJSValue extends Opaque {}

/// JSValueRef A JavaScript value. The base type for all JavaScript values, and polymorphic functions on them.
typedef JSValueRef = Pointer<OpaqueJSValue>;

/// JSObjectRef A JavaScript object. A JSObject is a JSValue.
typedef JSObjectRef = Pointer<OpaqueJSValue>;

/* Script Evaluation */

/// Evaluates a string of JavaScript.
/// [ctx] The execution context to use.
/// [script] A JSString containing the script to evaluate.
/// [thisObject] The object to use as "this," or NULL to use the global object as "this."
/// [sourceURL] A JSString containing a URL for the script's source file. This is used by debuggers and when reporting exceptions. Pass NULL if you do not care to include source file information.
/// [startingLineNumber] An integer value specifying the script's starting line number in the file located at sourceURL. This is only used when reporting exceptions. The value is one-based, so the first line is line 1 and invalid values are clamped to 1.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The JSValue that results from evaluating script, or NULL if an exception is thrown.
final JSValueRef Function(JSContextRef ctx, JSStringRef script, JSObjectRef thisObject, JSStringRef sourceURL, int startingLineNumber, Pointer<JSValueRef> exception) JSEvaluateScript = jscLib
    .lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSStringRef script, JSObjectRef thisObject, JSStringRef sourceURL, Int32 startingLineNumber, Pointer<JSValueRef> exception)>>(
        'JSEvaluateScript')
    .asFunction();

/// Checks for syntax errors in a string of JavaScript.
/// [ctx] The execution context to use.
/// [script] A JSString containing the script to check for syntax errors.
/// [sourceURL] A JSString containing a URL for the script's source file. This is only used when reporting exceptions. Pass NULL if you do not care to include source file information in exceptions.
/// [startingLineNumber] An integer value specifying the script's starting line number in the file located at sourceURL. This is only used when reporting exceptions. The value is one-based, so the first line is line 1 and invalid values are clamped to 1.
/// [exception] A pointer to a JSValueRef in which to store a syntax error exception, if any. Pass NULL if you do not care to store a syntax error exception.
/// [@result] true if the script is syntactically correct, otherwise false.
final bool Function(JSContextRef ctx, JSStringRef script, JSStringRef sourceURL, int startingLineNumber, Pointer<JSValueRef> exception) JSCheckScriptSyntax = jscLib
    .lookup<NativeFunction<Bool Function(JSContextRef ctx, JSStringRef script, JSStringRef sourceURL, Int32 startingLineNumber, Pointer<JSValueRef> exception)>>('JSCheckScriptSyntax')
    .asFunction();

/// Performs a JavaScript garbage collection.
/// [ctx] The execution context to use.
/// [@discussion] JavaScript values that are on the machine stack, in a register,
///  protected by JSValueProtect, set as the global object of an execution context,
///  or reachable from any such value will not be collected.
///
///  During JavaScript execution, you are not required to call this function; the
///  JavaScript engine will garbage collect as needed. JavaScript values created
///  within a context group are automatically destroyed when the last reference
///  to the context group is released.
final void Function(JSContextRef ctx) JSGarbageCollect = jscLib.lookup<NativeFunction<Void Function(JSContextRef ctx)>>('JSGarbageCollect').asFunction();
