import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:respect_health/screens/splash_screen.dart';
import 'package:respect_health/widgets/video_player/vlc_player_with_controls.dart';
import 'package:wakelock/wakelock.dart';

import '../ext/participant_data.dart';
import '../ext/videos_background_cacher.dart';
import '../models/participant.dart';
import '../models/participation_progress.dart';
import '../models/video.dart';
import '../services/local_video_presence_manager.dart';
import '../services/watched_video_marker.dart';
import '../utils/color_utils.dart';
import '../utils/file_downloader.dart';
import '../utils/rh_cache_manager.dart';
import 'home_screen.dart';

class VlcPlayerScreen extends StatefulWidget {
  Video video;
  Participant participant;
  ParticipationProgress participationProgress;

  VlcPlayerScreen(
      {final Key? key,
      required this.video,
      required this.participant,
      required this.participationProgress})
      : super(key: key);

  @override
  _VlcPlayerScreenState createState() => _VlcPlayerScreenState();
}

class _VlcPlayerScreenState extends State<VlcPlayerScreen> {
  VlcPlayerController? _videoPlayerController;
  CacheManager _cacheManager = RespectHealthCacheManager.instance;
  late Future futureData;
  @override
  void initState() {
    super.initState();
    futureData = initController();
  }

  initController() async {
    var downloader =
        VideoDownloader(widget.video.videoUrl, widget.video.videoId);
    var isDownloaded = await downloader.isDownloaded();
    var filePath = await downloader.filePath();
    if (!isDownloaded) {
      print('[VideoControllerService]: No video in cache');
      print("video url" + widget.video.videoUrl);
      _videoPlayerController = VlcPlayerController.network(
          widget.video.videoUrl,
          hwAcc: HwAcc.full,
          autoPlay: true,
          options: VlcPlayerOptions());
      _videoPlayerController?.addListener(listener);
      return _videoPlayerController;
    } else {
      print('[VideoControllerService]: Loading video from cache');
      _videoPlayerController = VlcPlayerController.file(File(filePath),
          hwAcc: HwAcc.full, autoPlay: true, options: VlcPlayerOptions());
      _videoPlayerController?.addListener(listener);
      return _videoPlayerController;
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(listener);
    super.dispose();
    _videoPlayerController?.stopRendererScanning().then((_) {
      _videoPlayerController?.dispose().then((_) {});
    });
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_videoPlayerController!.value.isInitialized) {
      var oPosition = _videoPlayerController!.value.position;
      var oDuration = _videoPlayerController!.value.duration;
      if (_videoPlayerController!.value.isEnded &&
          oPosition.inSeconds == oDuration.inSeconds) {
        _finishUp();
        return;
      }
      setState(() {});
    }
    if (_videoPlayerController!.value.isEnded) {
      _finishUp();
    }
  }

  _finishUp() {
    _markAsViewed();
    if (VideosBackgroundCacher.shouldRunVideoCache(
        widget.participationProgress)) {
      //run background video download/caching for the next week if its last video of the current week
      var weekNum = widget.participationProgress.currentWeek + 1;
      unawaited(VideosBackgroundCacher.cacheNextWeek(weekNum.toString()));
    }
    _navigateAway();
  }

  _navigateAway() {
    var showCongrats = widget.video.fitnessVideoSet != null &&
        widget.video.fitnessVideoSet!.videosInWeek ==
            int.parse(widget.video
                .dayNumber); // show congratulations for finish the week before leaving if its the last video in the week
    if (!mounted) {
      return;
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          if (showCongrats) {
            return SplashScreen(week: int.parse(widget.video.weekNumber));
          } else {
            return HomeScreen(
                videoSet: widget.video.fitnessVideoSet,
                participant: widget.participant,
                participationProgress: widget.participationProgress,
                weekNumber: widget.participationProgress.currentWeek,
                participationProgressId:
                    widget.participationProgress.fitnessParticipationProgessId);
          }
        }),
        (route) =>
            false, //if you want to disable back button navigation feature set to false
      );
    } // already unmounted and gone
  }

  _markAsViewed() async {
    widget.video.fitnessVideoSetId =
        widget.participationProgress.fitnessVideoSetId.toString();
    ParticipantData.setLastViewed(
        widget.video, widget.participant, widget.participationProgress);
    LocalVideoPresenceManager().addToLocalList(widget.video.videoId);
    WatchedVideoMarker().markVideoAsViewed(
        widget.participationProgress.fitnessVideoSetId.toString(),
        widget.video,
        widget.participant);
  }

  Widget build(BuildContext context) {
    Wakelock.enable(); //keeps the screen active
    return FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: VlcPlayerWithControls(
                    controller: _videoPlayerController!, showControls: true));
          } else {
            return SpinKitPumpingHeart(color: ColorUtils.teal, size: 100);
          }
        });
  }
}
