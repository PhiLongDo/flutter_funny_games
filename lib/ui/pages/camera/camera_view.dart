import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
                : Stack(
                    children: [
                      Container(
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Selector<CameraProvider, bool>(
                          selector: (context, provider) =>
                              provider.state.cameraController?.value
                                  .isRecordingVideo ??
                              false,
                          builder: (context, isRecordingVideo, child) {
                            return IconButton(
                              onPressed: () async {
                                if (isRecordingVideo) {
                                  final file = await provider
                                      .state.cameraController
                                      ?.stopVideoRecording();
                                  if (file != null && mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return Column(
                                          children: [
                                            IconButton(
                                              onPressed:
                                                  Navigator.of(dialogContext)
                                                      .pop,
                                              icon: const Icon(
                                                  Icons.close_rounded),
                                            ),
                                            AspectRatio(
                                              aspectRatio: provider
                                                  .state
                                                  .cameraController!
                                                  .value
                                                  .aspectRatio,
                                              child: VideoPlayer(
                                                VideoPlayerController.file(
                                                  File(file.path),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  await provider.state.cameraController
                                      ?.stopVideoRecording();
                                }
                              },
                              icon: Icon(
                                isRecordingVideo
                                    ? Icons.stop_circle_outlined
                                    : Icons.play_circle_outline,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
