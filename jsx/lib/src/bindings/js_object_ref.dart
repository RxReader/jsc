import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:jsx/src/bindings/dylib.dart';
import 'package:jsx/src/bindings/js_base.dart';

/// JSPropertyAttributes
/// A set of JSPropertyAttributes. Combine multiple attributes by logically ORing them together.
class JSPropertyAttributes {
  const JSPropertyAttributes._();

  /// Specifies that a property has no special attributes.
  static const int kJSPropertyAttributeNone = 0;

  /// Specifies that a property is read-only.
  static const int kJSPropertyAttributeReadOnly = 1 << 1;

  /// Specifies that a property should not be enumerated by JSPropertyEnumerators and JavaScript for...in loops.
  static const int kJSPropertyAttributeDontEnum = 1 << 2;

  /// Specifies that the delete operation should fail on a property.
  static const int kJSPropertyAttributeDontDelete = 1 << 3;
}

/// JSClassAttributes
/// A set of JSClassAttributes. Combine multiple attributes by logically ORing them together.
class JSClassAttributes {
  const JSClassAttributes._();

  /// Specifies that a class has no special attributes.
  static const int kJSClassAttributeNone = 0;

  /// Specifies that a class should not automatically generate a shared prototype for its instance objects. Use kJSClassAttributeNoAutomaticPrototype in combination with JSObjectSetPrototype to manage prototypes manually.
  static const int kJSClassAttributeNoAutomaticPrototype = 1 << 1;
}

/// The callback invoked when an object is first created.
/// [ctx] The execution context to use.
/// [object] The JSObject being created.
/// [@discussion] If you named your function Initialize, you would declare it like this:
///
/// void Initialize(JSContextRef ctx, JSObjectRef object);
///
/// Unlike the other object callbacks, the initialize callback is called on the least
/// derived class (the parent class) first, and the most derived class last.
///
/// typedef void (*JSObjectInitializeCallback) (JSContextRef ctx, JSObjectRef object);
typedef JSObjectInitializeCallback = Void Function(JSContextRef ctx, JSObjectRef object);

/// The callback invoked when an object is finalized (prepared for garbage collection). An object may be finalized on any thread.
/// [object] The JSObject being finalized.
/// [@discussion] If you named your function Finalize, you would declare it like this:
///
/// void Finalize(JSObjectRef object);
///
/// The finalize callback is called on the most derived class first, and the least
/// derived class (the parent class) last.
///
/// You must not call any function that may cause a garbage collection or an allocation
/// of a garbage collected object from within a JSObjectFinalizeCallback. This includes
/// all functions that have a JSContextRef parameter.
///
/// typedef void (*JSObjectFinalizeCallback) (JSObjectRef object);
typedef JSObjectFinalizeCallback = Void Function(JSObjectRef object);

/// The callback invoked when determining whether an object has a property.
/// [ctx] The execution context to use.
/// [object] The JSObject to search for the property.
/// [propertyName] A JSString containing the name of the property look up.
/// [@result] true if object has the property, otherwise false.
/// [@discussion] If you named your function HasProperty, you would declare it like this:
///
/// bool HasProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName);
///
/// If this function returns false, the hasProperty request forwards to object's statically declared properties, then its parent class chain (which includes the default object class), then its prototype chain.
///
/// This callback enables optimization in cases where only a property's existence needs to be known, not its value, and computing its value would be expensive.
///
/// If this callback is NULL, the getProperty callback will be used to service hasProperty requests.
///
/// typedef bool (*JSObjectHasPropertyCallback) (JSContextRef ctx, JSObjectRef object, JSStringRef propertyName);
typedef JSObjectHasPropertyCallback = Bool Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName);

/// The callback invoked when getting a property's value.
/// [ctx] The execution context to use.
/// [object] The JSObject to search for the property.
/// [propertyName] A JSString containing the name of the property to get.
/// [exception] A pointer to a JSValueRef in which to return an exception, if any.
/// [@result] The property's value if object has the property, otherwise NULL.
/// [@discussion] If you named your function GetProperty, you would declare it like this:
///
/// JSValueRef GetProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception);
///
/// If this function returns NULL, the get request forwards to object's statically declared properties, then its parent class chain (which includes the default object class), then its prototype chain.
///
/// typedef JSValueRef (*JSObjectGetPropertyCallback) (JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception);
typedef JSObjectGetPropertyCallback = JSValueRef Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception);

/// The callback invoked when setting a property's value.
/// [ctx] The execution context to use.
/// [object] The JSObject on which to set the property's value.
/// [propertyName] A JSString containing the name of the property to set.
/// [value] A JSValue to use as the property's value.
/// [exception] A pointer to a JSValueRef in which to return an exception, if any.
/// [@result] true if the property was set, otherwise false.
/// [@discussion] If you named your function SetProperty, you would declare it like this:
///
/// bool SetProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception);
///
/// If this function returns false, the set request forwards to object's statically declared properties, then its parent class chain (which includes the default object class).
///
/// typedef bool (*JSObjectSetPropertyCallback) (JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef* exception);
typedef JSObjectSetPropertyCallback = Bool Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, Pointer<JSValueRef> exception);

