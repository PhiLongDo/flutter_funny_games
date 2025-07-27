import 'package:flutter/material.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_state.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_theme.dart';
import 'package:toss_coin/ui/pages/calendar/components/month_header.dart';
import 'package:toss_coin/ui/pages/calendar/components/week_view.dart';

class MonthView extends StatelessWidget {
  const MonthView(
      {super.key,
      this.theme = defaultCalendarTheme,
      required this.state,
      this.onNextMonth,
      this.onPreviousMonth,
      this.onChangeSelectedDate,
      this.goToToday});

  final CalendarTheme theme;
  final CalendarState state;
  final VoidCallback? onNextMonth;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? goToToday;
  final Function(DateTime newDate)? onChangeSelectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthHeader(
          currentDay: DateTime(state.yearOnView, state.monthOnView),
          onNextMonth: onNextMonth,
          onPreviousMonth: onPreviousMonth,
          goToToday: goToToday,
        ),
        const SizedBox(height: 16),
        WeekView(
          state: state,
          theme: theme,
          onChangeSelectedDate: onChangeSelectedDate,
        ),
      ],
    );
  }
}
