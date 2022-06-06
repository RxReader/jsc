import 'dart:ffi';

import 'package:jsx/src/bindings/dylib.dart';
import 'package:jsx/src/bindings/js_base.dart';

// ------------- Typed Array functions --------------

/// MacOS 10.12, iOS 10.0
/// Creates a JavaScript Typed Array object with the given number of elements.
/// [ctx] The execution context to use.
/// [arrayType] A value identifying the type of array to create. If arrayType is kJSTypedArrayTypeNone or kJSTypedArrayTypeArrayBuffer then NULL will be returned.
/// [length] The number of elements to be in the new Typed Array.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObjectRef that is a Typed Array with all elements set to zero or NULL if there was an error.
final JSObjectRef Function(JSContextRef ctx, int /*JSTypedArrayType*/ arrayType, int length, Pointer<JSValueRef> exception) JSObjectMakeTypedArray =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Uint32 /*JSTypedArrayType*/ arrayType, Size length, Pointer<JSValueRef> exception)>>('JSObjectMakeTypedArray').asFunction();

/// MacOS 10.12, iOS 10.0
/// Creates a JavaScript Typed Array object from an existing pointer.
/// [ctx] The execution context to use.
/// [arrayType] A value identifying the type of array to create. If arrayType is kJSTypedArrayTypeNone or kJSTypedArrayTypeArrayBuffer then NULL will be returned.
/// [bytes] A pointer to the byte buffer to be used as the backing store of the Typed Array object.
/// [byteLength] The number of bytes pointed to by the parameter bytes.
/// [bytesDeallocator] The allocator to use to deallocate the external buffer when the JSTypedArrayData object is deallocated.
/// [deallocatorContext] A pointer to pass back to the deallocator.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObjectRef Typed Array whose backing store is the same as the one pointed to by bytes or NULL if there was an error.
/// [@discussion] If an exception is thrown during this function the bytesDeallocator will always be called.
final JSObjectRef Function(JSContextRef ctx, int /*JSTypedArrayType*/ arrayType, Pointer<Void> bytes, int byteLength, Pointer<NativeFunction<JSTypedArrayBytesDeallocator>> bytesDeallocator,
        Pointer<Void> deallocatorContext, Pointer<JSValueRef> exception) JSObjectMakeTypedArrayWithBytesNoCopy =
    jscLib
        .lookup<
            NativeFunction<
                JSObjectRef Function(JSContextRef ctx, Uint32 /*JSTypedArrayType*/ arrayType, Pointer<Void> bytes, Size byteLength,
                    Pointer<NativeFunction<JSTypedArrayBytesDeallocator>> bytesDeallocator, Pointer<Void> deallocatorContext, Pointer<JSValueRef> exception)>>('JSObjectMakeTypedArrayWithBytesNoCopy')
        .asFunction();

/// MacOS 10.12, iOS 10.0
/// Creates a JavaScript Typed Array object from an existing JavaScript Array Buffer object.
/// [ctx] The execution context to use.
/// [arrayType] A value identifying the type of array to create. If arrayType is kJSTypedArrayTypeNone or kJSTypedArrayTypeArrayBuffer then NULL will be returned.
/// [buffer] An Array Buffer object that should be used as the backing store for the created JavaScript Typed Array object.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObjectRef that is a Typed Array or NULL if there was an error. The backing store of the Typed Array will be buffer.
final JSObjectRef Function(JSContextRef ctx, int /*JSTypedArrayType*/ arrayType, JSObjectRef buffer, Pointer<JSValueRef> exception) JSObjectMakeTypedArrayWithArrayBuffer = jscLib
    .lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Uint32 /*JSTypedArrayType*/ arrayType, JSObjectRef buffer, Pointer<JSValueRef> exception)>>('JSObjectMakeTypedArrayWithArrayBuffer')
    .asFunction();

/// MacOS 10.12, iOS 10.0
/// Creates a JavaScript Typed Array object from an existing JavaScript Array Buffer object with the given offset and length.
/// [ctx] The execution context to use.
/// [arrayType] A value identifying the type of array to create. If arrayType is kJSTypedArrayTypeNone or kJSTypedArrayTypeArrayBuffer then NULL will be returned.
/// [buffer] An Array Buffer object that should be used as the backing store for the created JavaScript Typed Array object.
/// [byteOffset] The byte offset for the created Typed Array. byteOffset should aligned with the element size of arrayType.
/// [length] The number of elements to include in the Typed Array.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObjectRef that is a Typed Array or NULL if there was an error. The backing store of the Typed Array will be buffer.
final JSObjectRef Function(JSContextRef ctx, int /*JSTypedArrayType*/ arrayType, JSObjectRef buffer, int byteOffset, int length, Pointer<JSValueRef> exception)
    JSObjectMakeTypedArrayWithArrayBufferAndOffset = jscLib
        .lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Uint32 /*JSTypedArrayType*/ arrayType, JSObjectRef buffer, Size byteOffset, Size length, Pointer<JSValueRef> exception)>>(
            'JSObjectMakeTypedArrayWithArrayBufferAndOffset')
        .asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns a temporary pointer to the backing store of a JavaScript Typed Array object.
