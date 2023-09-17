import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../nonogram_game.dart';
import 'cell.dart';

class CellTypeToggle extends PositionComponent
    with HasGameRef<NonogramGame>, TapCallbacks {
  CellTypeToggle()
      : super(
            size: Vector2(
                NonogramGame.toolbarHeight * 7, NonogramGame.toolbarHeight),
            position: Vector2(0, 0));

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..color = Colors.blueGrey;

  final _backgroundPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  final _colorPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.pinkAccent;

  final _shadowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 50
    ..color = Colors.grey;

  final _crossPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 50
    ..color = Colors.white;

  final _backgroundCrossPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;

  var cellTypeSelected = CellType.color;
  late final TextComponent _textComponent;

  @override
  FutureOr<void> onLoad() {
    _textComponent = TextBoxComponent(
      text: cellTypeSelected.text,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 350,
          color: Color.fromRGBO(48, 48, 48, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
      size: Vector2(
          NonogramGame.toolbarHeight * 5, NonogramGame.toolbarHeight * 0.5),
      position: Vector2(
          NonogramGame.toolbarHeight * 2, NonogramGame.toolbarHeight * 0.25),
    );
    add(_textComponent);
  }

  @override
  void update(double dt) {
    _textComponent.text = cellTypeSelected.text;
  }

  @override
  void render(Canvas canvas) {
    const toggleWidth = NonogramGame.toolbarHeight * 2;
    var rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(NonogramGame.toolbarHeight * 0.1,
          NonogramGame.toolbarHeight * 0.1, toggleWidth * 0.8, height * 0.8),
      const Radius.circular(toggleWidth * 0.5),
    );
    canvas.drawRRect(rrect, _borderPaint);
    canvas.drawRRect(rrect, _backgroundPaint);
    if (cellTypeSelected == CellType.color) {
      canvas.drawCircle(Offset(toggleWidth * 0.25, height * 0.525),
          height * 0.4, _colorPaint);
      canvas.drawCircle(Offset(toggleWidth * 0.25, height * 0.525),
          height * 0.4, _shadowPaint);
    }
    if (cellTypeSelected == CellType.cross) {
      canvas.drawCircle(Offset(toggleWidth * 0.75, height * 0.525),
          height * 0.4, _backgroundCrossPaint);
      canvas.drawCircle(Offset(toggleWidth * 0.75, height * 0.525),
          height * 0.4, _shadowPaint);

      canvas.drawLine(Offset(toggleWidth * 0.75 * 0.9, height * 0.75 * 0.5),
          Offset(toggleWidth * 0.75 * 1.1, height * 0.75 * 0.9), _crossPaint);
      canvas.drawLine(Offset(toggleWidth * 0.75 * 1.1, height * 0.75 * 0.5),
          Offset(toggleWidth * 0.75 * 0.9, height * 0.75 * 0.9), _crossPaint);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    switch (cellTypeSelected) {
      case CellType.color:
        cellTypeSelected = CellType.cross;
        break;
      case CellType.cross:
        cellTypeSelected = CellType.color;
        break;
    }
    game.cellTypeSelected = cellTypeSelected;
  }
}
