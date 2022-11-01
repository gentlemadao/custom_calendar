import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'custom_calendar_method_channel.dart';

abstract class CustomCalendarPlatform extends PlatformInterface {
  /// Constructs a CustomCalendarPlatform.
  CustomCalendarPlatform() : super(token: _token);

  static final Object _token = Object();

  static CustomCalendarPlatform _instance = MethodChannelCustomCalendar();

  /// The default instance of [CustomCalendarPlatform] to use.
  ///
  /// Defaults to [MethodChannelCustomCalendar].
  static CustomCalendarPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CustomCalendarPlatform] when
  /// they register themselves.
  static set instance(CustomCalendarPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