/// [ctx] The execution context to use.
/// [object] The Typed Array object whose backing store pointer to return.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A pointer to the raw data buffer that serves as object's backing store or NULL if object is not a Typed Array object.
/// [@discussion] The pointer returned by this function is temporary and is not guaranteed to remain valid across JavaScriptCore API calls.
final Pointer<Void> Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception) JSObjectGetTypedArrayBytesPtr =
    jscLib.lookup<NativeFunction<Pointer<Void> Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception)>>('JSObjectGetTypedArrayBytesPtr').asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns the length of a JavaScript Typed Array object.
/// [ctx] The execution context to use.
/// [object] The Typed Array object whose length to return.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The length of the Typed Array object or 0 if the object is not a Typed Array object.
final int Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception) JSObjectGetTypedArrayLength =
    jscLib.lookup<NativeFunction<Size Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception)>>('JSObjectGetTypedArrayLength').asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns the byte length of a JavaScript Typed Array object.
/// [ctx] The execution context to use.
/// [object] The Typed Array object whose byte length to return.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The byte length of the Typed Array object or 0 if the object is not a Typed Array object.
final int Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception) JSObjectGetTypedArrayByteLength =
    jscLib.lookup<NativeFunction<Size Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception)>>('JSObjectGetTypedArrayByteLength').asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns the byte offset of a JavaScript Typed Array object.
/// [ctx] The execution context to use.
/// [object] The Typed Array object whose byte offset to return.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The byte offset of the Typed Array object or 0 if the object is not a Typed Array object.
final int Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception) JSObjectGetTypedArrayByteOffset =
    jscLib.lookup<NativeFunction<Size Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception)>>('JSObjectGetTypedArrayByteOffset').asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns the JavaScript Array Buffer object that is used as the backing of a JavaScript Typed Array object.
/// [ctx] The execution context to use.
/// [object] The JSObjectRef whose Typed Array type data pointer to obtain.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObjectRef with a JSTypedArrayType of kJSTypedArrayTypeArrayBuffer or NULL if object is not a Typed Array.
final JSObjectRef Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception) JSObjectGetTypedArrayBuffer =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception)>>('JSObjectGetTypedArrayBuffer').asFunction();

// ------------- Array Buffer functions -------------

/// MacOS 10.12, iOS 10.0
/// Creates a JavaScript Array Buffer object from an existing pointer.
/// [ctx] The execution context to use.
/// [bytes] A pointer to the byte buffer to be used as the backing store of the Typed Array object.
/// [byteLength] The number of bytes pointed to by the parameter bytes.
/// [bytesDeallocator] The allocator to use to deallocate the external buffer when the Typed Array data object is deallocated.
/// [deallocatorContext] A pointer to pass back to the deallocator.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObjectRef Array Buffer whose backing store is the same as the one pointed to by bytes or NULL if there was an error.
/// [@discussion] If an exception is thrown during this function the bytesDeallocator will always be called.
final JSObjectRef Function(
        JSContextRef ctx, Pointer<Void> bytes, int byteLength, Pointer<NativeFunction<JSTypedArrayBytesDeallocator>> bytesDeallocator, Pointer<Void> deallocatorContext, Pointer<JSValueRef> exception)
    JSObjectMakeArrayBufferWithBytesNoCopy = jscLib
        .lookup<
            NativeFunction<
                JSObjectRef Function(JSContextRef ctx, Pointer<Void> bytes, Size byteLength, Pointer<NativeFunction<JSTypedArrayBytesDeallocator>> bytesDeallocator, Pointer<Void> deallocatorContext,
                    Pointer<JSValueRef> exception)>>('JSObjectMakeArrayBufferWithBytesNoCopy')
        .asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns a pointer to the data buffer that serves as the backing store for a JavaScript Typed Array object.
/// [object] The Array Buffer object whose internal backing store pointer to return.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A pointer to the raw data buffer that serves as object's backing store or NULL if object is not an Array Buffer object.
/// [@discussion] The pointer returned by this function is temporary and is not guaranteed to remain valid across JavaScriptCore API calls.
final Pointer<Void> Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception) JSObjectGetArrayBufferBytesPtr =
    jscLib.lookup<NativeFunction<Pointer<Void> Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception)>>('JSObjectGetArrayBufferBytesPtr').asFunction();

/// MacOS 10.12, iOS 10.0
/// Returns the number of bytes in a JavaScript data object.
/// [ctx] The execution context to use.
/// [object] The JS Arary Buffer object whose length in bytes to return.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The number of bytes stored in the data object.
final int Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception) JSObjectGetArrayBufferByteLength =
    jscLib.lookup<NativeFunction<Size Function(JSContextRef ctx, JSObjectRef object, Pointer<JSValueRef> exception)>>('JSObjectGetArrayBufferByteLength').asFunction();
