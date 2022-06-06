import 'dart:async';
import 'dart:ffi';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/core/js_context.dart';
import 'package:jsx/src/core/js_object.dart';
import 'package:jsx/src/core/js_value.dart';
import 'package:jsx/src/vm/js_inject.dart';

// https://developer.mozilla.org/zh-CN/docs/Web/API/setInterval
// https://developer.mozilla.org/zh-CN/docs/Web/API/clearInterval
class JSIntervalInject extends JSInject {
  const JSIntervalInject();

  @override
  void injectJS(JSGlobalContext globalContext, String vmId) {
    //
    JSVmInject.injectVmId(globalContext, vmId);
    //
    final JSObject global = globalContext.globalObject;
    global.setProperty(
      'setInterval',
      JSObject.makeFunctionWithCallback(
        globalContext,
        name: 'setInterval',
        callAsFunction: Pointer.fromFunction(_setupInterval),
      ).value,
    );
    global.setProperty(
      'clearInterval',
      JSObject.makeFunctionWithCallback(
        globalContext,
        name: 'clearInterval',
        callAsFunction: Pointer.fromFunction(_setupInterval),
      ).value,
    );
  }

  @override
  void dispose(String vmId) {
    JSIntervalManager.instance.dispose(vmId);
  }

  // ---

  static JSValueRef _setupInterval(
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
          if (name == 'setInterval') {
            final JSValue codeOrFunc = arguments[0];
            final int milliseconds = math.max(arguments[1].number.toInt(), 10); //至少10毫秒
            final List<JSValue> params = arguments.sublist(2);
            final int intervalId = JSIntervalManager.instance.setInterval(JSVmInject.getVmId(context), () {
              codeOrFunc.object.callAsFunction(arguments: params);
            }, milliseconds);
            return JSValue.makeNumber(context, number: intervalId.toDouble());
          } else if (name == 'clearInterval') {
            final int intervalId = arguments[0].number.toInt();
            JSIntervalManager.instance.clearInterval(JSVmInject.getVmId(context), intervalId);
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

class JSInterval {
  JSInterval(this.function, this.milliseconds);

  final VoidCallback function;
  final int milliseconds;
  Timer? _timer;

  int get id => identityHashCode(this);

  void emit() {
    _timer = Timer.periodic(Duration(milliseconds: milliseconds), (Timer timer) {
      if (timer.isActive) {
        function();
      }
    });
  }

  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }
}

class JSIntervalManager {
  JSIntervalManager._();

  static JSIntervalManager get instance => _instance ??= JSIntervalManager._();
  static JSIntervalManager? _instance;

  final Map<String, Map<int, JSInterval>> _globalCache = <String, Map<int, JSInterval>>{};

  int setInterval(String vmId, VoidCallback function, int milliseconds) {
    final Map<int, JSInterval> cache = _globalCache.putIfAbsent(vmId, () => <int, JSInterval>{});
    final JSInterval interval = JSInterval(function, milliseconds);
    final int intervalId = interval.id;
    cache[intervalId] = interval;
    interval.emit();
    return intervalId;
  }

  void clearInterval(String vmId, int intervalId) {
    final Map<int, JSInterval>? cache = _globalCache[vmId];
    if (cache?.isNotEmpty ?? false) {
      final JSInterval? interval = cache!.remove(intervalId);
      interval?.dispose();
    }
  }

  void dispose(String vmId) {
    final Map<int, JSInterval>? cache = _globalCache.remove(vmId);
    if (cache?.isNotEmpty ?? false) {
      for (JSInterval interval in cache!.values) {
        interval.dispose();
      }
    }
  }
}
