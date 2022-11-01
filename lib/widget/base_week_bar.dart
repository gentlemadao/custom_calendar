import 'package:flutter/material.dart';

/**
 * 顶部的固定的周显示
 */
abstract class BaseWeekBar extends StatelessWidget {
  const BaseWeekBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: getWeekDayWidget(),
      ),
    );
  }

  Widget getWeekBarItem(int index);

  List<Widget> getWeekDayWidget() {
    return List.generate(7, (index) {
      return getChild(index);
    });
  }

  Widget getChild(int index) {
    return Expanded(
      child: getWeekBarItem(index),
    );
  }
}