/// The callback invoked when deleting a property.
/// [ctx] The execution context to use.
/// [object] The JSObject in which to delete the property.
/// [propertyName] A JSString containing the name of the property to delete.
/// [exception] A pointer to a JSValueRef in which to return an exception, if any.
/// [@result] true if propertyName was successfully deleted, otherwise false.
/// [@discussion] If you named your function DeleteProperty, you would declare it like this:
///
/// bool DeleteProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception);
///
/// If this function returns false, the delete request forwards to object's statically declared properties, then its parent class chain (which includes the default object class).
///
/// typedef bool (*JSObjectDeletePropertyCallback) (JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef* exception);
typedef JSObjectDeletePropertyCallback = Bool Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception);

/// The callback invoked when collecting the names of an object's properties.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property names are being collected.
/// [propertyNames] A JavaScript property name accumulator in which to accumulate the names of object's properties.
/// [@discussion] If you named your function GetPropertyNames, you would declare it like this:
///
/// void GetPropertyNames(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames);
///
/// Property name accumulators are used by JSObjectCopyPropertyNames and JavaScript for...in loops.
///
/// Use JSPropertyNameAccumulatorAddName to add property names to accumulator. A class's getPropertyNames callback only needs to provide the names of properties that the class vends through a custom getProperty or setProperty callback. Other properties, including statically declared properties, properties vended by other classes, and properties belonging to object's prototype, are added independently.
///
/// typedef void (*JSObjectGetPropertyNamesCallback) (JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames);
typedef JSObjectGetPropertyNamesCallback = Void Function(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames);

/// The callback invoked when an object is called as a function.
/// [ctx] The execution context to use.
/// [function] A JSObject that is the function being called.
/// [thisObject] A JSObject that is the 'this' variable in the function's scope.
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of the  arguments passed to the function.
/// [exception] A pointer to a JSValueRef in which to return an exception, if any.
/// [@result] A JSValue that is the function's return value.
/// [@discussion] If you named your function CallAsFunction, you would declare it like this:
///
/// JSValueRef CallAsFunction(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception);
///
/// If your callback were invoked by the JavaScript expression 'myObject.myFunction()', function would be set to myFunction, and thisObject would be set to myObject.
///
/// If this callback is NULL, calling your object as a function will throw an exception.
///
/// typedef JSValueRef (*JSObjectCallAsFunctionCallback) (JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception);
typedef JSObjectCallAsFunctionCallback = JSValueRef Function(
    JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception);

/// The callback invoked when an object is used as a constructor in a 'new' expression.
/// [ctx] The execution context to use.
/// [constructor] A JSObject that is the constructor being called.
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of the  arguments passed to the function.
/// [exception] A pointer to a JSValueRef in which to return an exception, if any.
/// [@result] A JSObject that is the constructor's return value.
/// [@discussion] If you named your function CallAsConstructor, you would declare it like this:
///
/// JSObjectRef CallAsConstructor(JSContextRef ctx, JSObjectRef constructor, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception);
///
/// If your callback were invoked by the JavaScript expression 'new myConstructor()', constructor would be set to myConstructor.
///
/// If this callback is NULL, using your object as a constructor in a 'new' expression will throw an exception.
///
/// typedef JSObjectRef (*JSObjectCallAsConstructorCallback) (JSContextRef ctx, JSObjectRef constructor, size_t argumentCount, const JSValueRef arguments[], JSValueRef* exception);
typedef JSObjectCallAsConstructorCallback = JSObjectRef Function(JSContextRef ctx, JSObjectRef constructor, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception);

/// hasInstance The callback invoked when an object is used as the target of an 'instanceof' expression.
/// [ctx] The execution context to use.
/// [constructor] The JSObject that is the target of the 'instanceof' expression.
/// [possibleInstance] The JSValue being tested to determine if it is an instance of constructor.
/// [exception] A pointer to a JSValueRef in which to return an exception, if any.
/// [@result] true if possibleInstance is an instance of constructor, otherwise false.
/// [@discussion] If you named your function HasInstance, you would declare it like this:
///
/// bool HasInstance(JSContextRef ctx, JSObjectRef constructor, JSValueRef possibleInstance, JSValueRef* exception);
///
/// If your callback were invoked by the JavaScript expression 'someValue instanceof myObject', constructor would be set to myObject and possibleInstance would be set to someValue.
///
/// If this callback is NULL, 'instanceof' expressions that target your object will return false.
///
/// Standard JavaScript practice calls for objects that implement the callAsConstructor callback to implement the hasInstance callback as well.
///
/// typedef bool (*JSObjectHasInstanceCallback)  (JSContextRef ctx, JSObjectRef constructor, JSValueRef possibleInstance, JSValueRef* exception);
typedef JSObjectHasInstanceCallback = Bool Function(JSContextRef ctx, JSObjectRef constructor, JSValueRef possibleInstance, Pointer<JSValueRef> exception);

