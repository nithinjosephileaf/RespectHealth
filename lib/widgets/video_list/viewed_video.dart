import 'package:flutter/material.dart';
import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/widgets/alerts/rh_alert_message.dart';
import 'package:respect_health/widgets/video_list/sections.dart';

import '../alerts/rh_alert_confirmation.dart';
import 'check_button.dart';

class ViewedVideo extends StatefulWidget {
  String thumbnail = '';
  String title = '';
  int order = 0;
  String videoId;
  final Function() notifyParent;
  ViewedVideo(
      {required this.thumbnail,
      required this.title,
      required this.videoId,
      required this.notifyParent});

  @override
  State<StatefulWidget> createState() {
    return _ViewedVideoState();
  }
}

class _ViewedVideoState extends State<ViewedVideo> {
  @override
  Widget build(BuildContext context) {
    return Center(
        heightFactor: 160,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              child: Text(widget.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              padding: EdgeInsets.only(bottom: 0)),
          Expanded(
            child: Sections(
                disabled: false,
                viewed: true,
                widthFull: 550,
                thumbnail: widget.thumbnail,
                child: InkWell(
                    onLongPress: () {
                      RhAlertConfirmation(
                          "Remove video from watched?",
                          'You will be able to watch it again',
                          this.context, () {
                        print(widget.videoId);
                        ParticipantData.removeLocalViewedList(widget.videoId);
                        Navigator.pop(context);
                        widget.notifyParent();
                      });
                    },
                    onTap: () {
                      RhAlertMessage(
                          "You have seen this video already.", '', context);
                    },
                    child: CheckButton())),
          )
        ]));
  }
}
