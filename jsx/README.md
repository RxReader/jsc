# jsx

JavaScriptCore for Flutter. The plugin provides the ability to evaluate JavaScript programs from within dart.

## Android

```
# do nothing
```

## iOS

```
# do nothing
```

## Flutter

```dart
// js
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

void console_log() {
  final JSGlobalContext globalContext = JSGlobalContext.create();
  final JSClassDefinition definition = JSClassDefinition.create(
    className: '_flutter_js_inject_console',
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
  globalContext.evaluate('console.log("1, 2, 3");');
  globalContext.release();
}
```

```dart
// js_vm
void console_log() {
  final JSVm vm = JSVm.jsc();
  vm.evaluate('console.log(1, 2, 3)');
  vm.dispose();
}
```
