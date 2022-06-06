#import "JsxPlugin.h"
#if __has_include(<jsx/jsx-Swift.h>)
#import <jsx/jsx-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "jsx-Swift.h"
#endif

@implementation JsxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [SwiftJsxPlugin registerWithRegistrar:registrar];
}
@end
