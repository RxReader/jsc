import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/bindings/js_string_ref.dart' as js_bd;

@immutable
class JSString {
  const JSString(JSStringRef ref) : _ref = ref;

  factory JSString.fromString(String string) {
    final Pointer<Utf8> cstring = string.toNativeUtf8();
    try {
      return JSString(js_bd.JSStringCreateWithUTF8CString(cstring));
    } finally {
      malloc.free(cstring);
    }
  }

  final JSStringRef _ref;

  /// retain 会导致内存引用计数 +1, release 次数也要相应 +1
  @Deprecated('在 Dart 层面没有调用意义')
  JSString retain() {
    return JSString(js_bd.JSStringRetain(_ref));
  }

  void release() {
    if (_ref != nullptr) {
      js_bd.JSStringRelease(_ref);
    }
  }

  int get length {
    return js_bd.JSStringGetLength(_ref);
  }

  String? get string {
    if (_ref == nullptr) {
      return null;
    }
    final Pointer<js_bd.JSChar> characters = js_bd.JSStringGetCharactersPtr(_ref);
    if (characters == nullptr) {
      return null;
    }
    final int charactersLength = js_bd.JSStringGetLength(_ref);
    return String.fromCharCodes(Uint16List.view(characters.cast<Uint16>().asTypedList(charactersLength).buffer, 0, charactersLength));
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSString && runtimeType == other.runtimeType && js_bd.JSStringIsEqual(_ref, other.ref);

  @override
  int get hashCode => _ref.hashCode;

  @override
  String toString() {
    return string ?? 'JSString{ref: $_ref}';
  }
}

extension JSStringExtension on JSString {
  JSStringRef get ref => _ref;
}

extension JSStringIterable on Iterable<JSString> {
  Pointer<JSStringRef> get ref {
    final Pointer<JSStringRef> result = calloc.call(length);
    for (int i = 0; i < length; i++) {
      result[i] = elementAt(i).ref;
    }
    return result;
  }

  void release() {
    for (JSString string in this) {
      string.release();
    }
  }
}