/// The callback invoked when converting an object to a particular JavaScript type.
/// [ctx] The execution context to use.
/// [object] The JSObject to convert.
/// [type] A JSType specifying the JavaScript type to convert to.
/// [exception] A pointer to a JSValueRef in which to return an exception, if any.
/// [@result] The objects's converted value, or NULL if the object was not converted.
/// [@discussion] If you named your function ConvertToType, you would declare it like this:
///
/// JSValueRef ConvertToType(JSContextRef ctx, JSObjectRef object, JSType type, JSValueRef* exception);
///
/// If this function returns false, the conversion request forwards to object's parent class chain (which includes the default object class).
///
/// This function is only invoked when converting an object to number or string. An object converted to boolean is 'true.' An object converted to object is itself.
///
/// typedef JSValueRef (*JSObjectConvertToTypeCallback) (JSContextRef ctx, JSObjectRef object, JSType type, JSValueRef* exception);
typedef JSObjectConvertToTypeCallback = JSValueRef Function(JSContextRef ctx, JSObjectRef object, Int8 /*JSType*/ type, Pointer<JSValueRef> exception);

/// This structure describes a statically declared value property.
class JSStaticValue extends Struct {
  /// A null-terminated UTF8 string containing the property's name.
  external Pointer<Utf8> name;

  /// A JSObjectGetPropertyCallback to invoke when getting the property's value.
  external Pointer<NativeFunction<JSObjectGetPropertyCallback>> getProperty;

  /// A JSObjectSetPropertyCallback to invoke when setting the property's value. May be NULL if the ReadOnly attribute is set.
  external Pointer<NativeFunction<JSObjectSetPropertyCallback>> setProperty;

  /// A logically ORed set of JSPropertyAttributes to give to the property.
  @Uint32()
  external int /*JSPropertyAttributes*/ attributes;

  static Pointer<JSStaticValue> allocate(JSStaticValueDelegate delegate) {
    final Pointer<JSStaticValue> result = calloc.call(1);
    result.ref
      ..name = delegate.name
      ..getProperty = delegate.getProperty ?? nullptr
      ..setProperty = delegate.setProperty ?? nullptr
      ..attributes = delegate.attributes;
    return result;
  }

  static Pointer<JSStaticValue> allocateArray(Iterable<JSStaticValueDelegate> delegates) {
    final Pointer<JSStaticValue> result = calloc.call(delegates.length + 1); // +1，不然会报错
    for (int i = 0; i < delegates.length; i++) {
      result[i]
        ..name = delegates.elementAt(i).name
        ..getProperty = delegates.elementAt(i).getProperty ?? nullptr
        ..setProperty = delegates.elementAt(i).setProperty ?? nullptr
        ..attributes = delegates.elementAt(i).attributes;
    }
    return result;
  }
}

class JSStaticValueDelegate {
  const JSStaticValueDelegate(this.name, this.getProperty, this.setProperty, this.attributes);

  final Pointer<Utf8> name;
  final Pointer<NativeFunction<JSObjectGetPropertyCallback>>? getProperty;
  final Pointer<NativeFunction<JSObjectSetPropertyCallback>>? setProperty;
  final int /*JSPropertyAttributes*/ attributes;
}

/// This structure describes a statically declared function property.
class JSStaticFunction extends Struct {
  /// A null-terminated UTF8 string containing the property's name.
  external Pointer<Utf8> name;

  /// A JSObjectCallAsFunctionCallback to invoke when the property is called as a function.
  external Pointer<NativeFunction<JSObjectCallAsFunctionCallback>> callAsFunction;

  /// A logically ORed set of JSPropertyAttributes to give to the property.
  @Uint32()
  external int /*JSPropertyAttributes*/ attributes;

  static Pointer<JSStaticFunction> allocate(JSStaticFunctionDelegate delegate) {
    final Pointer<JSStaticFunction> result = calloc.call(1);
    result.ref
      ..name = delegate.name
      ..callAsFunction = delegate.callAsFunction ?? nullptr
      ..attributes = delegate.attributes;
    return result;
  }

  static Pointer<JSStaticFunction> allocateArray(Iterable<JSStaticFunctionDelegate> delegates) {
    final Pointer<JSStaticFunction> result = calloc.call(delegates.length + 1); // +1，不然会报错
    for (int i = 0; i < delegates.length; i++) {
      result[i]
        ..name = delegates.elementAt(i).name
        ..callAsFunction = delegates.elementAt(i).callAsFunction ?? nullptr
        ..attributes = delegates.elementAt(i).attributes;
    }
    return result;
  }
}

class JSStaticFunctionDelegate {
  const JSStaticFunctionDelegate(this.name, this.callAsFunction, this.attributes);

  final Pointer<Utf8> name;
  final Pointer<NativeFunction<JSObjectCallAsFunctionCallback>>? callAsFunction;
  final int /*JSPropertyAttributes*/ attributes;
}

/// This structure contains properties and callbacks that define a type of object. All fields other than the version field are optional. Any pointer may be NULL.
///
/// [@discussion] The staticValues and staticFunctions arrays are the simplest and most efficient means for vending custom properties. Statically declared properties autmatically service requests like getProperty, setProperty, and getPropertyNames. Property access callbacks are required only to implement unusual properties, like array indexes, whose names are not known at compile-time.
///
/// If you named your getter function "GetX" and your setter function "SetX", you would declare a JSStaticValue array containing "X" like this:
///
/// JSStaticValue StaticValueArray[] = {
///     { "X", GetX, SetX, kJSPropertyAttributeNone },
///     { 0, 0, 0, 0 }
/// };
///
/// Standard JavaScript practice calls for storing function objects in prototypes, so they can be shared. The default JSClass created by JSClassCreate follows this idiom, instantiating objects with a shared, automatically generating prototype containing the class's function objects. The kJSClassAttributeNoAutomaticPrototype attribute specifies that a JSClass should not automatically generate such a prototype. The resulting JSClass instantiates objects with the default object prototype, and gives each instance object its own copy of the class's function objects.
///
/// A NULL callback specifies that the default object callback should substitute, except in the case of hasProperty, where it specifies that getProperty should substitute.
///
/// It is not possible to use JS subclassing with objects created from a class definition that sets callAsConstructor by default. Subclassing is supported via the JSObjectMakeConstructor function, however.
class JSClassDefinition extends Struct {
  /// The version number of this structure. The current version is 0.
  @Int32()
  external int version;

