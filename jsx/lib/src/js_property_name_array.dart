import 'package:flutter/foundation.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/bindings/js_object_ref.dart' as js_bd;
import 'package:jsx/src/js_string.dart';

@immutable
class JSPropertyNameArray {
  const JSPropertyNameArray(JSPropertyNameArrayRef ref) : _ref = ref;

  final JSPropertyNameArrayRef _ref;

  /// retain 会导致内存引用计数 +1, release 次数也要相应 +1
  @Deprecated('在 Dart 层面没有调用意义')
  JSPropertyNameArray retain() {
    return JSPropertyNameArray(js_bd.JSPropertyNameArrayRetain(_ref));
  }

  void release() {
    js_bd.JSPropertyNameArrayRelease(_ref);
  }

  int get count {
    return js_bd.JSPropertyNameArrayGetCount(_ref);
  }

  JSString getNameAtIndex(int index) {
    return JSString(js_bd.JSPropertyNameArrayGetNameAtIndex(_ref, index));
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSPropertyNameArray && runtimeType == other.runtimeType && _ref == other._ref;

  @override
  int get hashCode => _ref.hashCode;

  @override
  String toString() {
    return 'JSPropertyNameArray{ref: $_ref}';
  }
}

extension JSPropertyNameArrayExtension on JSPropertyNameArray {
  JSPropertyNameArrayRef get ref => _ref;
}
