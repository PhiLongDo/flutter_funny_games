import 'package:flutter/material.dart';

import '../nonogram_game.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key, required this.game});

  final NonogramGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Congratulation",
            style: TextStyle(fontSize: 32, color: Colors.amberAccent),
          ),
          const SizedBox(height: 8.0),
          Image.memory(game.pictureResult!, height: 300),
          TextButton(onPressed: game.newGame, child: const Text("New Game"))
        ],
      )),
    );
  }
}
