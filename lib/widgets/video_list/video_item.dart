import 'package:flutter/material.dart';
import 'package:respect_health/abstract_player.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';
import 'package:respect_health/services/local_video_presence_manager.dart';
import 'package:respect_health/widgets/video_list/sections.dart';
import 'package:respect_health/widgets/video_list/viewed_video.dart';

import 'play_button.dart';

class VideoItem extends StatefulWidget {
  late Video video;
  final Function() notifyParent;
  Participant participant;
  ParticipationProgress participationProgress;
  int order = 0;

  VideoItem(
      {required this.video,
      required this.participant,
      required this.participationProgress,
      required this.notifyParent});
  @override
  State<StatefulWidget> createState() {
    return _VideoItemState(isViewedLocally: false);
  }
}

class _VideoItemState extends State<VideoItem> with AbstractPlayer {
  LocalVideoPresenceManager _presenceManager = LocalVideoPresenceManager();

  _VideoItemState({required this.isViewedLocally});
  bool isViewedLocally;
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      _presenceManager.isInLocalList(widget.video.videoId).then((isViewed) {
        setState(() {
          isViewedLocally = isViewed;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isViewedLocally) {
      return ViewedVideo(
          thumbnail: widget.video.thumbnailUrl,
          title: widget.video.videoTitle,
          videoId: widget.video.videoId.toString(),
          notifyParent: widget.notifyParent);
    } else {
      return Center(
          heightFactor: 160,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
                child: Text(widget.video.videoTitle,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                padding: EdgeInsets.only(bottom: 0)),
            Expanded(
              child: Sections(
                  disabled: false,
                  viewed: false,
                  thumbnail: widget.video.thumbnailUrl,
                  widthFull: 550,
                  child: InkWell(
                      child: PlayButton(
                          video: widget.video,
                          participant: widget.participant,
                          participationProgress: widget.participationProgress),
                      onTap: () {
                        _playVideo(context);
                      })),
            )
          ]));
    }
  }

  void _playVideo(BuildContext context) {
    playVideo(context, widget.video, widget.participant,
        widget.participationProgress);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