  /// A logically ORed set of JSClassAttributes to give to the class.
  @Uint32()
  external int /*JSClassAttributes*/ attributes;

  /// A null-terminated UTF8 string containing the class's name.
  external Pointer<Utf8> className;

  /// A JSClass to set as the class's parent class. Pass NULL use the default object class.
  external JSClassRef parentClass;

  /// A JSStaticValue array containing the class's statically declared value properties. Pass NULL to specify no statically declared value properties. The array must be terminated by a JSStaticValue whose name field is NULL.
  external Pointer<JSStaticValue> staticValues;

  /// A JSStaticFunction array containing the class's statically declared function properties. Pass NULL to specify no statically declared function properties. The array must be terminated by a JSStaticFunction whose name field is NULL.
  external Pointer<JSStaticFunction> staticFunctions;

  /// The callback invoked when an object is first created. Use this callback to initialize the object.
  external Pointer<NativeFunction<JSObjectInitializeCallback>> initialize;

  /// The callback invoked when an object is finalized (prepared for garbage collection). Use this callback to release resources allocated for the object, and perform other cleanup.
  external Pointer<NativeFunction<JSObjectFinalizeCallback>> finalize;

  /// The callback invoked when determining whether an object has a property. If this field is NULL, getProperty is called instead. The hasProperty callback enables optimization in cases where only a property's existence needs to be known, not its value, and computing its value is expensive.
  external Pointer<NativeFunction<JSObjectHasPropertyCallback>> hasProperty;

  /// The callback invoked when getting a property's value.
  external Pointer<NativeFunction<JSObjectGetPropertyCallback>> getProperty;

  /// The callback invoked when setting a property's value.
  external Pointer<NativeFunction<JSObjectSetPropertyCallback>> setProperty;

  /// The callback invoked when deleting a property.
  external Pointer<NativeFunction<JSObjectDeletePropertyCallback>> deleteProperty;

  /// The callback invoked when collecting the names of an object's properties.
  external Pointer<NativeFunction<JSObjectGetPropertyNamesCallback>> getPropertyNames;

  /// The callback invoked when an object is called as a function.
  external Pointer<NativeFunction<JSObjectCallAsFunctionCallback>> callAsFunction;

  /// The callback invoked when an object is used as a constructor in a 'new' expression.
  external Pointer<NativeFunction<JSObjectCallAsConstructorCallback>> callAsConstructor;

  /// The callback invoked when an object is used as the target of an 'instanceof' expression.
  external Pointer<NativeFunction<JSObjectHasInstanceCallback>> hasInstance;

  /// The callback invoked when converting an object to a particular JavaScript type.
  external Pointer<NativeFunction<JSObjectConvertToTypeCallback>> convertToType;

  static Pointer<JSClassDefinition> allocate(
    int version,
    int /*JSClassAttributes*/ attributes,
    Pointer<Utf8> className,
    JSClassRef parentClass,
    Pointer<JSStaticValue> staticValues,
    Pointer<JSStaticFunction> staticFunctions,
    Pointer<NativeFunction<JSObjectInitializeCallback>> initialize,
    Pointer<NativeFunction<JSObjectFinalizeCallback>> finalize,
    Pointer<NativeFunction<JSObjectHasPropertyCallback>> hasProperty,
    Pointer<NativeFunction<JSObjectGetPropertyCallback>> getProperty,
    Pointer<NativeFunction<JSObjectSetPropertyCallback>> setProperty,
    Pointer<NativeFunction<JSObjectDeletePropertyCallback>> deleteProperty,
    Pointer<NativeFunction<JSObjectGetPropertyNamesCallback>> getPropertyNames,
    Pointer<NativeFunction<JSObjectCallAsFunctionCallback>> callAsFunction,
    Pointer<NativeFunction<JSObjectCallAsConstructorCallback>> callAsConstructor,
    Pointer<NativeFunction<JSObjectHasInstanceCallback>> hasInstance,
    Pointer<NativeFunction<JSObjectConvertToTypeCallback>> convertToType,
  ) {
    final Pointer<JSClassDefinition> result = calloc.call(1);
    result.ref
      ..version = version
      ..attributes = attributes
      ..className = className
      ..parentClass = parentClass
      ..staticValues = staticValues
      ..staticFunctions = staticFunctions
      ..initialize = initialize
      ..finalize = finalize
      ..hasProperty = hasProperty
      ..getProperty = getProperty
      ..setProperty = setProperty
      ..deleteProperty = deleteProperty
      ..getPropertyNames = getPropertyNames
      ..callAsFunction = callAsFunction
      ..callAsConstructor = callAsConstructor
      ..hasInstance = hasInstance
      ..convertToType = convertToType;
    return result;
  }
}

