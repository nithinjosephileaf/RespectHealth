import 'package:flutter/cupertino.dart';

abstract class DimensionsData {

  double aspectRatio(BuildContext context) {
    int screenHeight = MediaQuery.of(context).size.height.toInt();
    if (screenHeight == 800) {
      return 1.3;
    } else if (screenHeight > 800) {
      return 2.2;
    }
    return 1.3;
  }

  double crossSpacing(BuildContext context) {
    int screenHeight = MediaQuery.of(context).size.height.toInt();
    if (screenHeight <= 800) {
      return 0.2;
    } else if (screenHeight > 800) {
      return 0.1;
    }
    return 0.1;
  }

  double weekProgressLeftMargin(BuildContext context) {
    int screenHeight = MediaQuery.of(context).size.height.toInt();
    if (screenHeight <= 800) {
      return 0.0;
    } else if (screenHeight > 800) {
      return 450;
    }
    return 450;
  }
}