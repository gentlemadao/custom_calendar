import 'dart:collection';

import 'package:custom_calendar/constants/constants.dart';
import 'package:custom_calendar/controller.dart';
import 'package:custom_calendar/model/date_model.dart';
import 'package:custom_calendar/utils/LogUtil.dart';
import 'package:custom_calendar/widget/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          focusColor: Colors.teal),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalendarController controller;
  late CalendarViewWidget calendar;
  HashSet<DateTime> _selectedDate = new HashSet();
  HashSet<DateModel> _selectedModels = new HashSet();

  GlobalKey<CalendarContainerState> _globalKey = new GlobalKey();

  @override
  void initState() {
    _selectedDate.add(DateTime.now());
    controller = CalendarController(
      minYear: 2022,
      minYearMonth: 1,
      nowYear: DateTime.now().year,
      maxYearMonth: 12,
      showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK,
      selectedDateTimeList: _selectedDate,
      selectMode: CalendarSelectedMode.singleSelect,
      nowMonth: DateTime.now().month,
      offset: 1,
    )
      ..addOnCalendarSelectListener((dateModel) {
        _selectedModels.add(dateModel);
        DateTime day = DateTime(dateModel.year, dateModel.month, dateModel.day);
        print("dayInWeek : ${day.weekday}");
        setState(() {
          _selectDate = _selectedModels.toString();
        });
      })
      ..addOnCalendarUnSelectListener((dateModel) {
        LogUtil.log(
            TAG: '_selectedModels', message: _selectedModels.toString());
        LogUtil.log(TAG: 'dateModel', message: dateModel.toString());
        if (_selectedModels.contains(dateModel)) {
          _selectedModels.remove(dateModel);
        }
        setState(() {
          _selectDate = '';
        });
      });
    controller
        .changeExtraData({DateModel.fromDateTime(DateTime(2022, 10, 28)): 3});
    calendar = CalendarViewWidget(
      key: _globalKey,
      calendarController: controller,
      dayWidgetBuilder: (DateModel model) {
        double wd = (MediaQuery.of(context).size.width - 20) / 7;
        bool _isSelected = model.isSelected;
        if (_isSelected &&
            CalendarSelectedMode.singleSelect ==
                controller.calendarConfiguration.selectMode) {
          _selectDate = model.toString();
        }
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(wd / 2)),
          child: Container(
            color: _isSelected ? Theme.of(context).focusColor : Colors.white,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  model.day.toString(),
                  style: TextStyle(
                      color: model.isCurrentMonth
                          ? (_isSelected == false
                              ? Colors.black87
                              : Colors.white)
                          : Colors.black38),
                ),
                Text(
                  model.lunarString.toString(),
                  style: TextStyle(
                      color: model.isCurrentMonth
                          ? (_isSelected == false
                              ? Colors.black87
                              : Colors.white)
                          : Colors.black38),
                ),
                if(model.extraData != null)
                  Container(
                    color: Colors.green,
                    width: 5,
                    height: 5,
                  ),
              ],
            ),
          ),
        );
      },
      boxDecoration: BoxDecoration(color: Colors.white),
      itemSize: 60,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addExpandChangeListener((value) {
        /// 添加改变 月视图和 周视图的监听
        _isMonthSelected = value;
        setState(() {});
      });
    });

    super.initState();
  }

  bool _isMonthSelected = false;

  String _selectDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            _topButtons(),
            _topMonths(),
            SliverToBoxAdapter(
              child: calendar,
            ),
            SliverToBoxAdapter(
              child: Container(
                child: Text(
                  ' $_selectDate ',
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _topButtons() {
    return SliverToBoxAdapter(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          Text('请选择mode'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              ElevatedButton(
                child: Text(
                  '单选',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    controller.calendarConfiguration.selectMode =
                        CalendarSelectedMode.singleSelect;
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                  '多选',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    controller.calendarConfiguration.selectMode =
                        CalendarSelectedMode.multiSelect;
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                  '多选 选择开始和结束',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    controller.calendarConfiguration.selectMode =
                        CalendarSelectedMode.mutltiStartToEndSelect;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topMonths() {
    return SliverToBoxAdapter(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          Text('月视图和周视图'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              ElevatedButton(
                child: Text(
                  '月视图',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    controller.weekAndMonthViewChange(
                        CalendarConstants.MODE_SHOW_ONLY_WEEK);
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                  '周视图',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    controller.weekAndMonthViewChange(
                        CalendarConstants.MODE_SHOW_ONLY_MONTH);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
