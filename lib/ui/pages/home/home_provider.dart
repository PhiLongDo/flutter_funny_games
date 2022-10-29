import 'package:flutter/material.dart';
import 'package:toss_coin/constains.dart';

import 'home_state.dart';

class HomeProvider extends ChangeNotifier {
  final state = HomeState(Constants().listItemHome);

  void navigateToFeature(BuildContext context, int index) {
    if (state.list[index].nameRoute != null) {
      Navigator.pushNamed(context, state.list[index].nameRoute!);
    }
  }
}
