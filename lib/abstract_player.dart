import 'package:flutter/material.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/screens/video_player_screen_vlc.dart';

import 'models/participant.dart';
import 'models/video.dart';

abstract class AbstractPlayer {
  void playVideo(BuildContext context, Video video, Participant participant,
      ParticipationProgress participationProgress) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VlcPlayerScreen(
          video: video,
          participant: participant,
          participationProgress: participationProgress,
        );
        //or VideoPlayerScreen - it has 2 players
      }));
    });
  }
}
