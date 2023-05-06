import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'opencv_state.dart';

class OpencvProvider extends ChangeNotifier {
  final state = OpencvState();

  Future<void> init() async {
    var cameras = await availableCameras();
    state.cameraController = CameraController(cameras[0], ResolutionPreset.max);
    try {
      await state.cameraController!.initialize();
      notifyListeners();
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            Fluttertoast.showToast(
                msg: "Camera Access Denied",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0);
            break;
          default:
            Fluttertoast.showToast(
                msg: "Camera can't open",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0);
            break;
        }
      }
    }
  }

  Future<bool> requestCameraPermission() async {
    var permission = Permission.camera;
    var status = await permission.request();
    if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      status = await permission.status;
    }
    return status == PermissionStatus.granted;
  }
}
