import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'FreehandPainter.dart';
import 'draw_state.dart';
import 'gdrive/google_drive.dart';

class DrawProvider extends ChangeNotifier {
  final state = DrawState();

  int get change => state.points.length;

  void onStrokeColorChange(Color value) {
    state.strokeColor = value;
    notifyListeners();
  }

  void onStrokeWidthChange(double value) {
    state.strokeWidth = value;
    notifyListeners();
  }

  void start(double startX, double startY) {
    final newStroke = Stroke(
      color: state.strokeColor,
      width: state.strokeWidth,
      erase: state.isErasing,
    );
    state.points.clear();
    newStroke.path.moveTo(startX, startY);
    state.strokes.add(newStroke);
    state.undoHistory.add(newStroke);
    state.redoStack.clear();
    notifyListeners();
  }

  void add(double x, double y) {
    state.strokes.last.path.lineTo(x, y);
    state.points.add(Point(x, y));
    notifyListeners();
  }

  void undo() {
    state.redoStack.add(state.undoHistory.last);
    state.strokes.remove(state.undoHistory.last);
    state.undoHistory.removeLast();
    notifyListeners();
  }

  void redo() {
    state.strokes.add(state.redoStack.last);
    state.undoHistory.add(state.redoStack.last);
    state.redoStack.removeLast();
    notifyListeners();
  }

  // convert current canvas to png image data.
  Future<void> convertToPng() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Emulate painting using _FreehandPainter
    // recorder will record this painting
    FreehandPainter(state).paint(canvas, state.canvasSize);

    // Stop emulating and convert to Image
    final result = await recorder.endRecording().toImage(
        state.canvasSize.width.floor(), state.canvasSize.height.floor());

    // Cast image data to byte array with converting to png format
    final converted = (await result.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final file = await File(path.join(appDocDirectory.path, 'funny_draw.png'))
        .writeAsBytes(converted);
    GoogleDrive().uploadFileToGoogleDrive(file);
  }
}
