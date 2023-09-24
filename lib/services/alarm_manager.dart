// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const alarmKey = "ALARM_KEY";
const alarmManagerId = 101010;

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

// The background
SendPort? uiSendPort;

@pragma('vm:entry-point')
Future<void> alarmTask() async {
  final DateTime now = DateTime.now();
  // final int isolateId = Isolate.current.hashCode;
  print("alarmTask executed ($now)");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var alarmValue = prefs.getString(alarmKey) ?? "";
  await prefs.setString(alarmKey, "$alarmValue alarmTask executed ($now)\n");
  uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
  uiSendPort?.send(null);
}

Future<void> startAlarmTask() async {
  // alarmTask will then run (roughly) every minute, even if the main app ends
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), alarmManagerId, alarmTask);
}

Future<void> cancelAlarmTask() async {
  await AndroidAlarmManager.cancel(alarmManagerId);
}
