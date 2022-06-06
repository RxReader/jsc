import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:jsx/src/bindings/dylib.dart';
import 'package:jsx/src/bindings/js_base.dart';

typedef JSChar = UnsignedShort;
// typedef JSChar = WChar;

/// Creates a JavaScript string from a buffer of Unicode characters.
/// [chars] The buffer of Unicode characters to copy into the new JSString.
/// [numChars] The number of characters to copy from the buffer pointed to by chars.
/// [@result] A JSString containing chars. Ownership follows the Create Rule.
final JSStringRef Function(Pointer<JSChar> chars, int numChars) JSStringCreateWithCharacters =
    jscLib.lookup<NativeFunction<JSStringRef Function(Pointer<JSChar> chars, Size numChars)>>('JSStringCreateWithCharacters').asFunction();

/// Creates a JavaScript string from a null-terminated UTF8 string.
/// [string] The null-terminated UTF8 string to copy into the new JSString.
/// [@result] A JSString containing string. Ownership follows the Create Rule.
final JSStringRef Function(Pointer<Utf8> string) JSStringCreateWithUTF8CString =
    jscLib.lookup<NativeFunction<JSStringRef Function(Pointer<Utf8> string)>>('JSStringCreateWithUTF8CString').asFunction();

/// Retains a JavaScript string.
/// [string] The JSString to retain.
/// [@result] A JSString that is the same as string.
final JSStringRef Function(JSStringRef string) JSStringRetain = jscLib.lookup<NativeFunction<JSStringRef Function(JSStringRef string)>>('JSStringRetain').asFunction();

/// Releases a JavaScript string.
/// [string] The JSString to release.
final void Function(JSStringRef string) JSStringRelease = jscLib.lookup<NativeFunction<Void Function(JSStringRef string)>>('JSStringRelease').asFunction();

/// Returns the number of Unicode characters in a JavaScript string.
/// [string] The JSString whose length (in Unicode characters) you want to know.
/// [@result] The number of Unicode characters stored in string.
final int Function(JSStringRef string) JSStringGetLength = jscLib.lookup<NativeFunction<Size Function(JSStringRef string)>>('JSStringGetLength').asFunction();

/// Returns a pointer to the Unicode character buffer that serves as the backing store for a JavaScript string.
/// [string] The JSString whose backing store you want to access.
/// [@result] A pointer to the Unicode character buffer that serves as string's backing store, which will be deallocated when string is deallocated.
final Pointer<JSChar> Function(JSStringRef string) JSStringGetCharactersPtr = jscLib.lookup<NativeFunction<Pointer<JSChar> Function(JSStringRef string)>>('JSStringGetCharactersPtr').asFunction();

/// Returns the maximum number of bytes a JavaScript string will take up if converted into a null-terminated UTF8 string.
/// [string] The JSString whose maximum converted size (in bytes) you want to know.
/// [@result] The maximum number of bytes that could be required to convert string into a
/// null-terminated UTF8 string. The number of bytes that the conversion actually ends
/// up requiring could be less than this, but never more.
final int Function(JSStringRef string) JSStringGetMaximumUTF8CStringSize = jscLib.lookup<NativeFunction<Size Function(JSStringRef string)>>('JSStringGetMaximumUTF8CStringSize').asFunction();

/// Converts a JavaScript string into a null-terminated UTF8 string,
/// and copies the result into an external byte buffer.
/// [string] The source JSString.
/// [buffer] The destination byte buffer into which to copy a null-terminated
/// UTF8 representation of string. On return, buffer contains a UTF8 string
/// representation of string. If bufferSize is too small, buffer will contain only
/// partial results. If buffer is not at least bufferSize bytes in size,
/// behavior is undefined.
/// [bufferSize] The size of the external buffer in bytes.
/// [@result] The number of bytes written into buffer (including the null-terminator byte).
final int Function(JSStringRef string, Pointer<Char> buffer, int bufferSize) JSStringGetUTF8CString =
    jscLib.lookup<NativeFunction<Size Function(JSStringRef string, Pointer<Char> buffer, Size bufferSize)>>('JSStringGetUTF8CString').asFunction();

/// Tests whether two JavaScript strings match.
/// [a] The first JSString to test.
/// [b] The second JSString to test.
/// [@result] true if the two strings match, otherwise false.
final bool Function(JSStringRef a, JSStringRef b) JSStringIsEqual = jscLib.lookup<NativeFunction<Bool Function(JSStringRef a, JSStringRef b)>>('JSStringIsEqual').asFunction();

/// Tests whether a JavaScript string matches a null-terminated UTF8 string.
/// [a] The JSString to test.
/// [b] The null-terminated UTF8 string to test.
/// [@result] true if the two strings match, otherwise false.
final bool Function(JSStringRef a, Pointer<Utf8> b) JSStringIsEqualToUTF8CString =
    jscLib.lookup<NativeFunction<Bool Function(JSStringRef a, Pointer<Utf8> b)>>('JSStringIsEqualToUTF8CString').asFunction();
