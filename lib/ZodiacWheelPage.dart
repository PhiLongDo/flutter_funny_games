import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:math' as math;

/// 12 Cung Hoàng Đạo
class ZodiacWheelPage extends StatefulWidget {
  const ZodiacWheelPage({Key? key}) : super(key: key);

  @override
  State<ZodiacWheelPage> createState() => _ZodiacWheelPageState();
}

/// The default curve used when spinning a [FortuneWidget].
const Curve spin = Cubic(0, 1.0, 0, 1.0);

/// A curve used for disabling spin animations.
const Curve none = Threshold(0.0);

const Curve sawtooth = SawTooth((1333 * 2222) ~/ 1333);

const duration = Duration(milliseconds: 30);

class _ZodiacWheelPageState extends State<ZodiacWheelPage> {
  var i = 5;
  var _angle = math.pi / 12;
  var _anglePointer = 0.0;
  var _isPlaying = false;

  final _listItem = [
    "Bạch Dương",
    "Kim Ngưu",
    "Song Tử",
    "Cự Giải",
    "Sư Tử",
    "Xử Nữ",
    "Thiên Bình",
    "Thiên Yết",
    "Nhân Mã",
    "Ma Kết",
    "Bảo Bình",
    "Song Ngư"
  ];

  void play() {
    final angleOfItem = ((math.pi * 2) / _listItem.length);
    _isPlaying = true;
    _angle = (angleOfItem / 2);
    _anglePointer = 0;
    final random = math.Random().nextInt(_listItem.length - 1) * angleOfItem +
        (angleOfItem / 2);
    Timer.periodic(duration, (timer) {
      setState(() {
        if (_angle >= (math.pi * 2) * i + random) {
          timer.cancel();
          _anglePointer = 0;
          _isPlaying = false;
        } else {
          _angle = _angle + angleOfItem;
          _anglePointer = (_anglePointer > 0) ? -0.05 : 0.05;
        }
      });
    });
  }

  String getResult() {
    var index = ((_angle / ((math.pi * 2) / _listItem.length)).floor() %
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
            AbsorbPointer(
              absorbing: _isPlaying,
              child: GestureDetector(
                onPanStart: (_) {
                  play();
                },
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Transform.rotate(
                        angle: _angle,
                        child: AnimatedContainer(
                          duration: duration,
                          curve: spin,
                          child: Image.asset(
                            "res/1x/img_zodiac_wheel.png",
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
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