/// Creates a JavaScript class suitable for use with JSObjectMake.
/// [definition] A JSClassDefinition that defines the class.
/// [@result] A JSClass with the given definition. Ownership follows the Create Rule.
final JSClassRef Function(Pointer<JSClassDefinition> definition) JSClassCreate =
    jscLib.lookup<NativeFunction<JSClassRef Function(Pointer<JSClassDefinition> definition)>>('JSClassCreate').asFunction();

/// Retains a JavaScript class.
/// [jsClass] The JSClass to retain.
/// [@result] A JSClass that is the same as jsClass.
final JSClassRef Function(JSClassRef jsClass) JSClassRetain = jscLib.lookup<NativeFunction<JSClassRef Function(JSClassRef jsClass)>>('JSClassRetain').asFunction();

/// Releases a JavaScript class.
/// [jsClass] The JSClass to release.
final void Function(JSClassRef jsClass) JSClassRelease = jscLib.lookup<NativeFunction<Void Function(JSClassRef jsClass)>>('JSClassRelease').asFunction();

/// Creates a JavaScript object.
/// [ctx] The execution context to use.
/// [jsClass] The JSClass to assign to the object. Pass NULL to use the default object class.
/// [data] A void* to set as the object's private data. Pass NULL to specify no private data.
/// [@result] A JSObject with the given class and private data.
/// [@discussion] The default object class does not allocate storage for private data, so you must provide a non-NULL jsClass to JSObjectMake if you want your object to be able to store private data.
///
/// data is set on the created object before the intialize methods in its class chain are called. This enables the initialize methods to retrieve and manipulate data through JSObjectGetPrivate.
final JSObjectRef Function(JSContextRef ctx, JSClassRef jsClass, Pointer<Void> data) JSObjectMake =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, JSClassRef jsClass, Pointer<Void> data)>>('JSObjectMake').asFunction();

/// Convenience method for creating a JavaScript function with a given callback as its implementation.
/// [ctx] The execution context to use.
/// [name] A JSString containing the function's name. This will be used when converting the function to string. Pass NULL to create an anonymous function.
/// [callAsFunction] The JSObjectCallAsFunctionCallback to invoke when the function is called.
/// [@result] A JSObject that is a function. The object's prototype will be the default function prototype.
final JSObjectRef Function(JSContextRef ctx, JSStringRef name, Pointer<NativeFunction<JSObjectCallAsFunctionCallback>> callAsFunction) JSObjectMakeFunctionWithCallback = jscLib
    .lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, JSStringRef name, Pointer<NativeFunction<JSObjectCallAsFunctionCallback>> callAsFunction)>>('JSObjectMakeFunctionWithCallback')
    .asFunction();

/// Convenience method for creating a JavaScript constructor.
/// [ctx] The execution context to use.
/// [jsClass] A JSClass that is the class your constructor will assign to the objects its constructs. jsClass will be used to set the constructor's .prototype property, and to evaluate 'instanceof' expressions. Pass NULL to use the default object class.
/// [callAsConstructor] A JSObjectCallAsConstructorCallback to invoke when your constructor is used in a 'new' expression. Pass NULL to use the default object constructor.
/// [@result] A JSObject that is a constructor. The object's prototype will be the default object prototype.
/// [@discussion] The default object constructor takes no arguments and constructs an object of class jsClass with no private data. If the constructor is inherited via JS subclassing and the value returned from callAsConstructor was created with jsClass, then the returned object will have it's prototype overridden to the derived class's prototype.
final JSObjectRef Function(JSContextRef ctx, JSClassRef jsClass, Pointer<NativeFunction<JSObjectCallAsConstructorCallback>> callAsConstructor) JSObjectMakeConstructor = jscLib
    .lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, JSClassRef jsClass, Pointer<NativeFunction<JSObjectCallAsConstructorCallback>> callAsConstructor)>>('JSObjectMakeConstructor')
    .asFunction();

/// Creates a JavaScript Array object.
/// [ctx] The execution context to use.
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of data to populate the Array with. Pass NULL if argumentCount is 0.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObject that is an Array.
/// [@discussion] The behavior of this function does not exactly match the behavior of the built-in Array constructor. Specifically, if one argument
/// is supplied, this function returns an array with one element.
final JSObjectRef Function(JSContextRef ctx, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) JSObjectMakeArray =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception)>>('JSObjectMakeArray').asFunction();

/// Creates a JavaScript Date object, as if by invoking the built-in Date constructor.
/// [ctx] The execution context to use.
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of arguments to pass to the Date Constructor. Pass NULL if argumentCount is 0.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObject that is a Date.
final JSObjectRef Function(JSContextRef ctx, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) JSObjectMakeDate =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception)>>('JSObjectMakeDate').asFunction();

/// Creates a JavaScript Error object, as if by invoking the built-in Error constructor.
/// [ctx] The execution context to use.
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of arguments to pass to the Error Constructor. Pass NULL if argumentCount is 0.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObject that is an Error.
final JSObjectRef Function(JSContextRef ctx, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) JSObjectMakeError =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception)>>('JSObjectMakeError').asFunction();

