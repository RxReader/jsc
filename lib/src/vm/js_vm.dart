import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/core/js_context.dart';
import 'package:jsc/src/core/js_object.dart';
import 'package:jsc/src/core/js_value.dart';
import 'package:jsc/src/vm/inject/js_console.dart';
import 'package:jsc/src/vm/inject/js_interval.dart';
import 'package:jsc/src/vm/inject/js_timeout.dart';
import 'package:jsc/src/vm/js_inject.dart';
import 'package:jsc/src/vm/js_module.dart';

abstract class JSVm {
  const JSVm();

  factory JSVm.jsc({
    bool consoleEnable = kDebugMode,
    List<JSInject>? injects,
  }) {
    return JavaScriptCoreVm(
      injects: <JSInject>[
        JSConsoleInject(enable: consoleEnable),
        JSTimeoutInject(),
        JSIntervalInject(),
        ...?injects,
      ],
    );
  }

  factory JSVm.customJsc({
    required List<JSInject> injects,
  }) {
    return JavaScriptCoreVm(
      injects: injects,
    );
  }

  void registerModule(JSModule module);

  // * 代表通配符
  void registerModuleResolver(String name, JSModuleResolver moduleResolver);

  JSValue evaluate(
    String script, {
    JSObject? thisObject,
    String? sourceURL,
    int startingLineNumber = 1,
  });

  void dispose();
}

class JavaScriptCoreVm extends JSVm {
  JavaScriptCoreVm({
    required this.injects,
  }) {
    _setupInject();
    _setupModuleResolver();
  }

  final List<JSInject> injects;
  late final JSGlobalContext _globalContext = JSGlobalContext.create();
  late final JSObject _global = _globalContext.globalObject;

  String get _vmId => identityHashCode(this).toString();

  void _setupInject() {
    final String vmId = _vmId;
    for (JSInject inject in injects) {
      inject.injectJS(_globalContext, vmId);
    }
  }

  void _setupModuleResolver() {
    _global.setProperty(
      'require',
      JSObject.makeFunctionWithCallback(
        _globalContext,
        name: 'require',
        callAsFunction: Pointer.fromFunction(_setupRequire),
      ).value,
    );
  }

  @override
  void registerModule(JSModule module) {
    final String vmId = _vmId;
    JSModuleManager.instance.registerModule(vmId, module);
  }

  @override
  void registerModuleResolver(String name, JSModuleResolver moduleResolver) {
    final String vmId = _vmId;
    JSModuleManager.instance.registerModuleResolver(vmId, name, moduleResolver);
  }

  @override
  JSValue evaluate(
    String script, {
    JSObject? thisObject,
    String? sourceURL,
    int startingLineNumber = 1,
  }) {
    return _globalContext.evaluate(
      script,
      thisObject: thisObject,
      sourceURL: sourceURL,
      startingLineNumber: startingLineNumber,
    );
  }

  @override
  void dispose() {
    final String vmId = _vmId;
    JSModuleManager.instance.dispose(vmId);
    for (JSInject inject in injects) {
      inject.dispose(vmId);
    }
    _globalContext.release();
  }

  // ---

  static JSValueRef _setupRequire(
    JSContextRef ctx,
    JSObjectRef function,
    JSObjectRef thisObject,
    int argumentCount,
    Pointer<JSValueRef> arguments,
    Pointer<JSValueRef> exception,
  ) {
    return convertJSObjectCallAsFunctionCallback(
      ctx,
      function,
      thisObject,
      argumentCount,
      arguments,
      exception,
      (JSContext context, JSObject function, JSObject thisObject, List<JSValue> arguments, JSException exception) {
        final String name = function.getProperty('name').string!;
        if (JSVmInject.hasVmId(context)) {
          if (name == 'require') {
            final String raw = arguments[0].string!;
            late String moduleName;
            late List<String> path;
            String? version;
            // paths starts with `.` or `/` will not be parsed.
            if (raw.codeUnitAt(0) == 46 || raw.codeUnitAt(0) == 47) {
              moduleName = raw;
              path = <String>[moduleName];
            } else {
              path = raw.split('/');
              final String firstPath = path.first;
              // can have an optional version suffix
              final int versionPos = firstPath.indexOf('@');
              if (versionPos > 0) {
                version = firstPath.substring(versionPos + 1);
                path[0] = firstPath.substring(0, versionPos);
              }
              moduleName = path[0];
            }
            return JSModuleManager.instance.resolve(JSVmInject.getVmId(context), moduleName, context, path, version);
          } else {
            return JSValue.makeUndefined(context);
          }
        } else {
          exception.invoke(JSObject.makeError(context, arguments: <JSValue>[
            JSValue.makeString(context, string: '$name not supported'),
          ]));
          return JSValue.makeNull(context);
        }
      },
    );
  }
}
