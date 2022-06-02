import 'package:flutter/foundation.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/bindings/js_object_ref.dart' as jsc_bd;
import 'package:jsc/src/core/js_object.dart';

@immutable
class JSClass {
  const JSClass(JSClassRef ref) : _ref = ref;

  factory JSClass.create(JSClassDefinition definition) {
    return JSClass(jsc_bd.JSClassCreate(definition.ref));
  }

  final JSClassRef _ref;

  /// retain 会导致内存引用计数 +1, release 次数也要相应 +1
  @Deprecated('在 Dart 层面没有调用意义')
  JSClass retain() {
    return JSClass(jsc_bd.JSClassRetain(_ref));
  }

  void release() {
    jsc_bd.JSClassRelease(_ref);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSClass && runtimeType == other.runtimeType && _ref == other._ref;

  @override
  int get hashCode => _ref.hashCode;

  @override
  String toString() {
    return 'JSClass{ref: $_ref}';
  }
}

extension JSClassExtension on JSClass {
  JSClassRef get ref => _ref;
}
