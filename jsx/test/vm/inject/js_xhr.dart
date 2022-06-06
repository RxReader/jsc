import 'dart:ffi';

import 'package:jsx/src/bindings/js_base.dart';
import 'package:jsx/src/core/js_context.dart';
import 'package:jsx/src/core/js_object.dart';
import 'package:jsx/src/core/js_value.dart';
import 'package:jsx/src/vm/js_inject.dart';

// https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequest
class JSXMLHttpRequestInject extends JSInject {
  const JSXMLHttpRequestInject({
    this.adapter,
  });

  final XMLHttpRequestAdapter? adapter;

  static final Map<String, XMLHttpRequestAdapter> _globalCache = <String, XMLHttpRequestAdapter>{};

  @override
  void injectJS(JSContext globalContext, String vmId) {
    //
    JSVmInject.injectVmId(globalContext, vmId);
    _globalCache[vmId] = adapter ?? SimpleXMLHttpRequestAdapter();
    //
    final JSObject http = JSObject.make(globalContext);
    http.setProperty(
      'send',
      JSObject.makeFunctionWithCallback(
        globalContext,
        name: 'send',
        callAsFunction: Pointer.fromFunction(_setupHttp),
      ).value,
    );
    globalContext.globalObject.setProperty('_flutter_js_jsvm_inject_http', http.value);
    //
    globalContext.evaluate(r'''
    function XMLHttpRequest() {
      this._method = null;
      this._url = null;
      this._async = true;
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
    // readystate enum
    XMLHttpRequest.UNSENT = 0;
    XMLHttpRequest.OPENED = 1;
    XMLHttpRequest.HEADERS = 2;
    XMLHttpRequest.LOADING = 3;
    XMLHttpRequest.DONE = 4;
    //
    XMLHttpRequest.prototype.constructor = XMLHttpRequest;
    //
    XMLHttpRequest.prototype.open = function(method, url, async = true, user = null, password = null) {
      this._method = method;
      this._url = url;
      this._async = async;
      this.readyState = XMLHttpRequest.OPENED;
      if (typeof this.onreadystatechange === "function") {
        //console.log("Calling onreadystatechange(OPENED)...");
        this.onreadystatechange();
      }
    };
    ''');
  }

  @override
  void dispose(String vmId) {
    final XMLHttpRequestAdapter? adapter = _globalCache.remove(vmId);
    adapter?.dispose();
  }

  // ---

  static JSValueRef _setupHttp(
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
          if (name == 'send') {
            // final XMLHttpRequestAdapter adapter = _globalCache[JSVmInject.getVmId(context)]!;
            //
            return JSValue.makeUndefined(context);
          }
        }
        exception.invoke(JSObject.makeError(context, arguments: <JSValue>[
          JSValue.makeString(context, string: '_flutter_js_jsvm_inject_http.$name not supported'),
        ]));
        return JSValue.makeNull(context);
      },
    );
  }
}

abstract class XMLHttpRequestAdapter {
  void dispose();
}

class SimpleXMLHttpRequestAdapter implements XMLHttpRequestAdapter {
  @override
  void dispose() {}
}
