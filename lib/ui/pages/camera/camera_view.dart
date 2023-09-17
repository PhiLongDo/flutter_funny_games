import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_container.dart';
import 'camera_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraProvider? _provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _provider = CameraProvider()..init(),
      builder: (context, child) => _buildPage(context),
    );
  }

  @override
  void dispose() {
    _provider?.state.cameraController?.dispose();
    super.dispose();
  }

  Widget _buildPage(BuildContext context) {
    return Selector<CameraProvider, bool>(
        selector: (_, provider) =>
            provider.state.cameraController?.value.isInitialized == true,
        builder: (context, cameraIsInitialized, _) {
          final provider =
              context.select((CameraProvider provider) => provider);
          return AppContainer(
            child: !cameraIsInitialized
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(top: 50),
                    height: 2000,
                    width: 1000,
                    child: CameraPreview(
                      provider.state.cameraController!,
                      child: Container(
                        color: Colors.black26,
                      ),
                    ),
                  ),
          );
        });
  }
}
