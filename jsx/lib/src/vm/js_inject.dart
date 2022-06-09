import 'package:jsx/src/js_context.dart';
import 'package:jsx/src/js_object.dart';
import 'package:jsx/src/js_value.dart';

abstract class JSInject {
  const JSInject();

  void injectJS(JSGlobalContext globalContext, String vmId);

  void dispose(String vmId);
}

class JSVmInject {
  const JSVmInject._();

  static void injectVmId(JSContext context, String vmId) {
    final JSObject global = context.globalObject;
    if (!global.hasProperty('_flutter_js_jsvm_inject_vm_id')) {
      global.setProperty(
        '_flutter_js_jsvm_inject_vm_id',
        JSValue.makeString(context, string: vmId),
      );
    }
  }

  static bool hasVmId(JSContext context) {
    final JSObject global = context.globalObject;
    return global.hasProperty('_flutter_js_jsvm_inject_vm_id');
  }

  static String getVmId(JSContext context) {
    final JSObject global = context.globalObject;
    return global.getProperty('_flutter_js_jsvm_inject_vm_id').string!;
  }
}
