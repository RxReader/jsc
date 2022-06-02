import 'package:flutter/foundation.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/bindings/js_object_ref.dart' as jsc_bd;
import 'package:jsc/src/core/js_string.dart';

@immutable
class JSPropertyNameAccumulator {
  const JSPropertyNameAccumulator(JSPropertyNameAccumulatorRef ref) : _ref = ref;

  final JSPropertyNameAccumulatorRef _ref;

  void addName(String propertyName) {
    final JSString jsPropertyName = JSString.fromString(propertyName);
    try {
      jsc_bd.JSPropertyNameAccumulatorAddName(_ref, jsPropertyName.ref);
    } finally {
      jsPropertyName.release();
    }
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSPropertyNameAccumulator && runtimeType == other.runtimeType && _ref == other._ref;

  @override
  int get hashCode => _ref.hashCode;

  @override
  String toString() {
    return 'JSPropertyNameAccumulator{ref: $_ref}';
  }
}

extension JSPropertyNameAccumulatorExtension on JSPropertyNameAccumulator {
  JSPropertyNameAccumulatorRef get ref => _ref;
}
