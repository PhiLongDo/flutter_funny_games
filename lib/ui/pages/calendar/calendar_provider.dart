import 'package:flutter/material.dart';

import 'calendar_listenner.dart';
import 'calendar_state.dart';

class CalendarProvider extends ChangeNotifier {
  CalendarProvider({this.listener, CalendarState? calendarState}) {
    if (calendarState != null) {
      state = calendarState;
    } else {
      state = CalendarState(initDay: DateTime.now());
    }
  }

  late final CalendarState state;
  final CalendarListener? listener;

  void onDateSelected(int year, int month, int day) {
    state.dateSelected = DateTime(year, month, day);
    notifyListeners();
  }

  void onMonthChanged(int year, int month) {
    state.yearOnView = year;
    state.monthOnView = month;
    notifyListeners();
  }

  void onYearChanged(int year) {
    state.yearOnView = year;
    notifyListeners();
  }

  void onNextMonth() {
    var date = DateTime(state.yearOnView, state.monthOnView);
    date = DateUtils.addMonthsToMonthDate(date, 1);
    onMonthChanged(date.year, date.month);
  }

  void onPreviousMonth() {
    var date = DateTime(state.yearOnView, state.monthOnView);
    date = DateUtils.addMonthsToMonthDate(date, -1);
    onMonthChanged(date.year, date.month);
  }

  void onChangeSelectedDate(DateTime newDate) {
    state.dateSelected = newDate;
    notifyListeners();
  }

  void goToToday() {
    final today = DateTime.now();
    onMonthChanged(today.year, today.month);
  }
}
