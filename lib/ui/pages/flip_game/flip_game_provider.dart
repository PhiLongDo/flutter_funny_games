import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'flip_game_state.dart';

class FlipGameProvider extends ChangeNotifier {
  final state = FlipGameState();

  void onTapItem(int y, int x) {
    // Kiem tra viec nhan cung 1 item
    if (state.yPre == y && state.xPre == x) {
      return;
    }

    // mo item va luu lai gia tri cua item vua mo
    state.stateOpened[y][x] = true;
    (state.valueA == "")
        ? state.valueA = state.valueGame[y][x]
        : state.valueB = state.valueGame[y][x];
    notifyListeners();

    // Kiem tra co mo 2 item khong
    if (state.valueB == "") {
      state.xPre = x;
      state.yPre = y;
      return;
    }

    // delay neu mo 2 item
    state.isPause = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (state.valueA == state.valueB) {
        state.itemCanOpenCount -= 2;
        state.stateVisible[y][x] = false;
        state.stateVisible[state.yPre][state.xPre] = false;
      }
      state.isPause = false;
      state.stateOpened[y][x] = false;
      state.stateOpened[state.yPre][state.xPre] = false;
      state.xPre = -1;
      state.yPre = -1;
      state.valueA = "";
      state.valueB = "";
      notifyListeners();
    });
  }

  void reset() {
    state.itemCanOpenCount = FlipGameState.width * FlipGameState.height;
    for (int y = 1; y <= FlipGameState.height; y++) {
      state.stateOpened
          .add(List.generate(FlipGameState.width, (index) => false));
      state.stateVisible
          .add(List.generate(FlipGameState.width, (index) => true));
      state.valueGame.add(List.generate(FlipGameState.width, (index) => ""));
    }

    state.textGame = List.generate(state.itemCanOpenCount, (index) => "");
    List<int> listIndex =
    List.generate(state.itemCanOpenCount, (index) => index);
    for (int i = 0; i < state.itemCanOpenCount; i++) {
      var random = Random();
      var index = random.nextInt(state.itemCanOpenCount - i);
      state.textGame[listIndex[index]] = FlipGameState.listValue[i ~/ 2];
      state.valueGame[listIndex[index] ~/ FlipGameState.width]
      [listIndex[index] % FlipGameState.width] =
      state.textGame[listIndex[index]];
      listIndex.removeAt(index);
    }
    state.isPause = false;
    notifyListeners();
  }
}
