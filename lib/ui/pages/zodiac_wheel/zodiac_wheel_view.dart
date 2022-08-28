import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toss_coin/ui/widgets/app_container.dart';
import 'package:tuple/tuple.dart';

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
    return Selector<ZodiacWheelProvider, Tuple3<double, double, bool>>(
        selector: (_, provider) => Tuple3(provider.state.angle,
            provider.state.anglePointer, provider.state.isPlaying),
        builder: (context, tuple, _) {
          final provider =
              context.select((ZodiacWheelProvider provider) => provider);
          return AppContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(
                    provider.state.result,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
                AbsorbPointer(
                  absorbing: provider.state.isPlaying,
                  child: GestureDetector(
                    onPanEnd: (_) {
                      provider.play();
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Transform.rotate(
                            angle: provider.state.angle,
                            child: AnimatedContainer(
                              duration: duration,
                              curve: spin,
                              child: Image.asset(
                                provider.state.imgWheel,
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: provider.state.anglePointer,
                          child: AnimatedContainer(
                            curve: none,
                            duration: Duration.zero,
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              height: 60,
                              provider.state.imgPointer,
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
          );
        });
  }
}
