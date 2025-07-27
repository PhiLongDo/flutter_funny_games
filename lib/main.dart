import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toss_coin/services/background_fetch.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_common.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_theme.dart';
import 'package:toss_coin/ui/pages/calendar/calendar_view.dart';
import 'package:toss_coin/ui/pages/camera/camera_view.dart';
import 'package:toss_coin/ui/pages/draw/draw_view.dart';
import 'package:toss_coin/ui/pages/flip_game/flip_game_view.dart';
import 'package:toss_coin/ui/pages/home/home_view.dart';
import 'package:toss_coin/ui/pages/nonogram/nonogram_game.dart';
import 'package:toss_coin/ui/pages/zodiac_wheel/zodiac_wheel_view.dart';
import 'package:toss_coin/ui/widgets/CustomMaterialPageRoute.dart';
import 'package:toss_coin/ui/widgets/app_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  if (Platform.isAndroid) {
    // init AndroidAlarmManager
    await AndroidAlarmManager.initialize();
  }

  if (Platform.isIOS) {
    // init BackgroundFetch
    initBackgroundFetch();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "root",
      // routes: {
      //   "root": (context) => const HomePage(),
      //   "flip": (context) => const FlipGamePage(),
      //   "wheel": (context) => const ZodiacWheelPage(),
      //   "draw": (context) => const DrawPage(),
      // },
      onGenerateRoute: (settings) {
        if (settings.name == "wheel") {
          return CustomPageRoute(
            builder: (_) => const ZodiacWheelPage(),
          );
        }
        switch (settings.name) {
          case "root":
            return MaterialPageRoute(builder: (_) => const HomePage());
          case "flip":
            return CustomPageRoute(
              builder: (_) => const FlipGamePage(),
            );
          case "draw":
            return MaterialPageRoute(builder: (_) => const DrawPage());
          case "camera":
            return CustomPageRoute(builder: (_) => const CameraPage());
          case "nonogram":
            return CustomPageRoute(builder: (_) => const NonogramPage());
          case "calendar":
            return CustomPageRoute(
                builder: (_) => const AppContainer(
                        child: Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: CalendarView(
                        theme: CalendarTheme(dayStartOfWeek: DayOfWeek.sunday),
                      ),
                    )));
          default:
            return null;
        }
      },
    );
  }
}
