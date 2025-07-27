import 'package:flutter/material.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_common.dart';

import '../calendar_theme.dart';

class WeekHeader extends StatelessWidget {
  const WeekHeader({super.key, this.theme = defaultCalendarTheme});

  final CalendarTheme theme;

  @override
  Widget build(BuildContext context) {
    const listNumDayOfWeek = [7, 1, 2, 3, 4, 5, 6];
    return Row(
      children: listNumDayOfWeek.map(
        (i) {
          var day = DayOfWeek.values[((i + theme.dayStartOfWeek.value) % 7)];
          var color = theme.normalTextColor;
          var fonStyle = theme.normalFontStyle;
          if (day == DayOfWeek.sunday) {
            color = theme.sunTextColor;
            fonStyle = theme.sunFontStyle;
          }
          if (day == DayOfWeek.saturday) {
            color = theme.satTextColor;
            fonStyle = theme.satFontStyle;
          }
          return Expanded(
            child: Center(
              child: Text(
                day.shortName,
                style: TextStyle(
                    color: color,
                    fontStyle: fonStyle,
                    fontSize: theme.fontSizeBig,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
