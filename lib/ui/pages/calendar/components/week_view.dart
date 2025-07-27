import 'package:flutter/material.dart';
import 'package:toss_coin/ui/pages/calendar/components/date_view.dart';
import 'package:toss_coin/ui/pages/calendar/components/week_header.dart';

import '../calendar_state.dart';
import '../calendar_theme.dart';

class WeekView extends StatelessWidget {
  const WeekView(
      {super.key,
      this.theme = defaultCalendarTheme,
      required this.state,
      this.onChangeSelectedDate});

  final CalendarTheme theme;
  final CalendarState state;
  final Function(DateTime newDate)? onChangeSelectedDate;

  @override
  Widget build(BuildContext context) {
    var firstDayOffset =
        state.firstDayOffsetInMonthOnView(theme.dayStartOfWeek.value);
    return Column(
      children: [
        WeekHeader(theme: theme),
        const SizedBox(height: 3),
        GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7),
            itemCount: state.dayInMonthOnView + firstDayOffset - 1,
            itemBuilder: (ctx, index) {
              final date = DateTime(state.yearOnView, state.monthOnView,
                  index + 1 - firstDayOffset + 1);
              return index + 1 < firstDayOffset
                  ? Container()
                  : DateView(
                      date: date,
                      onSelected: () {
                        if (onChangeSelectedDate != null) {
                          onChangeSelectedDate!(date);
                        }
                      },
                      isSelected: DateUtils.isSameDay(state.dateSelected, date),
                    );
            }),
      ],
    );
  }
}
