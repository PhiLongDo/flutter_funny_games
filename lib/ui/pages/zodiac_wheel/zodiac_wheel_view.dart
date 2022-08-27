import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'zodiac_wheel_provider.dart';

/// The default curve used when spinning a [FortuneWidget].
const Curve spin = Cubic(0, 1.0, 0, 1.0);

/// A curve used for disabling spin animations.
const Curve none = Threshold(0.0);

const Curve sawtooth = SawTooth((1333 * 2222) ~/ 1333);

class ZodiacWheelPage extends StatelessWidget {
  const ZodiacWheelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ZodiacWheelProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<ZodiacWheelProvider>();
    final state = provider.state;

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              child: Text(
                state.result,
                style: const TextStyle(fontSize: 36),
              ),
            ),
            AbsorbPointer(
              absorbing: state.isPlaying,
              child: GestureDetector(
                onPanEnd: (_) {
                  context.watch<ZodiacWheelProvider>().play();
                },
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Transform.rotate(
                        angle: state.angle,
                        child: AnimatedContainer(
                          duration: duration,
                          curve: spin,
                          child: Image.asset(
                            state.imgWheel,
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: state.anglePointer,
                      child: AnimatedContainer(
                        curve: none,
                        duration: Duration.zero,
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          height: 60,
                          state.imgPointer,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
