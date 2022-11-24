
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:respect_health/utils/color_utils.dart';

class FileProgress {
  static Widget call(progress) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: false,
      percent: progress,
      center: new Text(
        (progress * 100).toStringAsFixed(0)+"%",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: ColorUtils.coral,
    );
  }

  static Widget callLinear(BuildContext context, progress) {
    return LinearPercentIndicator(
      width: MediaQuery.of(context).size.width-200,
      animation: false,
      lineHeight: 20.0,
      animationDuration: 2000,
      percent: progress,
      center: Text((progress * 100).toStringAsFixed(0)+"%",         
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0),
      ),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: ColorUtils.coral,
    );
  }
}
