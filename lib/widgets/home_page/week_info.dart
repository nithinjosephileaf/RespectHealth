import 'package:flutter/material.dart';
import 'package:respect_health/utils/color_utils.dart';

class WeekInfo extends StatelessWidget {
  final int number;

  WeekInfo({required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(125.0, 28, 0, 0),
      child: Text(
        "Week ${this.number}",
        style: TextStyle(
          color: ColorUtils.black, 
          fontWeight: FontWeight.w700, 
          fontSize: 45
        ),
    ));
  }
}
