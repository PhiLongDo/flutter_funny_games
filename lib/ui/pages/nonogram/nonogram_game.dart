import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'components/cell.dart';
import 'components/cell_type_toggle.dart';
import 'components/number_label.dart';
import 'overlays/completed_screen.dart';

const gameBackgroundColor = Color.fromARGB(255, 149, 255, 110);

class NonogramPage extends StatefulWidget {
  const NonogramPage({super.key});

  @override
  State<NonogramPage> createState() => _NonogramPageState();
}

class _NonogramPageState extends State<NonogramPage> {
  bool canOpen = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
        .then((value) {
      Future.delayed(const Duration(milliseconds: 40), () {
        setState(() {
          canOpen = true;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
        return true;
      },
      child: canOpen
          ? GameWidget<NonogramGame>.controlled(
              gameFactory: NonogramGame.new,
              overlayBuilderMap: {
                'GameCompleted': (_, game) => CompletedScreen(game: game),
              },
            )
          : Container(),
    );
  }
}

class NonogramGame extends FlameGame
    with VerticalDragDetector, HorizontalDragDetector {
  NonogramGame();

  static const double cellWidth = 1000.0;
  static const int gameWidth = 5;
  static const int gameHeight = 5;
  static const double gamePadding = 100.0;
  static const toolbarHeight = 1000.0;
  static const labelSize = 2500.0;

  CellType cellTypeSelected = CellType.color;
  List<List<Cell>> matrix = [];
  var pointTap = Vector2.zero();
  bool dragFill = true;
  List<Cell> dragOver = [];

  @override
  final world = World();
  late final CameraComponent _camera;
  ui.PictureRecorder? _recorder;
  Uint8List? pictureResult;

  var visibleGameSize = Vector2.zero();
  var gameZoom = 1.0;

  @override
  Color backgroundColor() {
    return gameBackgroundColor;
  }

  //region Create Game
  @override
  Future<FutureOr<void>> onLoad() async {
    loadNewWord();
    await add(world);

    //region Create Camera view
    visibleGameSize = Vector2(
        gameWidth * cellWidth + gamePadding * 2 + labelSize,
        gameHeight * cellWidth + gamePadding * 2 + toolbarHeight + labelSize);

    var zoomX = size.x / visibleGameSize.x;
    var zoomY = size.y / visibleGameSize.y;
    if (zoomX < zoomY) {
      gameZoom = zoomX;
    } else {
      gameZoom = zoomY;
    }

    _camera = CameraComponent(world: world)
      ..viewfinder.zoom = gameZoom
      ..viewfinder.position = Vector2(
          (gameWidth * cellWidth + gamePadding * 2 + labelSize) * 0.5, 0)
      ..viewfinder.anchor = Anchor.topCenter;

    await add(_camera);
    //endregion
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
        world.add(NumberLabel(
            row: row,
            position: Vector2(
                (cellWidth * gameWidth) +
                    col * (cellWidth * 0.5) -
                    gamePadding * 2,
                (toolbarHeight + gamePadding + cellWidth * 0.5) +
                    row * cellWidth),
            number: 0));
      }
      for (var xx in hConnectedNumber[row]) {
        world.add(NumberLabel(
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
        world.add(
          NumberLabel(
              col: col,
              position: Vector2(
                  col * cellWidth - gamePadding,
                  (toolbarHeight + gamePadding * 4) +
                      (cellWidth * gameHeight) +
                      (row * cellWidth * 0.5)),
              number: 0),
        );
      }
      for (var xx in vConnectedNumber[col]) {
        world.add(
          NumberLabel(
              col: col,
              position: Vector2(
                  col * cellWidth - gamePadding,
                  (toolbarHeight + gamePadding * 4) +
                      (cellWidth * gameHeight) +
                      (row * cellWidth * 0.5)),
              number: xx),
        );
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
  }

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
    pointTap = info.eventPosition.widget;
    dragOver.clear();
    final cells =
        componentsAtPoint(info.eventPosition.widget).whereType<Cell>().toList();
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
        componentsAtPoint(info.eventPosition.widget).whereType<Cell>().toList();
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

  //region Capture result
  Future<void> createPictureResult() async {
    _recorder = ui.PictureRecorder();
    final left = (size.x - (visibleGameSize.x * gameZoom)) / 2;
    final top = toolbarHeight * gameZoom;
    final width = (visibleGameSize.x - labelSize) * gameZoom;
    final height = (visibleGameSize.y - labelSize - toolbarHeight) * gameZoom;

    final rect = Rect.fromLTWH(0.0, 0.0, size.x, size.y);
    final canvas = Canvas(_recorder!, rect);
    render(canvas);

    pictureResult = null;
    final imageRecorded =
        await _recorder!.endRecording().toImage(size.x.toInt(), size.y.toInt());

    img.PngDecoder().decode(
        (await imageRecorded.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List());

    pictureResult = img.PngEncoder().encode(
      img.copyCrop(
        img.PngDecoder().decode(
            (await imageRecorded.toByteData(format: ui.ImageByteFormat.png))!
                .buffer
                .asUint8List())!,
        x: left.toInt(),
        y: top.toInt(),
        width: width.toInt(),
        height: height.toInt(),
      ),
      singleFrame: true,
    );
  }
//endregion
}
