import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'zodiac_wheel_state.dart';

const duration = Duration(milliseconds: 30);

class ZodiacWheelProvider extends ChangeNotifier {
  final state = ZodiacWheelState();

  void play() {
    final angleOfItem = ((math.pi * 2) / state.listItem.length);
    state.isPlaying = true;
    state.angle = (angleOfItem / 2);
    state.anglePointer = 0;
    final random =
        math.Random().nextInt(state.listItem.length - 1) * angleOfItem +
            (angleOfItem / 2);
    Timer.periodic(duration, (timer) {
      if (state.angle >= (math.pi * 2) * state.round + random) {
        timer.cancel();
        state.anglePointer = 0;
        state.isPlaying = false;
        notifyListeners();
      } else {
        state.angle = state.angle + angleOfItem;
        state.anglePointer = (state.anglePointer > 0) ? -0.05 : 0.05;
        notifyListeners();
      }
    });
  }

  void setListItem(List<String> newList) {
    state.listItem = newList;
    notifyListeners();
  }

  void setImgWheel(String newImg) {
    state.imgWheel = newImg;
    notifyListeners();
  }

  void setImgPointer(String newImg) {
    state.imgPointer = newImg;
    notifyListeners();
  }
}
