import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_listenner.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_state.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_theme.dart';
import 'package:toss_coin/ui/pages/calendar/components/month_view.dart';
import 'package:tuple/tuple.dart';

import 'calendar_provider.dart';

class CalendarView extends StatelessWidget {
  const CalendarView(
      {super.key,
      this.listener,
      this.initDay,
      this.theme = defaultCalendarTheme});

  final CalendarListener? listener;
  final DateTime? initDay;
  final CalendarTheme theme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CalendarProvider(
        listener: listener,
        calendarState: CalendarState(initDay: initDay),
      ),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Selector<CalendarProvider, Tuple3<DateTime, int, int>>(
      selector: (_, provider) => Tuple3(
        provider.state.dateSelected,
        provider.state.yearOnView,
        provider.state.monthOnView,
      ),
      builder: (context, tuple, _) {
        final provider =
            context.select((CalendarProvider provider) => provider);
        return Stack(
          children: [
            MonthView(
              state: provider.state,
              onPreviousMonth: provider.onPreviousMonth,
              onNextMonth: provider.onNextMonth,
              theme: theme,
              onChangeSelectedDate: provider.onChangeSelectedDate,
              goToToday: provider.goToToday,
            ),
            Container(),
          ],
        );
      },
    );
  }
}
