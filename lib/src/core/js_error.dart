import 'package:flutter/foundation.dart';

@immutable
class JSError extends Error {
  JSError(this.name, this.message, [this.stackTrace]);

  final String? name;
  final String message;
  @override
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSError && runtimeType == other.runtimeType && name == other.name && message == other.message && stackTrace == other.stackTrace;

  @override
  int get hashCode => name.hashCode ^ message.hashCode ^ stackTrace.hashCode;

  @override
  String toString() {
    return '${name ?? 'JSError'}: $message\n$stackTrace';
  }
}
