import 'package:toss_coin/data/models/item_home_model.dart';

class Constants {
  Constants._internal();

  static final Constants _instance = Constants._internal();

  factory Constants() => _instance;

  final listItemHome = [
    ItemHomeModel(image: "res/ic_list_1.png", nameRoute: "flip"),
    ItemHomeModel(image: "res/ic_list_2.png", nameRoute: "wheel"),
    ItemHomeModel(image: "res/ic_list_3.png", nameRoute: "draw"),
    ItemHomeModel(image: "res/1x/coin_front.png"),
    ItemHomeModel(image: "res/ic_list_coming_soon.png"),
  ];
}
