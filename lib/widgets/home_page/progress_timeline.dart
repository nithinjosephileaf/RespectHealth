import 'package:flutter/material.dart';
import 'package:respect_health/models/fitness_video_set.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/utils/color_utils.dart';
import 'package:timelines/timelines.dart';

//timeline with week boxes above videos on the home screen
class ProgressTimeline extends StatefulWidget {
  final ParticipationProgress? progress;
  final FitnessVideoSet videoSet;

  ProgressTimeline({required this.progress, required this.videoSet});

  @override
  _ProgressTimelineState createState() => _ProgressTimelineState();
}

class _ProgressTimelineState extends State<ProgressTimeline> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: _calcWidth(),
        child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              color: ColorUtils.teal.withOpacity(0.8),
              direction: Axis.horizontal,
            ),
            builder: TimelineTileBuilder.fromStyle(
                oppositeContentsBuilder: (context, index) {
                  if (index + 1 < widget.progress!.currentWeek) {
                    return Icon(Icons.check,
                        color: ColorUtils.teal.withOpacity(0.8));
                  }
                  return null;
                },
                connectorStyle: ConnectorStyle.dashedLine,
                indicatorStyle: IndicatorStyle.dot,
                itemCount: widget.videoSet.numberOfWeeks,
                contentsBuilder: (context, index) {
                  if (index + 1 < widget.progress!.currentWeek) {
                    return _pastContainer(index);
                  } else if (index + 1 == widget.progress!.currentWeek) {
                    return _currentContainer(index);
                  } else if (index + 1 > widget.progress!.currentWeek) {
                    return _futureContainer(index);
                  }
                  return null;
                })));
  }

  double _calcWidth() {
    if (widget.videoSet.numberOfWeeks <= 3) {
      return MediaQuery.of(context).size.width * 0.2;
    } else if (widget.videoSet.numberOfWeeks > 3 &&
        widget.videoSet.numberOfWeeks <= 5) {
      return MediaQuery.of(context).size.width * 0.3;
    } else if (widget.videoSet.numberOfWeeks > 5 &&
        widget.videoSet.numberOfWeeks <= 8) {
      return MediaQuery.of(context).size.width * 0.4;
    } else if (widget.videoSet.numberOfWeeks > 8 &&
        widget.videoSet.numberOfWeeks <= 12) {
      return MediaQuery.of(context).size.width * 0.7;
    } else {
      return MediaQuery.of(context).size.width;
    }
  }

  _pastContainer(int index) {
    return Card(
        color: ColorUtils.teal,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Week ${index + 1}",
              style: TextStyle(
                  color: ColorUtils.black, fontWeight: FontWeight.bold)),
        ));
  }

  _currentContainer(int index) {
    return Card(
      elevation: 2,
      color: ColorUtils.teal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Week ${index + 1}",
            style: TextStyle(
                color: ColorUtils.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  _futureContainer(int index) {
    return Card(
      elevation: 2,
      color: Color(0xEAEAEA),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Week ${index + 1}", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
