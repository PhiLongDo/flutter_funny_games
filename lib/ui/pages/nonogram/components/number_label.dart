import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../nonogram_game.dart';

class NumberLabel extends PositionComponent with HasGameRef<NonogramGame> {
  NumberLabel({
    required super.position,
    required this.number,
    this.row,
    this.col,
  }) : super(
          size: Vector2(
              NonogramGame.cellWidth * 0.5, NonogramGame.cellWidth * 0.5),
          anchor: Anchor.topCenter,
        );
  final int number;

  final int? row;
  final int? col;

  var _textColor = const Color.fromARGB(255, 12, 12, 12);
  void changeTextToGray() {
    _textColor = const Color.fromARGB(255, 155, 155, 155);
  }

  void changeTextToBlack() {
    _textColor = const Color.fromARGB(255, 12, 12, 12);
  }

  late final TextComponent _textComponent;
  @override
  FutureOr<void> onLoad() {
    _textComponent = TextComponent(
      text: '$number',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 400,
          color: _textColor,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 20),
    );
    add(_textComponent);
  }

  @override
  void update(double dt) {
    _textComponent.textRenderer = TextPaint(
      style: TextStyle(
        fontSize: 400,
        color: _textColor,
      ),
    );
  }
}
