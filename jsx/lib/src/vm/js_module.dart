import 'package:jsx/src/js_context.dart';
import 'package:jsx/src/js_value.dart';

typedef JSModuleResolver = JSValue Function(JSContext context, List<String> path, String? version);

abstract class JSModule {
  String get name;

  void dispose();

  JSValue resolve(JSContext context, List<String> path, String? version);
}

class JSModuleManager {
  JSModuleManager._();

  static JSModuleManager get instance => _instance ??= JSModuleManager._();
  static JSModuleManager? _instance;

  final Map<String, Map<String, JSModule>> _globalModuleCache = <String, Map<String, JSModule>>{};
  final Map<String, Map<String, JSModuleResolver>> _globalModuleResolverCache = <String, Map<String, JSModuleResolver>>{};

  void registerModule(String vmId, JSModule module) {
    final Map<String, JSModule> moduleCache = _globalModuleCache.putIfAbsent(vmId, () => <String, JSModule>{});
    moduleCache[module.name] = module;
  }

  void registerModuleResolver(String vmId, String name, JSModuleResolver moduleResolver) {
    final Map<String, JSModuleResolver> moduleResolverCache = _globalModuleResolverCache.putIfAbsent(vmId, () => <String, JSModuleResolver>{});
    moduleResolverCache[name] = moduleResolver;
  }

  JSValue resolve(String vmId, String moduleName, JSContext context, List<String> path, String? version) {
    final Map<String, JSModule>? moduleCache = _globalModuleCache[vmId];
    if (moduleCache?.containsKey(moduleName) ?? false) {
      return moduleCache![moduleName]!.resolve(context, path, version);
    }
    final Map<String, JSModuleResolver>? moduleResolverCache = _globalModuleResolverCache[vmId];
    if (moduleResolverCache?.containsKey(moduleName) ?? false) {
      return moduleResolverCache![moduleName]!(context, path, version);
    }
    final JSModuleResolver? universalModuleResolver = moduleResolverCache?['*'];
    if (universalModuleResolver != null) {
      return universalModuleResolver(context, path, version);
    }
    return JSValue.makeUndefined(context);
  }

  void dispose(String vmId) {
    final Map<String, JSModule>? moduleCache = _globalModuleCache.remove(vmId);
    if (moduleCache?.isNotEmpty ?? false) {
      for (JSModule module in moduleCache!.values) {
        module.dispose();
      }
    }
    _globalModuleResolverCache.remove(vmId);
  }
}
