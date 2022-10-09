import 'dart:typed_data';

import 'package:flutter/material.dart';

typedef HistoryChanged = void Function(
    bool isUndoAvailable, bool isRedoAvailable);

class DrawState {
  /// [Color] for background of canvas.
  Color backgroundColor = Colors.blue.shade50;

  /// [Color] of strokes as an initial configuration.
  Color strokeColor = Colors.red;

  /// Width of strokes
  double strokeWidth = 3;

  /// Flag for erase mode
  bool isErasing = false;

  /// Callback called when [Canvas] is converted to image data.
  /// See [DrawController] to check how to convert.
  ValueChanged<Uint8List>? onConvertImage;

  /// Callback called when history is changed.
  /// This callback exposes if undo / redo is available.
  HistoryChanged? onHistoryChange;

  List<Stroke> strokes = [];
  List<Stroke> undoHistory = [];
  List<Stroke> redoStack = [];

  // cached current canvas size
  late Size canvasSize;
}

/// Data class representing strokes
class Stroke {
  final path = Path();
  final Color color;
  final double width;
  final bool erase;

  Stroke({
    this.color = Colors.black,
    this.width = 3,
    this.erase = false,
  });
}
