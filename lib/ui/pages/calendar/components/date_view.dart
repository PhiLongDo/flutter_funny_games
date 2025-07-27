import 'package:flutter/material.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_theme.dart';

class DateView extends StatelessWidget {
  const DateView(
      {super.key,
      this.theme = defaultCalendarTheme,
      required this.date,
      this.onSelected,
      this.isSelected = false});

  final CalendarTheme theme;
  final DateTime date;
  final VoidCallback? onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    var color = theme.normalTextColor;
    var fonStyle = theme.normalFontStyle;
    if (date.weekday == DateTime.sunday) {
      color = theme.sunTextColor;
      fonStyle = theme.sunFontStyle;
    }
    if (date.weekday == DateTime.saturday) {
      color = theme.satTextColor;
      fonStyle = theme.satFontStyle;
    }
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: DateUtils.isSameDay(date, DateTime.now())
              ? Border.all(color: theme.todayBorderColor)
              : const Border(),
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? theme.daySelectedColor : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          "${date.day}",
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontStyle: fonStyle,
            fontSize: theme.fontSizeNormal,
          ),
        ),
      ),
    );
  }
}
