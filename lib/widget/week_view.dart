import 'package:custom_calendar/utils/LogUtil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cache_data.dart';
import '../calendar_provider.dart';
import '../configuration.dart';
import '../constants/constants.dart';
import '../model/date_model.dart';
import '../utils/date_util.dart';
import 'month_view.dart';

/**
 * 周视图，只显示本周的日子
 */
class WeekView extends StatefulWidget {
  final int year;
  final int month;
  final DateModel firstDayOfWeek;
  final CalendarConfiguration configuration;

  const WeekView(
      {super.key, required this.year,
      required this.month,
      required this.firstDayOfWeek,
      required this.configuration});

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> with AutomaticKeepAliveClientMixin{
  late List<DateModel> items;

  late Map<DateModel, dynamic> extraDataMap; //自定义额外的数据

  @override
  void initState() {
    super.initState();
    extraDataMap = widget.configuration.extraDataMap;
    items = DateUtil.initCalendarForWeekView(
        widget.year, widget.month, widget.firstDayOfWeek.getDateTime(), 0,
        minSelectDate: widget.configuration.minSelectDate,
        maxSelectDate: widget.configuration.maxSelectDate,
        extraDataMap: extraDataMap,
        offset: widget.configuration.offset);

    if (CacheData.getInstance().weekListCache[widget.firstDayOfWeek]?.isNotEmpty ==
        true) {
      LogUtil.log(TAG: this.runtimeType, message: "缓存中有数据");
      items = CacheData.getInstance().weekListCache[widget.firstDayOfWeek]!;
    } else {
      LogUtil.log(TAG: this.runtimeType, message: "缓存中无数据");
      getItems().then((_) {
        CacheData.getInstance().weekListCache[widget.firstDayOfWeek] = items;
      });
    }

    //第一帧后,添加监听，generation发生变化后，需要刷新整个日历
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Provider.of<CalendarProvider>(context, listen: false)
          .generation
          .addListener(() async {
        extraDataMap = widget.configuration.extraDataMap;
        await getItems();
      });
    });
  }

  Future getItems() async {
    items = await compute(initCalendarForWeekView, {
      'year': widget.year,
      'month': widget.month,
      'currentDate': widget.firstDayOfWeek.getDateTime(),
      'minSelectDate': widget.configuration.minSelectDate,
      'maxSelectDate': widget.configuration.maxSelectDate,
      'extraDataMap': extraDataMap,
      'offset': widget.configuration.offset
    });
    setState(() {});
  }

  static Future<List<DateModel>> initCalendarForWeekView(Map map) async {
    return DateUtil.initCalendarForWeekView(
        map['year'], map['month'], map['currentDate'], 0,
        minSelectDate: map['minSelectDate'],
        maxSelectDate: map['maxSelectDate'],
        extraDataMap: map['extraDataMap'],
        offset: map['offset']);
  }

  @override
  Widget build(BuildContext context) {
    CalendarProvider calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);

    CalendarConfiguration configuration =
        calendarProvider.calendarConfiguration;
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 10),
        itemCount: 7,
        itemBuilder: (context, index) {
          DateModel dateModel = items[index];
          //判断是否被选择
          switch (configuration.selectMode) {
            case CalendarSelectedMode.multiSelect:
              if (calendarProvider.selectedDateList!.contains(dateModel)) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false;
              }
              break;
            case CalendarSelectedMode.singleSelect:
              if (calendarProvider.selectDateModel == dateModel) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false;
              }
              break;
            case CalendarSelectedMode.mutltiStartToEndSelect:
              if (calendarProvider.selectedDateList!.contains(dateModel)) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false;
              }
              break;
          }

          return ItemContainer(
              dateModel: dateModel,
              expand: false,
              key: ObjectKey(dateModel),
              clickCall: () {
                setState(() {});
              });
        });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    LogUtil.log(TAG: runtimeType, message: "dispose");
    super.dispose();
  }
}
