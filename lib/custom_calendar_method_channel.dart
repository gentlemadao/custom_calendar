import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'custom_calendar_platform_interface.dart';

/// An implementation of [CustomCalendarPlatform] that uses method channels.
class MethodChannelCustomCalendar extends CustomCalendarPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('custom_calendar');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
