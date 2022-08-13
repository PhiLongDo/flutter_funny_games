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

const duration = Duration(milliseconds: 100);

class _MyHomePageState extends State<MyHomePage> {
  var i = 5;
  var _angle = 0.0;
  var _anglePointer = 0.0;

  void play() {
    _angle = 360.0 * i;
    _anglePointer = 0;
    Timer.periodic(duration, (timer) {
      setState(() {
        if (_angle <= 0) {
          timer.cancel();
          _anglePointer = 0;
        } else {
          _angle = _angle - 36;
          _anglePointer = (_anglePointer > 0) ? -0.05 : 0.05;
        }
      });
    });
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
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Transform.translate(
                    offset: const Offset(0, 30),
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
                ),
                Transform.rotate(
                  angle: _anglePointer,
                  child: AnimatedContainer(
                    curve: none,
                    duration: Duration.zero,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
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
