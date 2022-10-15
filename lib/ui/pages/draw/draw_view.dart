import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../widgets/app_container.dart';
import 'FreehandPainter.dart';
import 'draw_provider.dart';

class DrawPage extends StatelessWidget {
  const DrawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DrawProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  void showSettingStroke(
      BuildContext context,
      Color pickerColor,
      double strokeWidth,
      Function(Color) onColorChanged,
      Function(double) onWidthChanged) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: onColorChanged,
                  pickerAreaBorderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                  labelTypes: const [],
                  pickerAreaHeightPercent: 0.8,
                ),
                Slider(
                    value: strokeWidth,
                    onChanged: onWidthChanged,
                    label: strokeWidth.toInt().toString(),
                    min: 1,
                    max: 30)
              ],
            ),
          );
        });
  }

  Widget _buildPage(BuildContext context) {
    return Selector<DrawProvider, Tuple4<int, int, Color, double>>(
        selector: (_, provider) => Tuple4(
            provider.change,
            provider.state.strokes.length,
            provider.state.strokeColor,
            provider.state.strokeWidth),
        builder: (context, tuple, _) {
          final provider = context.select((DrawProvider provider) => provider);
          return AppContainer(
              child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MaterialButton(
                        color: provider.state.strokeColor,
                        shape: const CircleBorder(),
                        onPressed: () {
                          showSettingStroke(
                              context,
                              provider.state.strokeColor,
                              provider.state.strokeWidth,
                              provider.onStrokeColorChange,
                              provider.onStrokeWidthChange);
                        },
                        child: const SizedBox(width: 30, height: 30),
                      ),
                    ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                    onPanStart: (details) => provider.start(
                      details.localPosition.dx,
                      details.localPosition.dy,
                    ),
                    onPanUpdate: (details) {
                      provider.add(
                        details.localPosition.dx,
                        details.localPosition.dy,
                      );
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        provider.state.canvasSize =
                            Size(constraints.maxWidth, constraints.maxHeight);
                        return CustomPaint(
                          painter: FreehandPainter(provider.state),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ));
        });
  }
}
