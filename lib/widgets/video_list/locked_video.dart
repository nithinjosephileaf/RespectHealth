import 'package:flutter/material.dart';
import 'package:respect_health/widgets/video_list/sections.dart';

import '../alerts/rh_alert_message.dart';

class LockedVideo extends StatefulWidget {
  String thumbnail = '';
  String title = '';
  LockedVideo({required this.thumbnail, required this.title});

  @override
  State<StatefulWidget> createState() => _LockedVideoState();
}

class _LockedVideoState extends State<LockedVideo> {
  @override
  Widget build(BuildContext context) {
    return Center(
        heightFactor: 160,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Expanded(
            child: Sections(
                viewed: false,
                disabled: true,
                widthFull: 550,
                thumbnail: widget.thumbnail,
                child: InkWell(
                    onTap: () {
                      RhAlertMessage("This video is not available yet.",
                          'Please come back later', context);
                    },
                    child: Text(''))),
          )
        ]));
  }
}
