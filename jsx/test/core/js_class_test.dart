import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/core/js_class.dart';
import 'package:jsx/src/core/js_context.dart';
import 'package:jsx/src/core/js_object.dart';
import 'package:jsx/src/core/js_string.dart';
import 'package:jsx/src/core/js_value.dart';

JSValueRef _kXyz_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception) {
  return convertJSObjectGetPropertyCallback(ctx, object, propertyName, exception, (JSContext context, JSObject object, JSString propertyName, JSException exception) {
    return JSValue.makeString(context, string: 'abc');
  });
}

JSValueRef _hello_callAsFunction(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) {
  return convertJSObjectCallAsFunctionCallback(ctx, function, thisObject, argumentCount, arguments, exception,
      (JSContext context, JSObject function, JSObject thisObject, List<JSValue> arguments, JSException exception) {
    assert(argumentCount == 1);
    assert(arguments[0].isString);
    return JSValue.makeString(context, string: 'Hello ${arguments[0].string}');
  });
}

void main() {
  assert(Platform.isMacOS);
  test('JSClass.create', () {
    final JSClassDefinition definition = JSClassDefinition.create(
      className: 'BuildContext',
    );
    final JSClass clazz = JSClass.create(definition);
    definition.release();
    final JSClass clazzRetain = clazz.retain();
    expect(clazz, clazzRetain);
    clazzRetain.release();
    clazz.release();
  });
  test('JSClassDefinition.create', () {
    final JSClassDefinition definition = JSClassDefinition.create(
      className: 'BuildContext',
      staticValues: <JSStaticValue>[
        JSStaticValue(
          'kXyz',
          getProperty: Pointer.fromFunction(_kXyz_getProperty),
          attributes: JSPropertyAttributes.kJSPropertyAttributeReadOnly,
        ),
      ],
      staticFunctions: <JSStaticFunction>[
        JSStaticFunction(
          'hello',
          callAsFunction: Pointer.fromFunction(_hello_callAsFunction),
          attributes: JSPropertyAttributes.kJSPropertyAttributeReadOnly,
        ),
      ],
    );
    final JSClass clazz = JSClass.create(definition);
    definition.release();
    final JSGlobalContext globalContext = JSGlobalContext.create(globalObjectClass: clazz);
    clazz.release();
    final JSValue value1 = globalContext.evaluate('kXyz;');
    if (kDebugMode) {
      print(value1.string);
    }
    expect(value1.string, 'abc');
    final JSValue value2 = globalContext.evaluate('hello("World");');
    if (kDebugMode) {
      print(value2.string);
    }
    expect(value2.string, 'Hello World');
    if (kDebugMode) {
      print(globalContext.globalObject.value.jsonString);
    }
    expect(globalContext.globalObject.hasProperty('kXyz'), true);
    expect(globalContext.globalObject.getProperty('kXyz').string, 'abc');
    globalContext.globalObject.setProperty('kDyAdd', JSValue.makeString(globalContext, string: 'hij'));
    expect(globalContext.globalObject.getProperty('kDyAdd').string, 'hij');
    globalContext.globalObject.deleteProperty('kDyAdd');
    expect(globalContext.globalObject.hasProperty('kDyAdd'), false);
    globalContext.release();
  });
}
