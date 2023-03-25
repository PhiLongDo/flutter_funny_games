import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void clean() {
    state.strokes = [];
    state.undoHistory = [];
    state.redoStack = [];
    state.points = [];
    notifyListeners();
  }

  // convert current canvas to png image data.
  Future<void> convertToPng({SaveType type = SaveType.gallery}) async {
    bool? saveResult = false;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final timestamp = DateTime.now();
    final fileName =
        "${timestamp.day}_${timestamp.month}_${timestamp.year}_${timestamp.hour}_${timestamp.minute}_${timestamp.second}.png";

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
    if (type == SaveType.gdrive) {
      Directory temporaryDirectory = await getTemporaryDirectory();
      final file = await File(
              path.join(temporaryDirectory.path, 'funny_draw_$fileName.png'))
          .writeAsBytes(converted);
      GoogleDrive().uploadFileToGoogleDrive(file);
    }

    if (type == SaveType.gallery) {
      // Save to album.
      var result = await requestPermission();
      if (result) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          RegExp pathToDownloads = RegExp(r'.+0/');
          final outputDirectory = Directory(
              '${pathToDownloads.stringMatch(directory.path).toString()}Pictures/funny_draw');
          var isDirectoryExists = await outputDirectory.exists();
          if (!isDirectoryExists) {
            await outputDirectory.create(recursive: true);
          }
          try {
            final file =
                await File(path.join(outputDirectory.path, fileName)).create();
            file.writeAsBytesSync(converted);
            saveResult = true;
          } catch (_) {
            if (kDebugMode) {
              print(["Exception", _.toString()]);
            }
            saveResult = false;
          }
        }
      }
    }
    Fluttertoast.showToast(
        msg: saveResult ?? false ? "Saved" : "Can not save",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  Future<bool> requestPermission() async {
    // from android 10 (sdk 30), no storage permission required
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt > 29) {
        return true;
      }
    }

    var permission = Platform.isIOS == true
        ? Permission.photos
        : Platform.isAndroid == true
            ? Permission.storage
            : null;
    var status = await permission?.request();
    if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      status = await permission?.status;
    }
    return status == PermissionStatus.granted;
  }
}
