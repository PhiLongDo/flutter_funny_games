import 'dart:ffi';

import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  const AppContainer(
      {Key? key, required this.child, this.showBackButton = true})
      : super(key: key);

  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Stack(
            children: [
              child,
              showBackButton
                  ? Container(
                      height: 40,
                      alignment: Alignment.topLeft,
                      child: FloatingActionButton(
                        backgroundColor: Colors.lightGreen,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
