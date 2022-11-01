
import 'custom_calendar_platform_interface.dart';

export 'controller.dart';
export 'widget/calendar_view.dart';
export 'widget/base_day_view.dart';
export 'widget/base_week_bar.dart';
export 'constants/constants.dart';
export 'model/date_model.dart';
export 'widget/default_combine_day_view.dart';
export 'widget/default_custom_day_view.dart';
export 'widget/default_week_bar.dart';
export 'configuration.dart';

export 'configuration.dart';
export 'calendar_provider.dart';
export 'constants/constants.dart';
export 'widget/base_day_view.dart';

class CustomCalendar {
  Future<String?> getPlatformVersion() {
    return CustomCalendarPlatform.instance.getPlatformVersion();
  }
}
