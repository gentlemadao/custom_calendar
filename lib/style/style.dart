import 'package:flutter/material.dart';

//顶部7天的文案
TextStyle topWeekTextStyle = const TextStyle(fontSize: 14);

//当前月份的日期的文字
TextStyle currentMonthTextStyle =
    const TextStyle(color: Colors.black, fontSize: 16);

//下一个月或者上一个月的日期的文字
TextStyle preOrNextMonthTextStyle =
    const TextStyle(color: Colors.grey, fontSize: 18);

//农历的字体
TextStyle lunarTextStyle = const TextStyle(color: Colors.grey, fontSize: 12);

//不是当前月份的日期的文字
TextStyle notCurrentMonthTextStyle =
    const TextStyle(color: Colors.grey, fontSize: 16);

TextStyle currentDayTextStyle =
    const TextStyle(color: Colors.red, fontSize: 16);
