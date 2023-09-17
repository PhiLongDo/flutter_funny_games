import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../nonogram_game.dart';
import 'number_lable.dart';

enum CellType {
  color("Color"),
  cross("Cross-out");

  final String text;

  const CellType(this.text);
}

enum ValidateType {
  completed,
  valid,
  invalid,
}

class Cell extends PositionComponent
    with HasGameRef<NonogramGame>, TapCallbacks {
  Cell({
    required super.position,
    required this.type,
    required this.row,
    required this.col,
  }) : super(
          size: Vector2(NonogramGame.cellWidth, NonogramGame.cellWidth),
        );

  final int row;
  final int col;

  final CellType type;
  CellType? typeSelected;

  bool isTapped = false;

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..color = Colors.white;

  final _crossPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 50
    ..color = Colors.white;

  final _backgroundPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.blueGrey;

  final _backgroundColorPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.pinkAccent;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _borderPaint);
    canvas.drawRect(size.toRect(), _backgroundPaint);
    if (isTapped) {
      switch (typeSelected) {
        case CellType.color:
          {
            canvas.drawRect(size.toRect(), _backgroundColorPaint);
            break;
          }
        case CellType.cross:
          {
            canvas.drawLine(
                const Offset(
                    NonogramGame.cellWidth * 0.2, NonogramGame.cellWidth * 0.2),
                const Offset(
                    NonogramGame.cellWidth * 0.8, NonogramGame.cellWidth * 0.8),
                _crossPaint);
            canvas.drawLine(
                const Offset(
                    NonogramGame.cellWidth * 0.8, NonogramGame.cellWidth * 0.2),
                const Offset(
                    NonogramGame.cellWidth * 0.2, NonogramGame.cellWidth * 0.8),
                _crossPaint);
            break;
          }
        default:
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    onTap();
  }

  void onTap() {
    if (typeSelected != game.cellTypeSelected || !isTapped) {
      isTapped = true;
      typeSelected = game.cellTypeSelected;
    } else {
      isTapped = false;
      typeSelected = null;
    }

    if (game.cellTypeSelected == CellType.cross) {
      return;
    }

    checkRowCol();
    checkGameCompleted();
  }

  void notFill() {
    isTapped = false;
    typeSelected = null;
    checkRowCol();
    checkGameCompleted();
  }

  void fill() {
    isTapped = true;
    typeSelected = game.cellTypeSelected;
    checkRowCol();
    checkGameCompleted();
  }

  void checkRowCol() {
    // check row
    var rowValid = ValidateType.completed;
    for (var i = 0; i < NonogramGame.gameWidth; i++) {
      if ((game.matrix[row][i].type == CellType.color &&
              game.matrix[row][i].type != game.matrix[row][i].typeSelected) ||
          game.matrix[row][i].typeSelected == CellType.color &&
              game.matrix[row][i].type == CellType.cross) {
        rowValid = ValidateType.invalid;
        break;
      }
    }

    if (rowValid == ValidateType.completed) {
      for (var cell in game.matrix[row]) {
        cell.typeSelected = cell.type;
        cell.isTapped = true;
      }
    }
    for (final lable in parent!.children
        .whereType<NumberLable>()
        .where((element) => element.row == row)) {
      if (rowValid != ValidateType.invalid) {
        lable.changeTextToGray();
      } else {
        lable.changeTextToBlack();
      }
    }

    // check column
    var colValid = true;
    for (var i = 0; i < NonogramGame.gameHeight; i++) {
      if ((game.matrix[i][col].type == CellType.color &&
              game.matrix[i][col].type != game.matrix[i][col].typeSelected) ||
          (game.matrix[i][col].typeSelected == CellType.color &&
              game.matrix[i][col].type == CellType.cross)) {
        colValid = false;
        break;
      }
    }

    if (colValid) {
      for (var i = 0; i < NonogramGame.gameHeight; i++) {
        var cell = game.matrix[i][col];
        cell.typeSelected = cell.type;
        cell.isTapped = true;
      }
    }
    for (final lable in parent!.children
        .whereType<NumberLable>()
        .where((element) => element.col == col)) {
      if (colValid) {
        lable.changeTextToGray();
      } else {
        lable.changeTextToBlack();
      }
    }
  }

  Future<void> checkGameCompleted() async {
    var isCompleted = true;
    for (var row = 0; row < NonogramGame.gameHeight; row++) {
      for (var col = 0; col < NonogramGame.gameWidth; col++) {
        if (game.matrix[row][col].type != game.matrix[row][col].typeSelected) {
          isCompleted = false;
          break;
        }
      }
    }
    if (isCompleted) {
      await game.createPictureResult();
      game.overlays.add("GameCompleted");
    }
  }
}
