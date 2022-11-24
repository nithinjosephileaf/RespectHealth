import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:respect_health/utils/color_utils.dart';

/// A centered and sized [CircularProgressIndicator] to show download progress
/// in the [DownloadPage].
class RhProgressIndicator extends StatelessWidget {
  final double progress;

  const RhProgressIndicator({Key? key, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 120, top: 0),
        child: CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 6.0,
          animation: true,
          animationDuration: 1000,
          percent: progress,
          animateFromLastPercent: true,
          center: Text(
            (progress * 100).toStringAsFixed(0) + "%",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
          ),
          footer: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 20),
            Text('Overall Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          ]),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: ColorUtils.coral,
        ));
  }
}
