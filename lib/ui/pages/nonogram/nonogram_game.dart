import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/cell.dart';
import 'components/cell_type_toggle.dart';
import 'components/number_lable.dart';
import 'overlays/completed_screen.dart';

const gameBackgroundColor = Color.fromARGB(255, 149, 255, 110);

class NonogramPage extends StatefulWidget {
  const NonogramPage({super.key});

  @override
  State<NonogramPage> createState() => _NonogramPageState();
}

class _NonogramPageState extends State<NonogramPage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget<NonogramGame>.controlled(
      gameFactory: NonogramGame.new,
      overlayBuilderMap: {
        'GameCompleted': (_, game) => CompletedScreen(game: game),
      },
    );
  }
}

class NonogramGame extends FlameGame
    with VerticalDragDetector, HorizontalDragDetector {
  NonogramGame();

  static const double cellWidth = 1000.0;
  static const int gameWidth = 4;
  static const int gameHeight = 4;
  static const double gamePadding = 100.0;
  static const toolbarHeight = 1000.0;
  static const labelSize = 2500.0;

  CellType cellTypeSelected = CellType.color;
  List<List<Cell>> matrix = [];
  var pointTap = Vector2.zero();
  bool dragFill = true;
  List<Cell> dragOver = [];

  final world = World();
  late final CameraComponent _camera;
  ui.PictureRecorder? _recorder;
  Uint8List? pictureResult;

  @override
  Color backgroundColor() {
    return gameBackgroundColor;
  }

  //region Create Game
  @override
  FutureOr<void> onLoad() {
    loadNewWord();
    add(world);

    //region Create Camera view
    _camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(
          gameWidth * cellWidth + gamePadding * 2 + labelSize,
          gameHeight * cellWidth + gamePadding * 2 + toolbarHeight + labelSize)
      ..viewfinder.position = Vector2(
          (gameWidth * cellWidth + toolbarHeight + labelSize) * 0.5 +
              gamePadding,
          0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(_camera);
    //endregion
    initPictureRecorder();
  }

  void loadNewWord() {
    //region Loading Cell (random type)
    for (var row = 0; row < gameHeight; row++) {
      for (var col = 0; col < gameWidth; col++) {
        var cellType = Random().nextBool() ? CellType.color : CellType.cross;
        var cell = Cell(
            position: Vector2(
                col * cellWidth, toolbarHeight + gamePadding + row * cellWidth),
            type: cellType,
            row: row,
            col: col);
        if (col == 0) {
          matrix.add([cell]);
        } else {
          matrix[row].add(cell);
        }
        world.add(cell);
      }
    }
    //endregion

    List<List<int>> vConnectedNumber = List.generate(gameWidth, (index) => []);
    List<List<int>> hConnectedNumber = List.generate(gameHeight, (index) => []);
    //region Calculate label values
    for (var row = 0; row < gameHeight; row++) {
      for (var col = 0; col < gameWidth; col++) {
        if (matrix[row][col].type == CellType.color) {
          if (col == 0 ||
              (col > 0 && matrix[row][col - 1].type == CellType.cross)) {
            hConnectedNumber[row].add(1);
          } else {
            hConnectedNumber[row].last += 1;
          }
          //-------------------------------------------
          if (row == 0 ||
              (row > 0 && matrix[row - 1][col].type == CellType.cross)) {
            vConnectedNumber[col].add(1);
          } else {
            vConnectedNumber[col].last += 1;
          }
        }
      }
    }
    //endregion

    //region Draw text on the right
    for (var row = 0; row < gameHeight; row++) {
      var col = 0;
      if (hConnectedNumber[row].isEmpty) {
        world.add(NumberLable(
            row: row,
            position: Vector2(
                (cellWidth * gameWidth) + col * (cellWidth * 1.5),
                (toolbarHeight + gamePadding + cellWidth * 0.5) +
                    row * cellWidth),
            number: 0));
      }
      for (var xx in hConnectedNumber[row]) {
        world.add(NumberLable(
            row: row,
            position: Vector2(
                (cellWidth * gameWidth) +
                    col * (cellWidth * 0.5) -
                    gamePadding * 2,
                (toolbarHeight + gamePadding + cellWidth * 0.5) +
                    row * cellWidth),
            number: xx));
        col++;
      }
    }
    //endregion

    //region Draw text on the bottom
    for (var col = 0; col < gameWidth; col++) {
      var row = 0;
      if (vConnectedNumber[col].isEmpty) {
        world.add(NumberLable(
            col: col,
            position: Vector2(
                col * cellWidth - gamePadding,
                (toolbarHeight + gamePadding * 4) +
                    (cellWidth * gameHeight) +
                    (row * cellWidth * 0.5)),
            number: 0));
      }
      for (var xx in vConnectedNumber[col]) {
        world.add(NumberLable(
            col: col,
            position: Vector2(
                col * cellWidth - gamePadding,
                (toolbarHeight + gamePadding * 4) +
                    (cellWidth * gameHeight) +
                    (row * cellWidth * 0.5)),
            number: xx));
        row++;
      }
    }
    //endregion

    //region Draw Header
    world.add(CellTypeToggle());
    world.add(
      TextComponent(
        text: "$gameWidth x $gameHeight",
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 350,
            color: Color.fromRGBO(87, 0, 0, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
        anchor: Anchor.centerRight,
        position: Vector2(gameWidth * cellWidth, toolbarHeight * 0.5),
      ),
    );
    //endregion
  }

  void newGame() {
    matrix.clear();
    world.removeAll(world.children);
    loadNewWord();
    overlays.remove("GameCompleted");
    initPictureRecorder();
  }

  //endregion

  //region Drag handler
  @override
  void onHorizontalDragStart(DragStartInfo info) {
    onDragStart(info);
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    onDragUpdate(info);
  }

  @override
  void onVerticalDragStart(DragStartInfo info) {
    onDragStart(info);
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    onDragUpdate(info);
  }

  void onDragStart(DragStartInfo info) {
    pointTap = info.eventPosition.game;
    dragOver.clear();
    final cells =
        componentsAtPoint(info.eventPosition.game).whereType<Cell>().toList();
    if (cells.isNotEmpty) {
      dragFill = cells.first.typeSelected == null ||
          cells.first.typeSelected != cellTypeSelected;
      if (dragFill) {
        cells.first.fill();
      } else {
        cells.first.notFill();
      }
      dragOver.add(cells.first);
    }
  }

  void onDragUpdate(DragUpdateInfo info) {
    final cells =
        componentsAtPoint(info.eventPosition.game).whereType<Cell>().toList();
    for (final cell in cells) {
      if (!dragOver.contains(cell)) {
        if (dragFill) {
          cell.fill();
        } else {
          // if (cell.typeSelected == cellTypeSelected) {
          cell.notFill();
          // }
        }
        dragOver.add(cell);
      }
    }
  }

  //endregion

  //region Capture result
  void initPictureRecorder() {
    _recorder = ui.PictureRecorder();
    final rect = Rect.fromLTWH(0.0, 0.0, size.x, size.y);
    final canvas = Canvas(_recorder!, rect);
    render(canvas);
  }

  Future<void> createPictureResult() async {
    pictureResult = null;
    final image =
        await _recorder!.endRecording().toImage(size.x.toInt(), size.y.toInt());

    const rect =
        Rect.fromLTWH(0.0, 0.0, cellWidth * gameWidth, cellWidth * gameHeight);
    pictureResult = (await image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
//endregion
}
