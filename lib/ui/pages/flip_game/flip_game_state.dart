import 'dart:math';

class FlipGameState {
  static List<String> listValue = ['🍓','🍒','🍎','🍉','🍑','🍊','🥭','🍍','🍌','🍈','🍏','🍐','🥝','🍇','🥥','🍅','🌶','🍄','🥕','🍠','🌽','🥦','🥒','🥬','🥑','🍆','🥔','🌰','🥜','🍞','🥐','🥖','🥯','🥞','🍳','🥣','🥗','🍲','🍛','🍜','🦞','🍣','🍤','🥡','🥠','🍡','🍥','🍘','🍙','🍢','🥟','🍱','🍚','🥮','🍧','🍨','🍦','🥧'];
  static const width = 6;
  static const height = 6;
  List<List<bool>> stateOpened = []; // state open of item in matrix game
  List<List<bool>> stateVisible = []; //state visible matrix game
  String valueA = "";
  String valueB = ""; // value of items game is opening
  int xPre = -1;
  int yPre = -1;

  List<List<String>> valueGame = [];
  List<String> textGame = [];
  bool isPause = false;
  bool isShowPlayInCenter = true;

  int itemCanOpenCount = width * height;

  bool get isAllOpened => itemCanOpenCount == 0;

  FlipGameState() {
    for (int y = 1; y <= height; y++) {
      stateOpened.add(List.generate(width, (index) => false));
      stateVisible.add(List.generate(width, (index) => true));
      valueGame.add(List.generate(width, (index) => ""));
    }

    textGame = List.generate(itemCanOpenCount, (index) => "");
    List<int> listIndex = List.generate(itemCanOpenCount, (index) => index);
    for (int i = 0; i < itemCanOpenCount; i++) {
      var random = Random();
      var index = random.nextInt(itemCanOpenCount - i);
      textGame[listIndex[index]] = listValue[i ~/ 2];
      valueGame[listIndex[index] ~/ width][listIndex[index] % width] =
          textGame[listIndex[index]];
      listIndex.removeAt(index);
    }
  }
}
