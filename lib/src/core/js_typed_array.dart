import 'dart:ffi';

import 'package:flutter/foundation.dart';

@immutable
class JSTypedArrayBytes {
  const JSTypedArrayBytes(Pointer<Void> bytes, int length)
      : _bytes = bytes,
        _length = length;

  final Pointer<Void> _bytes;
  final int _length;

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSTypedArrayBytes && runtimeType == other.runtimeType && _bytes == other._bytes && _length == other._length;

  @override
  int get hashCode => _bytes.hashCode ^ _length.hashCode;

  @override
  String toString() {
    return 'JSTypedArrayBytes{bytes: $_bytes, length: $_length}';
  }
}

extension JSTypedArrayBytesExtension on JSTypedArrayBytes {
  Pointer<Void> get bytes => _bytes;

  int get length => _length;
}
