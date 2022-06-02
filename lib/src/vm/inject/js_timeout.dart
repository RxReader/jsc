import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/core/js_context.dart';
import 'package:jsc/src/core/js_object.dart';
import 'package:jsc/src/core/js_value.dart';
import 'package:jsc/src/vm/js_inject.dart';

// https://developer.mozilla.org/zh-CN/docs/Web/API/setTimeout
// https://developer.mozilla.org/zh-CN/docs/Web/API/clearTimeout
class JSTimeoutInject extends JSInject {
  const JSTimeoutInject();

  @override
  void injectJS(JSGlobalContext globalContext, String vmId) {
    //
    JSVmInject.injectVmId(globalContext, vmId);
    //
    final JSObject global = globalContext.globalObject;
    global.setProperty(
      'setTimeout',
      JSObject.makeFunctionWithCallback(
        globalContext,
        name: 'setTimeout',
        callAsFunction: Pointer.fromFunction(_setupTimeout),
      ).value,
    );
    global.setProperty(
      'clearTimeout',
      JSObject.makeFunctionWithCallback(
        globalContext,
        name: 'clearTimeout',
        callAsFunction: Pointer.fromFunction(_setupTimeout),
      ).value,
    );
  }

  @override
  void dispose(String vmId) {
    JSTimeoutManager.instance.dispose(vmId);
  }

  // ---

  static JSValueRef _setupTimeout(
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
          if (name == 'setTimeout') {
            final JSValue codeOrFunc = arguments[0];
            final int milliseconds = arguments.length >= 2 ? arguments[1].number.toInt() : 0;
            final List<JSValue> params = arguments.length > 2 ? arguments.sublist(2) : List<JSValue>.empty();
            final int timeoutId = JSTimeoutManager.instance.setTimeout(JSVmInject.getVmId(context), () {
              codeOrFunc.object.callAsFunction(arguments: params);
            }, milliseconds);
            return JSValue.makeNumber(context, number: timeoutId.toDouble());
          } else if (name == 'clearTimeout') {
            final int timeoutId = arguments[0].number.toInt();
            JSTimeoutManager.instance.clearTimeout(JSVmInject.getVmId(context), timeoutId);
            return JSValue.makeNull(context);
          }
        }
        exception.invoke(JSObject.makeError(context, arguments: <JSValue>[
          JSValue.makeString(context, string: '$name not supported'),
        ]));
        return JSValue.makeNull(context);
      },
    );
  }
}

class JSTimeout {
  JSTimeout(this.function, this.milliseconds);

  final VoidCallback function;
  final int milliseconds;
  final Completer<void> _completer = Completer<void>();

  int get id => identityHashCode(this);

  Future<void> emit() {
    if (milliseconds > 0) {
      Future<void>.delayed(Duration(milliseconds: milliseconds), () {
        if (!_completer.isCompleted) {
          function();
          _completer.complete();
        }
      });
    } else {
      if (!_completer.isCompleted) {
        function();
        _completer.complete();
      }
    }
    return _completer.future;
  }

  void dispose() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}

class JSTimeoutManager {
  JSTimeoutManager._();

  static JSTimeoutManager get instance => _instance ??= JSTimeoutManager._();
  static JSTimeoutManager? _instance;

  final Map<String, Map<int, JSTimeout>> _globalCache = <String, Map<int, JSTimeout>>{};

  int setTimeout(String vmId, VoidCallback function, int milliseconds) {
    final Map<int, JSTimeout> cache = _globalCache.putIfAbsent(vmId, () => <int, JSTimeout>{});
    final JSTimeout timeout = JSTimeout(function, milliseconds);
    final int timeoutId = timeout.id;
    cache[timeoutId] = timeout;
    timeout.emit().then((_) {
      cache.remove(timeoutId);
    });
    return timeoutId;
  }

  void clearTimeout(String vmId, int timeoutId) {
    final Map<int, JSTimeout>? cache = _globalCache[vmId];
    if (cache?.isNotEmpty ?? false) {
      final JSTimeout? timeout = cache!.remove(timeoutId);
      timeout?.dispose();
    }
  }

  void dispose(String vmId) {
    final Map<int, JSTimeout>? cache = _globalCache.remove(vmId);
    if (cache?.isNotEmpty ?? false) {
      for (JSTimeout timeout in cache!.values) {
        timeout.dispose();
      }
    }
  }
}
