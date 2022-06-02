import 'dart:ffi';

import 'package:jsc/src/bindings/dylib.dart';
import 'package:jsc/src/bindings/js_base.dart';

/// Creates a JavaScript context group.
/// [@result] The created JSContextGroup.
/// [@discussion] A JSContextGroup associates JavaScript contexts with one another.
///  Contexts in the same group may share and exchange JavaScript objects. Sharing and/or exchanging
///  JavaScript objects between contexts in different groups will produce undefined behavior.
///  When objects from the same context group are used in multiple threads, explicit
///  synchronization is required.
///
///  A JSContextGroup may need to run deferred tasks on a run loop, such as garbage collection
///  or resolving WebAssembly compilations. By default, calling JSContextGroupCreate will use
///  the run loop of the thread it was called on. Currently, there is no API to change a
///  JSContextGroup's run loop once it has been created.
final JSContextGroupRef Function() JSContextGroupCreate = jscLib.lookup<NativeFunction<JSContextGroupRef Function()>>('JSContextGroupCreate').asFunction();

/// Retains a JavaScript context group.
/// [group] The JSContextGroup to retain.
/// [@result] A JSContextGroup that is the same as group.
final JSContextGroupRef Function(JSContextGroupRef group) JSContextGroupRetain =
    jscLib.lookup<NativeFunction<JSContextGroupRef Function(JSContextGroupRef group)>>('JSContextGroupRetain').asFunction();

/// Releases a JavaScript context group.
/// [group] The JSContextGroup to release.
final void Function(JSContextGroupRef group) JSContextGroupRelease = jscLib.lookup<NativeFunction<Void Function(JSContextGroupRef group)>>('JSContextGroupRelease').asFunction();

/// Creates a global JavaScript execution context.
/// [globalObjectClass] The class to use when creating the global object. Pass
///  NULL to use the default object class.
/// [@result] A JSGlobalContext with a global object of class globalObjectClass.
/// [@discussion] JSGlobalContextCreate allocates a global object and populates it with all the
///  built-in JavaScript objects, such as Object, Function, String, and Array.
///
///  In WebKit version 4.0 and later, the context is created in a unique context group.
///  Therefore, scripts may execute in it concurrently with scripts executing in other contexts.
///  However, you may not use values created in the context in other contexts.
final JSGlobalContextRef Function(JSClassRef globalObjectClass) JSGlobalContextCreate =
    jscLib.lookup<NativeFunction<JSGlobalContextRef Function(JSClassRef globalObjectClass)>>('JSGlobalContextCreate').asFunction();

/// Creates a global JavaScript execution context in the context group provided.
/// [group] The context group to use. The created global context retains the group.
///  Pass NULL to create a unique group for the context.
/// [globalObjectClass] The class to use when creating the global object. Pass
///  NULL to use the default object class.
/// [@result] A JSGlobalContext with a global object of class globalObjectClass and a context
///  group equal to group.
/// [@discussion] JSGlobalContextCreateInGroup allocates a global object and populates it with
///  all the built-in JavaScript objects, such as Object, Function, String, and Array.
final JSGlobalContextRef Function(JSContextGroupRef group, JSClassRef globalObjectClass) JSGlobalContextCreateInGroup =
    jscLib.lookup<NativeFunction<JSGlobalContextRef Function(JSContextGroupRef group, JSClassRef globalObjectClass)>>('JSGlobalContextCreateInGroup').asFunction();

/// Retains a global JavaScript execution context.
/// [ctx] The JSGlobalContext to retain.
/// [@result] A JSGlobalContext that is the same as ctx.
final JSGlobalContextRef Function(JSGlobalContextRef ctx) JSGlobalContextRetain =
    jscLib.lookup<NativeFunction<JSGlobalContextRef Function(JSGlobalContextRef ctx)>>('JSGlobalContextRetain').asFunction();

/// Releases a global JavaScript execution context.
/// [ctx] The JSGlobalContext to release.
final void Function(JSGlobalContextRef ctx) JSGlobalContextRelease = jscLib.lookup<NativeFunction<Void Function(JSGlobalContextRef ctx)>>('JSGlobalContextRelease').asFunction();

/// Gets the global object of a JavaScript execution context.
/// [ctx] The JSContext whose global object you want to get.
/// [@result] ctx's global object.
final JSObjectRef Function(JSContextRef ctx) JSContextGetGlobalObject = jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx)>>('JSContextGetGlobalObject').asFunction();

/// Gets the context group to which a JavaScript execution context belongs.
/// [ctx] The JSContext whose group you want to get.
/// [@result] ctx's group.
final JSContextGroupRef Function(JSContextRef ctx) JSContextGetGroup = jscLib.lookup<NativeFunction<JSContextGroupRef Function(JSContextRef ctx)>>('JSContextGetGroup').asFunction();

/// Gets the global context of a JavaScript execution context.
/// [ctx] The JSContext whose global context you want to get.
/// [@result] ctx's global context.
final JSGlobalContextRef Function(JSContextRef ctx) JSContextGetGlobalContext = jscLib.lookup<NativeFunction<JSGlobalContextRef Function(JSContextRef ctx)>>('JSContextGetGlobalContext').asFunction();

/// Gets a copy of the name of a context.
/// [ctx] The JSGlobalContext whose name you want to get.
/// [@result] The name for ctx.
/// [@discussion] A JSGlobalContext's name is exposed for remote debugging to make it
/// easier to identify the context you would like to attach to.
final JSStringRef Function(JSGlobalContextRef ctx) JSGlobalContextCopyName = jscLib.lookup<NativeFunction<JSStringRef Function(JSGlobalContextRef ctx)>>('JSGlobalContextCopyName').asFunction();

/// Sets the remote debugging name for a context.
/// [ctx] The JSGlobalContext that you want to name.
/// [name] The remote debugging name to set on ctx.
final void Function(JSGlobalContextRef ctx, JSStringRef name) JSGlobalContextSetName =
    jscLib.lookup<NativeFunction<Void Function(JSGlobalContextRef ctx, JSStringRef name)>>('JSGlobalContextSetName').asFunction();
