import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toss_coin/ui/pages/draw/draw_view.dart';
import 'package:toss_coin/ui/pages/flip_game/flip_game_view.dart';
import 'package:toss_coin/ui/pages/home/home_view.dart';
import 'package:toss_coin/ui/pages/zodiac_wheel/zodiac_wheel_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "root",
      routes: {
        "root": (context) => const HomePage(),
        "flip": (context) => const FlipGamePage(),
        "wheel": (context) => const ZodiacWheelPage(),
        "draw": (context) => const DrawPage(),
      },
    );
  }
}
