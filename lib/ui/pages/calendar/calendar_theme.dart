import 'package:flutter/material.dart';

import 'calendar_common.dart';

class CalendarTheme {
  const CalendarTheme({
    this.fontSizeBig = 18,
    this.fontSizeSmall = 12,
    this.fontSizeNormal = 16,
    this.normalTextColor = Colors.black,
    this.normalBackgroundColor = Colors.white,
    this.normalFontStyle = FontStyle.normal,
    this.sunTextColor = Colors.red,
    this.sunBackgroundColor = Colors.white,
    this.sunFontStyle = FontStyle.normal,
    this.satTextColor = Colors.orange,
    this.satBackgroundColor = Colors.white,
    this.satFontStyle = FontStyle.normal,
    this.dayStartOfWeek = DayOfWeek.monday,
    this.daySelectedColor = Colors.cyan,
    this.todayBorderColor = Colors.blue,
  });

  final double fontSizeNormal;
  final double fontSizeBig;
  final double fontSizeSmall;

  final Color normalTextColor;
  final Color normalBackgroundColor;
  final FontStyle normalFontStyle;

  final DayOfWeek dayStartOfWeek;

  final Color daySelectedColor;
  final Color todayBorderColor;

  /// Sunday text color
  final Color sunTextColor;
  final Color sunBackgroundColor;
  final FontStyle sunFontStyle;

  /// Saturday text color
  final Color satTextColor;
  final Color satBackgroundColor;
  final FontStyle satFontStyle;
}

const defaultCalendarTheme = CalendarTheme();
