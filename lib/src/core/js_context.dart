import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/bindings/js_context_ref.dart' as jsc_bd;
import 'package:jsc/src/core/js_class.dart';
import 'package:jsc/src/core/js_context_group.dart';
import 'package:jsc/src/core/js_object.dart';
import 'package:jsc/src/core/js_string.dart';
import 'package:jsc/src/core/js_value.dart';

@immutable
class JSContext {
  const JSContext(JSContextRef ref) : _ref = ref;

  final JSContextRef _ref;

  JSObject get globalObject {
    return JSObject(this, jsc_bd.JSContextGetGlobalObject(_ref));
  }

  JSContextGroup get group {
    return JSContextGroup(jsc_bd.JSContextGetGroup(_ref));
  }

  JSGlobalContext get globalContext {
    return JSGlobalContext(jsc_bd.JSContextGetGlobalContext(_ref));
  }

  JSValue evaluate(
    String script, {
    JSObject? thisObject,
    String? sourceURL,
    int startingLineNumber = 1,
  }) {
    final JSException exception = JSException.create(this);
    final JSString jsScript = JSString.fromString(script);
    final JSString? jsSourceURL = sourceURL != null ? JSString.fromString(sourceURL) : null;
    try {
      final JSValueRef valueRef = JSEvaluateScript(
        _ref,
        jsScript.ref,
        thisObject?.ref ?? nullptr,
        jsSourceURL?.ref ?? nullptr,
        startingLineNumber,
        exception.ref,
      );
      if (exception.shouldThrow) {
        throw exception.error;
      }
      return JSValue(this, valueRef);
    } finally {
      jsSourceURL?.release();
      jsScript.release();
      exception.release();
    }
  }

  bool checkScriptSyntax(
    String script, {
    String? sourceURL,
    int startingLineNumber = 1,
  }) {
    final JSException exception = JSException.create(this);
    final JSString jsScript = JSString.fromString(script);
    final JSString? jsSourceURL = sourceURL != null ? JSString.fromString(sourceURL) : null;
    try {
      return JSCheckScriptSyntax(
        _ref,
        jsScript.ref,
        jsSourceURL?.ref ?? nullptr,
        startingLineNumber,
        exception.ref,
      );
    } finally {
      jsSourceURL?.release();
      jsScript.release();
      exception.release();
    }
  }

  void garbageCollect() {
    JSGarbageCollect(_ref);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is JSContext && runtimeType == other.runtimeType && _ref == other._ref;

  @override
  int get hashCode => _ref.hashCode;

  @override
  String toString() {
    return 'JSContext{ref: $_ref}';
  }
}

class JSGlobalContext extends JSContext {
  const JSGlobalContext(JSGlobalContextRef ref) : super(ref);

  factory JSGlobalContext.create({
    JSClass? globalObjectClass,
  }) {
    return JSGlobalContext(jsc_bd.JSGlobalContextCreate(globalObjectClass?.ref ?? nullptr));
  }

  factory JSGlobalContext.createInGroup({
    JSContextGroup? group,
    JSClass? globalObjectClass,
  }) {
    return JSGlobalContext(jsc_bd.JSGlobalContextCreateInGroup(
      group?.ref ?? nullptr,
      globalObjectClass?.ref ?? nullptr,
    ));
  }

  /// retain 会导致内存引用计数 +1, release 次数也要相应 +1
  @Deprecated('在 Dart 层面没有调用意义')
  JSGlobalContext retain() {
    return JSGlobalContext(jsc_bd.JSGlobalContextRetain(_ref));
  }

  void release() {
    jsc_bd.JSGlobalContextRelease(_ref);
  }

  String? copyName() {
    final JSString jsString = JSString(jsc_bd.JSGlobalContextCopyName(_ref));
    try {
      return jsString.string;
    } finally {
      jsString.release();
    }
  }

  void setName(String name) {
    final JSString jsString = JSString.fromString(name);
    try {
      jsc_bd.JSGlobalContextSetName(_ref, jsString.ref);
    } finally {
      jsString.release();
    }
  }
}

extension JSContextExtension on JSContext {
  JSContextRef get ref => _ref;
}