/// Creates a JavaScript RegExp object, as if by invoking the built-in RegExp constructor.
/// [ctx] The execution context to use.
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of arguments to pass to the RegExp Constructor. Pass NULL if argumentCount is 0.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObject that is a RegExp.
final JSObjectRef Function(JSContextRef ctx, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) JSObjectMakeRegExp =
    jscLib.lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception)>>('JSObjectMakeRegExp').asFunction();

/// MacOS 10.15, iOS 13.0
/// Creates a JavaScript promise object by invoking the provided executor.
/// [ctx] The execution context to use.
/// [resolve] A pointer to a JSObjectRef in which to store the resolve function for the new promise. Pass NULL if you do not care to store the resolve callback.
/// [reject] A pointer to a JSObjectRef in which to store the reject function for the new promise. Pass NULL if you do not care to store the reject callback.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] A JSObject that is a promise or NULL if an exception occurred.
final JSObjectRef Function(JSContextRef ctx, Pointer<JSObjectRef> resolve, Pointer<JSObjectRef> reject, Pointer<JSValueRef> exception) JSObjectMakeDeferredPromise = jscLib
    .lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, Pointer<JSObjectRef> resolve, Pointer<JSObjectRef> reject, Pointer<JSValueRef> exception)>>('JSObjectMakeDeferredPromise')
    .asFunction();

/// Creates a function with a given script as its body.
/// [ctx] The execution context to use.
/// [name] A JSString containing the function's name. This will be used when converting the function to string. Pass NULL to create an anonymous function.
/// [parameterCount] An integer count of the number of parameter names in parameterNames.
/// [parameterNames] A JSString array containing the names of the function's parameters. Pass NULL if parameterCount is 0.
/// [body] A JSString containing the script to use as the function's body.
/// [sourceURL] A JSString containing a URL for the script's source file. This is only used when reporting exceptions. Pass NULL if you do not care to include source file information in exceptions.
/// [startingLineNumber] An integer value specifying the script's starting line number in the file located at sourceURL. This is only used when reporting exceptions. The value is one-based, so the first line is line 1 and invalid values are clamped to 1.
/// [exception] A pointer to a JSValueRef in which to store a syntax error exception, if any. Pass NULL if you do not care to store a syntax error exception.
/// [@result] A JSObject that is a function, or NULL if either body or parameterNames contains a syntax error. The object's prototype will be the default function prototype.
/// [@discussion] Use this method when you want to execute a script repeatedly, to avoid the cost of re-parsing the script before each execution.
final JSObjectRef Function(
        JSContextRef ctx, JSStringRef name, int parameterCount, Pointer<JSStringRef> parameterNames, JSStringRef body, JSStringRef sourceURL, int startingLineNumber, Pointer<JSValueRef> exception)
    JSObjectMakeFunction = jscLib
        .lookup<
            NativeFunction<
                JSObjectRef Function(JSContextRef ctx, JSStringRef name, Uint32 parameterCount, Pointer<JSStringRef> parameterNames, JSStringRef body, JSStringRef sourceURL, Int32 startingLineNumber,
                    Pointer<JSValueRef> exception)>>('JSObjectMakeFunction')
        .asFunction();

/// Gets an object's prototype.
/// [ctx] The execution context to use.
/// [object] A JSObject whose prototype you want to get.
/// [@result] A JSValue that is the object's prototype.
final JSValueRef Function(JSContextRef ctx, JSObjectRef object) JSObjectGetPrototype =
    jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSObjectRef object)>>('JSObjectGetPrototype').asFunction();

/// Sets an object's prototype.
/// [ctx] The execution context to use.
/// [object] The JSObject whose prototype you want to set.
/// [value] A JSValue to set as the object's prototype.
final void Function(JSContextRef ctx, JSObjectRef object, JSValueRef value) JSObjectSetPrototype =
    jscLib.lookup<NativeFunction<Void Function(JSContextRef ctx, JSObjectRef object, JSValueRef value)>>('JSObjectSetPrototype').asFunction();

/// Tests whether an object has a given property.
/// [object] The JSObject to test.
/// [propertyName] A JSString containing the property's name.
/// [@result] true if the object has a property whose name matches propertyName, otherwise false.
final bool Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName) JSObjectHasProperty =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName)>>('JSObjectHasProperty').asFunction();

/// Gets a property from an object.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to get.
/// [propertyName] A JSString containing the property's name.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The property's value if object has the property, otherwise the undefined value.
final JSValueRef Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception) JSObjectGetProperty =
    jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception)>>('JSObjectGetProperty').asFunction();

/// Sets a property on an object.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to set.
/// [propertyName] A JSString containing the property's name.
/// [value] A JSValueRef to use as the property's value.
/// [attributes] A logically ORed set of JSPropertyAttributes to give to the property.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
final void Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, int /*JSPropertyAttributes*/ attributes, Pointer<JSValueRef> exception) JSObjectSetProperty =
    jscLib
        .lookup<NativeFunction<Void Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, Uint32 attributes, Pointer<JSValueRef> exception)>>(
            'JSObjectSetProperty')
        .asFunction();

