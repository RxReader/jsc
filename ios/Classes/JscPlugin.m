#import "JscPlugin.h"
#if __has_include(<jsc/jsc-Swift.h>)
#import <jsc/jsc-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "jsc-Swift.h"
#endif

@implementation JscPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [SwiftJscPlugin registerWithRegistrar:registrar];
}
@end
