library jsc;

export 'src/js_class.dart' hide JSClassExtension;
export 'src/js_context.dart' hide JSContextExtension;
export 'src/js_context_group.dart' hide JSContextGroupExtension;
export 'src/js_error.dart';
export 'src/js_object.dart'
    hide
        JSStaticValueDelegate,
        JSStaticValueExtension,
        JSStaticValueIterable,
        JSStaticFunctionDelegate,
        JSStaticFunctionExtension,
        JSStaticFunctionIterable,
        JSClassDefinitionExtension,
        JSObjectExtension,
        JSResolveExtension,
        JSRejectExtension;
export 'src/js_property_name_accumulator.dart' hide JSPropertyNameAccumulatorExtension;
export 'src/js_property_name_array.dart' hide JSPropertyNameArrayExtension;
export 'src/js_string.dart' hide JSStringExtension, JSStringIterable;
export 'src/js_value.dart' hide JSValueExtension, JSValueIterable, JSValueConverter;