/// Deletes a property from an object.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to delete.
/// [propertyName] A JSString containing the property's name.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] true if the delete operation succeeds, otherwise false (for example, if the property has the kJSPropertyAttributeDontDelete attribute set).
final bool Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception) JSObjectDeleteProperty =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, Pointer<JSValueRef> exception)>>('JSObjectDeleteProperty').asFunction();

/// MacOS 10.15, iOS 13.0
/// Tests whether an object has a given property using a JSValueRef as the property key.
/// [object] The JSObject to test.
/// [propertyKey] A JSValueRef containing the property key to use when looking up the property.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] true if the object has a property whose name matches propertyKey, otherwise false.
/// [@discussion] This function is the same as performing "propertyKey in object" from JavaScript.
final bool Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, Pointer<JSValueRef> exception) JSObjectHasPropertyForKey =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, Pointer<JSValueRef> exception)>>('JSObjectHasPropertyForKey').asFunction();

/// MacOS 10.15, iOS 13.0
/// Gets a property from an object using a JSValueRef as the property key.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to get.
/// [propertyKey] A JSValueRef containing the property key to use when looking up the property.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The property's value if object has the property key, otherwise the undefined value.
/// [@discussion] This function is the same as performing "object[propertyKey]" from JavaScript.
final JSValueRef Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, Pointer<JSValueRef> exception) JSObjectGetPropertyForKey =
    jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, Pointer<JSValueRef> exception)>>('JSObjectGetPropertyForKey').asFunction();

/// MacOS 10.15, iOS 13.0
/// Sets a property on an object using a JSValueRef as the property key.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to set.
/// [propertyKey] A JSValueRef containing the property key to use when looking up the property.
/// [value] A JSValueRef to use as the property's value.
/// [attributes] A logically ORed set of JSPropertyAttributes to give to the property.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@discussion] This function is the same as performing "object[propertyKey] = value" from JavaScript.
final void Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, JSValueRef value, int /*JSPropertyAttributes*/ attributes, Pointer<JSValueRef> exception) JSObjectSetPropertyForKey =
    jscLib
        .lookup<NativeFunction<Void Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, JSValueRef value, Uint32 attributes, Pointer<JSValueRef> exception)>>(
            'JSObjectSetPropertyForKey')
        .asFunction();

/// MacOS 10.15, iOS 13.0
/// Deletes a property from an object using a JSValueRef as the property key.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to delete.
/// [propertyKey] A JSValueRef containing the property key to use when looking up the property.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] true if the delete operation succeeds, otherwise false (for example, if the property has the kJSPropertyAttributeDontDelete attribute set).
/// [@discussion] This function is the same as performing "delete object[propertyKey]" from JavaScript.
final bool Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, Pointer<JSValueRef> exception) JSObjectDeletePropertyForKey =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSObjectRef object, JSValueRef propertyKey, Pointer<JSValueRef> exception)>>('JSObjectDeletePropertyForKey').asFunction();

/// Gets a property from an object by numeric index.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to get.
/// [propertyIndex] An integer value that is the property's name.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The property's value if object has the property, otherwise the undefined value.
/// [@discussion] Calling JSObjectGetPropertyAtIndex is equivalent to calling JSObjectGetProperty with a string containing propertyIndex, but JSObjectGetPropertyAtIndex provides optimized access to numeric properties.
final JSValueRef Function(JSContextRef ctx, JSObjectRef object, int propertyIndex, Pointer<JSValueRef> exception) JSObjectGetPropertyAtIndex =
    jscLib.lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSObjectRef object, Uint32 propertyIndex, Pointer<JSValueRef> exception)>>('JSObjectGetPropertyAtIndex').asFunction();

/// Sets a property on an object by numeric index.
/// [ctx] The execution context to use.
/// [object] The JSObject whose property you want to set.
/// [propertyIndex] The property's name as a number.
/// [value] A JSValue to use as the property's value.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@discussion] Calling JSObjectSetPropertyAtIndex is equivalent to calling JSObjectSetProperty with a string containing propertyIndex, but JSObjectSetPropertyAtIndex provides optimized access to numeric properties.
final void Function(JSContextRef ctx, JSObjectRef object, int propertyIndex, JSValueRef value, Pointer<JSValueRef> exception) JSObjectSetPropertyAtIndex = jscLib
    .lookup<NativeFunction<Void Function(JSContextRef ctx, JSObjectRef object, Uint32 propertyIndex, JSValueRef value, Pointer<JSValueRef> exception)>>('JSObjectSetPropertyAtIndex')
    .asFunction();

/// Gets an object's private data.
/// [object] A JSObject whose private data you want to get.
/// [@result] A void* that is the object's private data, if the object has private data, otherwise NULL.
final Pointer<Void> Function(JSObjectRef object) JSObjectGetPrivate = jscLib.lookup<NativeFunction<Pointer<Void> Function(JSObjectRef object)>>('JSObjectGetPrivate').asFunction();

/// Sets a pointer to private data on an object.
/// [object] The JSObject whose private data you want to set.
/// [data] A void* to set as the object's private data.
/// [@result] true if object can store private data, otherwise false.
/// [@discussion] The default object class does not allocate storage for private data. Only objects created with a non-NULL JSClass can store private data.
final bool Function(JSObjectRef object, Pointer<Void> data) JSObjectSetPrivate =
    jscLib.lookup<NativeFunction<Bool Function(JSObjectRef object, Pointer<Void> data)>>('JSObjectSetPrivate').asFunction();

