import 'package:flutter/cupertino.dart';

class CustomPageRoute<T> extends CupertinoPageRoute<T> {
  CustomPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  @protected
  bool get hasScopedWillPopCallback {
    return true;
  }
}
