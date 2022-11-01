#import "CustomCalendarPlugin.h"
#if __has_include(<custom_calendar/custom_calendar-Swift.h>)
#import <custom_calendar/custom_calendar-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "custom_calendar-Swift.h"
#endif

@implementation CustomCalendarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCustomCalendarPlugin registerWithRegistrar:registrar];
}
@end
