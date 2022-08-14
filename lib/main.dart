import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as _math;

void main() {
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// The default curve used when spinning a [FortuneWidget].
const Curve spin = Cubic(0, 1.0, 0, 1.0);

/// A curve used for disabling spin animations.
const Curve none = Threshold(0.0);

const Curve sawtooth = SawTooth((1333 * 2222) ~/ 1333);

const duration = Duration(milliseconds: 30);

class _MyHomePageState extends State<MyHomePage> {
  var i = 10;
  var _angle = _math.pi / 12;
  var _anglePointer = 0.0;

  final _listItem = ["😾", "🪐", "🍭", "⭐", "🌞", "🌈", "☁️", "👓"];

  void play() {
    _angle = _math.pi;
    _anglePointer = 0;
    var random =
        _math.Random().nextInt(7) * ((_math.pi * 2) / _listItem.length) + 0.01;
    Timer.periodic(duration, (timer) {
      setState(() {
        if (_angle >= _math.pi * 2 * i + random) {
          timer.cancel();
          _anglePointer = 0;
        } else {
          _angle = _angle + (_math.pi * 2 / 10);
          _anglePointer = (_anglePointer > 0) ? -0.05 : 0.05;
        }
      });
    });
  }

  String getResult() {
    var index = ((_angle / ((_math.pi * 2) / _listItem.length)).floor() %
        _listItem.length);
    return _listItem[_listItem.length - index - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              child: Text(
                getResult(),
                style: const TextStyle(fontSize: 36),
              ),
            ),
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Transform.rotate(
                    angle: _angle,
                    child: AnimatedContainer(
                      duration: duration,
                      curve: spin,
                      child: Image.asset(
                        "res/1x/img_round.png",
                      ),
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: _anglePointer,
                  child: AnimatedContainer(
                    curve: none,
                    duration: Duration.zero,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      height: 60,
                      "res/1x/img_pointer.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: MaterialButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                onPressed: play,
                color: Colors.cyan,
                textColor: Colors.white,
                child: const Text(
                  "Play",
                  style: TextStyle(fontSize: 36),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
