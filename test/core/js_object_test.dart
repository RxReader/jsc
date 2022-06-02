import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/core/js_class.dart';
import 'package:jsc/src/core/js_context.dart';
import 'package:jsc/src/core/js_object.dart';
import 'package:jsc/src/core/js_value.dart';

JSValueRef _console_log(
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
      if (kDebugMode) {
        print('function: ${function.getProperty('name').string}');
        print('argumentCount: $argumentCount');
      }
      for (JSValue argument in arguments) {
        if (kDebugMode) {
          print('argument: ${argument.string}');
        }
      }
      return JSValue.makeNull(context);
    },
  );
}

JSValueRef _set_timeout(
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
      exception.invoke(JSObject.makeError(context, arguments: <JSValue>[
        JSValue.makeString(context, string: 'setTimeout not supported'),
      ]));
      return JSValue.makeNull(context);
    },
  );
}

JSObjectRef _make_constructor(JSContextRef ctx, JSObjectRef constructor, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) {
  return convertJSObjectCallAsConstructorCallback(ctx, constructor, argumentCount, arguments, exception, (JSContext context, JSObject constructor, List<JSValue> arguments, JSException exception) {
    final JSObject object = JSObject.make(context);
    object.setProperty('name', JSValue.makeString(context, string: 'alex'));
    object.setProperty('age', JSValue.makeNumber(context, number: arguments[0].number));
    object.setProperty('extra', JSValue.makeFromJSONString(context, jsonString: '''
    {
      "abc": "xyz"
    }
    '''));
    return object;
  });
}

void main() {
  assert(Platform.isMacOS);
  test('JSObject.makeDate', () {
    final DateTime now = DateTime.now();
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSObject object = JSObject.makeDate(globalContext, arguments: <JSValue>[
      JSValue.makeNumber(globalContext, number: now.millisecondsSinceEpoch.toDouble()),
    ]);
    expect(object.value.isDate, true);
    expect(object.value.number, now.millisecondsSinceEpoch.toDouble());
    globalContext.garbageCollect();
    globalContext.release();
  });
  test('JSObject.makeConstructor', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSObject constructor = JSObject.makeConstructor(
      globalContext,
      callAsConstructor: Pointer.fromFunction(_make_constructor),
    );
    final JSObject object = constructor.callAsConstructor(arguments: <JSValue>[JSValue.makeNumber(globalContext, number: 14.0)]);
    if (kDebugMode) {
      print(object.value.jsonString);
    }
    globalContext.release();
  });
  test('JSObject.makeFunction', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSObject func1 = JSObject.makeFunction(
      globalContext,
      name: 'hello',
      parameterNames: <String>['value'],
      body: r'''
      return 'Hello ' + value + H2;
      ''',
    );
    globalContext.globalObject.setProperty('_flutter_inject_jsc_hello', func1.value);
    final JSObject func2 = globalContext.globalObject.getProperty('_flutter_inject_jsc_hello').object;
    final JSValue result = func2.callAsFunction(arguments: <JSValue>[JSValue.makeString(globalContext, string: 'World')]);
    if (kDebugMode) {
      print(result.string);
    }
    expect(result.string, 'Hello World');
    globalContext.release();
  });
  test('console.log - 1', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSClassDefinition definition = JSClassDefinition.create(
      className: '_flutter_jsc_inject_console',
      staticFunctions: <JSStaticFunction>[
        JSStaticFunction(
          'log',
          callAsFunction: Pointer.fromFunction(_console_log),
        ),
      ],
    );
    final JSClass clazz = JSClass.create(definition);
    definition.release();
    final JSObject console = JSObject.make(globalContext, clazz: clazz);
    clazz.release();
    globalContext.globalObject.setProperty('console', console.value);
    globalContext.evaluate('console.log("World");');
    globalContext.release();
  });
  test('console.log - 2', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    final JSObject console = JSObject.make(globalContext);
    console.setProperty(
      'log',
      JSObject.makeFunctionWithCallback(
        globalContext,
        name: 'log_xyz',
        callAsFunction: Pointer.fromFunction(_console_log),
      ).value,
    );
    globalContext.globalObject.setProperty('console', console.value);
    globalContext.evaluate('console.log("Hello World");');
    globalContext.evaluate('''
    function fuck_you() {
      console.log("Fuck You");
    }
    setTimeout('fuck_you', 2000);
    ''');
    globalContext.release();
  });
  test('setTimeout', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    globalContext.globalObject.setProperty(
      'setTimeout',
      JSObject.makeFunctionWithCallback(
        globalContext,
        callAsFunction: Pointer.fromFunction(_set_timeout),
      ).value,
    );
    globalContext.evaluate('''
    function fuck_you() {
      console.log("Fuck You");
    }
    setTimeout('fuck_you', 2000);
    ''');
    globalContext.release();
  });
  test('XHR', () {
    final JSGlobalContext globalContext = JSGlobalContext.create();
    globalContext.evaluate('''
    function XMLHttpRequest() {
      this._httpMethod = null;
      this._url = null;
      this._requestHeaders = [];
      this._responseHeaders = [];
      this.response = null;
      this.responseText = null;
      this.responseXML = null;
      this.responseType = "";
      this.onreadystatechange = null;
      this.onloadstart = null;
      this.onprogress = null;
      this.onabort = null;
      this.onerror = null;
      this.onload = null;
      this.onloadend = null;
      this.ontimeout = null;
      this.readyState = 0;
      this.status = 0;
      this.statusText = "";
      this.withCredentials = null;
    };
    ''');
    final bool hasXHR = globalContext.globalObject.hasProperty('XMLHttpRequest');
    if (kDebugMode) {
      print('hasXHR: $hasXHR');
    }
    globalContext.release();
  });
}
