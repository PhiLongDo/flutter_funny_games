//TODO: Chỉ khả thi khi app ở foreground, background (pause). Khi app bị terminate thì không sẽ bị dừng.

import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

const backgroundKey = "BACKGROUND_KEY";

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var backgroundValue = prefs.getString(backgroundKey) ?? "";
    await prefs.setString(backgroundKey,
        " $backgroundValue Headless task timed-out: $taskId(${DateTime.now()})\n");

    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var backgroundValue = prefs.getString(backgroundKey) ?? "";
  await prefs.setString(backgroundKey,
      "$backgroundValue Headless event received:$taskId(${DateTime.now()})\n");
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

Future<void> initBackgroundFetch() async {
  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

Future<void> configureBackgroundFetch() async {
  // Configure BackgroundFetch.
  int status = await BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
    ),
    //region Event handler
    // This is the fetch-event callback.
    (String taskId) async {
      print("[BackgroundFetch] Event received $taskId");

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var backgroundValue = prefs.getString(backgroundKey) ?? "";
      await prefs.setString(backgroundKey,
          "$backgroundValue received: $taskId(${DateTime.now()})\n");
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);

      // loop
      startBackgroundFetch();
    },
    //endregion
    //region Task timeout handler.
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    (String taskId) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var backgroundValue = prefs.getString(backgroundKey) ?? "";
      await prefs.setString(backgroundKey,
          "$backgroundValue TIMEOUT:$taskId(${DateTime.now()})\n");
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");

      BackgroundFetch.finish(taskId);
    },
    //endregion
  );
  print('[BackgroundFetch] configure success: $status');
}

Future<void> startBackgroundFetch() async {
  BackgroundFetch.start().then((int status) {
    print('[BackgroundFetch] start success: $status');
  }).catchError((e) {
    print('[BackgroundFetch] start FAILURE: $e');
  });
}

Future<void> stopBackgroundFetch() async {
  BackgroundFetch.stop().then((int status) {
    print('[BackgroundFetch] stop success: $status');
  }).catchError((e) {
    print('[BackgroundFetch] stop FAILURE: $e');
  });
}