/// Tests whether an object can be called as a function.
/// [ctx] The execution context to use.
/// [object] The JSObject to test.
/// [@result] true if the object can be called as a function, otherwise false.
final bool Function(JSContextRef ctx, JSObjectRef object) JSObjectIsFunction = jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSObjectRef object)>>('JSObjectIsFunction').asFunction();

/// Calls an object as a function.
/// [ctx] The execution context to use.
/// [object] The JSObject to call as a function.
/// [thisObject] The object to use as "this," or NULL to use the global object as "this."
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of arguments to pass to the function. Pass NULL if argumentCount is 0.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The JSValue that results from calling object as a function, or NULL if an exception is thrown or object is not a function.
final JSValueRef Function(JSContextRef ctx, JSObjectRef object, JSObjectRef thisObject, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) JSObjectCallAsFunction = jscLib
    .lookup<NativeFunction<JSValueRef Function(JSContextRef ctx, JSObjectRef object, JSObjectRef thisObject, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception)>>(
        'JSObjectCallAsFunction')
    .asFunction();

/// Tests whether an object can be called as a constructor.
/// [ctx] The execution context to use.
/// [object] The JSObject to test.
/// [@result] true if the object can be called as a constructor, otherwise false.
final bool Function(JSContextRef ctx, JSObjectRef object) JSObjectIsConstructor =
    jscLib.lookup<NativeFunction<Bool Function(JSContextRef ctx, JSObjectRef object)>>('JSObjectIsConstructor').asFunction();

/// Calls an object as a constructor.
/// [ctx] The execution context to use.
/// [object] The JSObject to call as a constructor.
/// [argumentCount] An integer count of the number of arguments in arguments.
/// [arguments] A JSValue array of arguments to pass to the constructor. Pass NULL if argumentCount is 0.
/// [exception] A pointer to a JSValueRef in which to store an exception, if any. Pass NULL if you do not care to store an exception.
/// [@result] The JSObject that results from calling object as a constructor, or NULL if an exception is thrown or object is not a constructor.
final JSObjectRef Function(JSContextRef ctx, JSObjectRef object, int argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception) JSObjectCallAsConstructor = jscLib
    .lookup<NativeFunction<JSObjectRef Function(JSContextRef ctx, JSObjectRef object, Size argumentCount, Pointer<JSValueRef> arguments, Pointer<JSValueRef> exception)>>('JSObjectCallAsConstructor')
    .asFunction();

/// Gets the names of an object's enumerable properties.
/// [ctx] The execution context to use.
/// [object] The object whose property names you want to get.
/// [@result] A JSPropertyNameArray containing the names object's enumerable properties. Ownership follows the Create Rule.
final JSPropertyNameArrayRef Function(JSContextRef ctx, JSObjectRef object) JSObjectCopyPropertyNames =
    jscLib.lookup<NativeFunction<JSPropertyNameArrayRef Function(JSContextRef ctx, JSObjectRef object)>>('JSObjectCopyPropertyNames').asFunction();

/// Retains a JavaScript property name array.
/// [array] The JSPropertyNameArray to retain.
/// [@result] A JSPropertyNameArray that is the same as array.
final JSPropertyNameArrayRef Function(JSPropertyNameArrayRef array) JSPropertyNameArrayRetain =
    jscLib.lookup<NativeFunction<JSPropertyNameArrayRef Function(JSPropertyNameArrayRef array)>>('JSPropertyNameArrayRetain').asFunction();

/// Releases a JavaScript property name array.
/// [array] The JSPropetyNameArray to release.
final void Function(JSPropertyNameArrayRef array) JSPropertyNameArrayRelease = jscLib.lookup<NativeFunction<Void Function(JSPropertyNameArrayRef array)>>('JSPropertyNameArrayRelease').asFunction();

/// Gets a count of the number of items in a JavaScript property name array.
/// [array] The array from which to retrieve the count.
/// [@result] An integer count of the number of names in array.
final int Function(JSPropertyNameArrayRef array) JSPropertyNameArrayGetCount = jscLib.lookup<NativeFunction<Size Function(JSPropertyNameArrayRef array)>>('JSPropertyNameArrayGetCount').asFunction();

/// Gets a property name at a given index in a JavaScript property name array.
/// [array] The array from which to retrieve the property name.
/// [index] The index of the property name to retrieve.
/// [@result] A JSStringRef containing the property name.
final JSStringRef Function(JSPropertyNameArrayRef array, int index) JSPropertyNameArrayGetNameAtIndex =
    jscLib.lookup<NativeFunction<JSStringRef Function(JSPropertyNameArrayRef array, Size index)>>('JSPropertyNameArrayGetNameAtIndex').asFunction();

/// Adds a property name to a JavaScript property name accumulator.
/// [accumulator] The accumulator object to which to add the property name.
/// [propertyName] The property name to add.
final void Function(JSPropertyNameAccumulatorRef accumulator, JSStringRef propertyName) JSPropertyNameAccumulatorAddName =
    jscLib.lookup<NativeFunction<Void Function(JSPropertyNameAccumulatorRef accumulator, JSStringRef propertyName)>>('JSPropertyNameAccumulatorAddName').asFunction();
