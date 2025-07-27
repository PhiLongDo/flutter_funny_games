import 'package:flutter/material.dart';

class CalendarState {
  DateTime dateSelected = DateTime.now();
  int yearOnView = DateTime.now().year;
  int monthOnView = DateTime.now().month;

  CalendarState({DateTime? initDay}) {
    if (initDay != null) {
      dateSelected = initDay;
      yearOnView = initDay.year;
      monthOnView = initDay.month;
    }
  }

  int get dayInMonthOnView => DateUtils.getDaysInMonth(yearOnView, monthOnView);

  int firstDayOffsetInMonthOnView(int dayStartOfWeek) {
    var delta = (7 - dayStartOfWeek + 1) % 7;
    var offset = DateTime(yearOnView, monthOnView).weekday;
    offset = offset + delta;
    return offset > 7 ? offset - 7 : offset;
  }
}
