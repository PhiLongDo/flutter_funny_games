import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../widgets/app_container.dart';
import 'FreehandPainter.dart';
import 'draw_provider.dart';
import 'draw_state.dart';

class DrawPage extends StatelessWidget {
  const DrawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DrawProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Selector<DrawProvider, Tuple2<double, int>>(
        selector: (_, provider) =>
            Tuple2(provider.change, provider.state.strokes.length),
        builder: (context, tuple, _) {
          final provider = context.select((DrawProvider provider) => provider);
          return AppContainer(
              child: SizedBox(
            height: double.infinity,
            width: double.infinity,
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
          ));
        });
  }
}
