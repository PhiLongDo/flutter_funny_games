import 'package:flutter/material.dart';

class ItemFlipGame extends StatelessWidget {
  const ItemFlipGame(
      {super.key,
      required this.text,
      required this.onTap,
      required this.visible,
      required this.isOpen});
  final String text;
  final VoidCallback onTap;
  final bool visible, isOpen;

  double _getWidth(BuildContext context) {
    double w, h, real;
    w = MediaQuery.of(context).size.width - 20;
    h = MediaQuery.of(context).size.height - 20;
    if (h < w) {
      real = h / 6;
    } else {
      real = w / 6;
    }
    return real;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(context),
      height: _getWidth(context),
      child: Visibility(
        visible: visible,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: _getWidth(context),
            height: _getWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(color: Colors.white, width: 1),
              color: isOpen ? Colors.amberAccent : Colors.greenAccent,
            ),
            child: Center(
              child: Text(
                isOpen ? text : "✤",
                style: TextStyle(
                  color: isOpen ? Colors.brown : Colors.blue,
                  fontSize: _getWidth(context) - (100 / 6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
