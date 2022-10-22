import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toss_coin/ui/widgets/app_container.dart';
import 'package:tuple/tuple.dart';

import '../../widgets/item_flip_game.dart';
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
    return Selector<FlipGameProvider, Tuple4<String, String, bool, bool>>(
        selector: (_, provider) => Tuple4(
            provider.state.valueA,
            provider.state.valueB,
            provider.state.isPause,
            provider.state.isAllOpened),
        builder: (context, tuple, _) {
          final provider =
              context.select((FlipGameProvider provider) => provider);
          List<String> copyValueList = List.from(provider.state.textGame);
          List<Row> childrenColumn = [];
          ItemFlipGame itemFlipGame;
          for (int y = 0; y < 6; y++) {
            List<ItemFlipGame> gameRow = [];
            for (int x = 0; x < 6; x++) {
              itemFlipGame = ItemFlipGame(
                onTap: () => provider.onTapItem(y, x),
                text: copyValueList[0],
                visible: provider.state.stateVisible[y][x],
                isOpen: provider.state.stateOpened[y][x],
              );
              copyValueList.removeAt(0);
              gameRow.add(itemFlipGame);
            }
            Row row = Row(
                mainAxisAlignment: MainAxisAlignment.center, children: gameRow);
            childrenColumn.add(row);
          }
          if (tuple.item4) {
            provider.state.isPause = true;
          }
          return AppContainer(
            child: (tuple.item4)
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "You win!",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: provider.reset,
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.greenAccent,
                              ),
                            ),
                          )
                        ]),
                  )
                : AbsorbPointer(
                    absorbing: tuple.item3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: childrenColumn),
                  ),
          );
        });
  }
}
