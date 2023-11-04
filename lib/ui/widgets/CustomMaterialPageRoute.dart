import 'package:flutter/cupertino.dart';

class CustomPageRoute<T> extends CupertinoPageRoute<T> {
  CustomPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  @protected
  bool get hasScopedWillPopCallback {
    return true;
  }
}
