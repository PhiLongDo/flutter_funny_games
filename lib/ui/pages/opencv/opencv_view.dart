import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_container.dart';
import 'opencv_provider.dart';

class OpencvPage extends StatelessWidget {
  const OpencvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => OpencvProvider()..init(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Selector<OpencvProvider, bool>(
        selector: (_, provider) =>
            provider.state.cameraController?.value.isInitialized == true,
        builder: (context, cameraIsInitialized, _) {
          final provider =
              context.select((OpencvProvider provider) => provider);
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
