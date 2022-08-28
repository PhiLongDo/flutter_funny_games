import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toss_coin/ui/widgets/app_container.dart';

import 'flip_game_provider.dart';

class FlipGamePage extends StatelessWidget {
  const FlipGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FlipGameProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<FlipGameProvider>();
    final state = provider.state;

    return AppContainer(child: Container());
  }
}