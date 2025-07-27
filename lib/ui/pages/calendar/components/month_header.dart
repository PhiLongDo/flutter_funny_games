import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader(
      {super.key,
      this.onNextMonth,
      this.onPreviousMonth,
      required this.currentDay,
      this.goToToday});

  final VoidCallback? onNextMonth;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? goToToday;
  final DateTime currentDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: onPreviousMonth,
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.cyan,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            DateFormat("MMMM yyyy").format(currentDay),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: onNextMonth,
            child: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.cyan,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: goToToday,
              child: const Text(
                "today",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
