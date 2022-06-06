import 'package:flutter/foundation.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/bindings/js_context_ref.dart' as js_bd;

@immutable
class JSContextGroup {
  const JSContextGroup(JSContextGroupRef ref) : _ref = ref;

  factory JSContextGroup.create() {
    return JSContextGroup(js_bd.JSContextGroupCreate());
  }

  final JSContextGroupRef _ref;

  /// retain 会导致内存引用计数 +1, release 次数也要相应 +1
  @Deprecated('在 Dart 层面没有调用意义')
  JSContextGroup retain() {
    return JSContextGroup(js_bd.JSContextGroupRetain(_ref));
  }

  void release() {
    js_bd.JSContextGroupRelease(_ref);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSContextGroup && runtimeType == other.runtimeType && _ref == other._ref;

  @override
  int get hashCode => _ref.hashCode;

  @override
  String toString() {
    return 'JSContextGroup{ref: $_ref}';
  }
}

extension JSContextGroupExtension on JSContextGroup {
  JSContextGroupRef get ref => _ref;
}
