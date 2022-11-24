import 'dart:math';
import 'dart:ui';

import 'package:respect_health/utils/hexcolor.dart';

class ColorUtils {
  static Color randomColor() {
    return Color(Random().nextInt(0xffffffff));
  }

  static Color randomOpaqueColor() {
    return randomColor().withAlpha(0xff);
  }

  static Color teal = HexColor.fromHex('#0FDCD0');
  static Color coral = HexColor.fromHex('#F4505E');
  static Color purple = HexColor.fromHex('#723FFE');
  static Color grey = HexColor.fromHex('#723FFE');
  static Color black = HexColor.fromHex('#1A1A1A');
  static Color viewed = HexColor.fromHex('#2dc9be');
  static Color disabled = HexColor.fromHex('#e56e79');
}
