import 'dart:ffi';

import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/js_context.dart';
import 'package:jsx/src/js_object.dart';
import 'package:jsx/src/js_value.dart';
import 'package:jsx/src/vm/js_inject.dart';

// https://developer.mozilla.org/zh-CN/docs/Web/API/console
// 简单打印。暂不支持颜色值、字符串格式化等
class JSConsoleInject extends JSInject {
  const JSConsoleInject({this.enable = false});

  final bool enable;

  // 不支持 assert/clear/count/countReset/dir/dirxml/group/groupCollapsed/groupEnd/profile/profileEnd/table/time/timeEnd/timeLog/timeStamp
  static const List<String> _kConsoleMethods = <String>['debug', 'error', 'exception' /*error 方法的别称*/, 'info', 'log', 'trace', 'warn'];

  @override
  void injectJS(JSGlobalContext globalContext, String vmId) {
    //
    globalContext.globalObject.setProperty(
      '_flutter_js_jsvm_inject_console_enable',
      JSValue.makeBoolean(globalContext, boolean: enable),
    );
    //
    final JSObject console = JSObject.make(globalContext);
    for (String name in _kConsoleMethods) {
      console.setProperty(
        name,
        JSObject.makeFunctionWithCallback(
          globalContext,
          name: name,
          callAsFunction: Pointer.fromFunction(_setupConsole),
        ).value,
      );
    }
    globalContext.globalObject.setProperty(
      'console',
      console.value,
    );
  }

  @override
  void dispose(String vmId) {
    // do nothing
  }

  // ---

  static JSValueRef _setupConsole(
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
        final JSObject global = context.globalObject;
        if (global.hasProperty('_flutter_js_jsvm_inject_console_enable')) {
          if (_kConsoleMethods.contains(name)) {
            final JSValue enable = global.getProperty('_flutter_js_jsvm_inject_console_enable');
            if (enable.isBoolean && enable.boolean) {
              // ignore: avoid_print
              print('console.$name: ${arguments.map((JSValue element) => element.string).join(' ')}');
            }
            return JSValue.makeNull(context);
          }
        }
        exception.invoke(JSObject.makeError(context, arguments: <JSValue>[
          JSValue.makeString(context, string: 'console.$name not supported'),
        ]));
        return JSValue.makeNull(context);
      },
    );
  }
}
