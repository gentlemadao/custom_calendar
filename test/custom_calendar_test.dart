import 'package:flutter_test/flutter_test.dart';
import 'package:custom_calendar/custom_calendar.dart';
import 'package:custom_calendar/custom_calendar_platform_interface.dart';
import 'package:custom_calendar/custom_calendar_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCustomCalendarPlatform
    with MockPlatformInterfaceMixin
    implements CustomCalendarPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CustomCalendarPlatform initialPlatform = CustomCalendarPlatform.instance;

  test('$MethodChannelCustomCalendar is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCustomCalendar>());
  });

  test('getPlatformVersion', () async {
    CustomCalendar customCalendarPlugin = CustomCalendar();
    MockCustomCalendarPlatform fakePlatform = MockCustomCalendarPlatform();
    CustomCalendarPlatform.instance = fakePlatform;

    expect(await customCalendarPlugin.getPlatformVersion(), '42');
  });
}
