#import "PepcepFlutterPlugin.h"
#if __has_include(<pepcep_flutter/pepcep_flutter-Swift.h>)
#import <pepcep_flutter/pepcep_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pepcep_flutter-Swift.h"
#endif

@implementation PepcepFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPepcepFlutterPlugin registerWithRegistrar:registrar];
}
@end
