import 'dart:math' as math;

const defaultItems = [
  "Bạch Dương",
  "Kim Ngưu",
  "Song Tử",
  "Cự Giải",
  "Sư Tử",
  "Xử Nữ",
  "Thiên Bình",
  "Thiên Yết",
  "Nhân Mã",
  "Ma Kết",
  "Bảo Bình",
  "Song Ngư"
];

const defaultWheel = "res/1x/img_zodiac_wheel.png";
const defaultPointer = "res/1x/img_pointer.png";

class ZodiacWheelState {
  List<String> listItem;
  int round;
  double angle;
  double anglePointer;
  bool isPlaying;
  String imgWheel;
  String imgPointer;

  ZodiacWheelState({
    this.angle = math.pi / 12,
    this.isPlaying = false,
    this.anglePointer = 0.0,
    this.round = 5,
    this.listItem = defaultItems,
    this.imgWheel = defaultWheel,
    this.imgPointer = defaultPointer,
  }) : super();

  String get result => listItem[listItem.length -
      ((angle / ((math.pi * 2) / listItem.length)).floor() % listItem.length) -
      1];
}
