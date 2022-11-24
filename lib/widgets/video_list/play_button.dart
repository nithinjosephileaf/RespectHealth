import 'package:flutter/material.dart';
import 'package:respect_health/abstract_player.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';

class PlayButton extends StatefulWidget {
  final Participant participant;
  final ParticipationProgress participationProgress;
  final Video video;

  PlayButton(
      {required this.video,
      required this.participant,
      required this.participationProgress});

  @override
  State<StatefulWidget> createState() {
    return _PlayButtonState();
  }
}

class _PlayButtonState extends State<PlayButton> with AbstractPlayer {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          onPressed: () {
            playVideo(context, widget.video, widget.participant,
                widget.participationProgress);
          },
          color: Colors.transparent,
          textColor: Colors.white,
          child: Icon(
            Icons.play_circle,
            size: 64,
          ),
          padding: EdgeInsets.all(0),
          shape: CircleBorder(),
        )
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
