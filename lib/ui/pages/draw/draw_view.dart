import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../widgets/app_container.dart';
import 'FreehandPainter.dart';
import 'SizeSlider.dart';
import 'draw_provider.dart';
import 'draw_state.dart';

class DrawPage extends StatelessWidget {
  const DrawPage({super.key});

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
                SizeSlider(
                    value: strokeWidth,
                    onValueChanged: onWidthChanged,
                    min: 1.0,
                    max: 30.0)
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
                child: _header(context, provider),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: _canvas(context, provider)),
            ],
          ));
        });
  }

  Widget _header(BuildContext context, DrawProvider provider) {
    return Row(
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
          IconButton(
            onPressed: () =>
                provider.onStrokeColorChange(provider.state.backgroundColor),
            icon: Image.asset("res/ic_eraser.png"),
          ),
          // TODO (DPLong): Chua luu duoc va thu muc pictures
          IconButton(
            onPressed: () {
              provider.convertToPng(type: SaveType.gallery);
            },
            icon: const Icon(
              Icons.save,
              size: 35,
              color: Colors.green,
            ),
          ),
        ]);
  }

  Widget _canvas(BuildContext context, DrawProvider provider) {
    return SizedBox(
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
    );
  }
}
