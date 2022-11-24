import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';
import 'package:respect_health/screens/splash_screen.dart';
import 'package:respect_health/utils/rh_cache_manager.dart';
import 'package:respect_health/widgets/video_player/custom_controls_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../ext/participant_data.dart';
import '../services/local_video_presence_manager.dart';
import '../services/watched_video_marker.dart';
import '../utils/color_utils.dart';
import '../utils/current_screen.dart';
import 'home_screen.dart';

//video playback screen
// ignore: must_be_immutable
class VideoPlayerScreen extends StatefulWidget {
  Video video;
  Participant participant;
  ParticipationProgress participationProgress;
  VideoPlayerController? videoPlayerController;
  VideoPlayerScreen(
      {final Key? key,
      required this.video,
      required this.participant,
      required this.participationProgress})
      : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  ChewieController? _chewieController;
  late CacheManager _cacheManager;
  late Future futureData;
  @override
  void initState() {
    super.initState();
    setState(() {
      futureData = setup();
    });
  }

  Future<ChewieController?> setup() async {
    if (_chewieController == null) {
      // If there was no controller, just create a new one
      await initController();
    } else {
      // If there was a controller, we need to dispose of the old one first as its blocking 
      //hardware video/audio resources
      final oldController =
          _chewieController; 
          //chewie controller wraps native player video controller
          // but we need to get rid of them both (they block video resources if not disposed)
      oldController?.dispose();
      final oldVideoController = widget.videoPlayerController;
      oldVideoController?.removeListener(_onVideoFinished);
      oldVideoController?.dispose();
      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        oldController?.dispose();
        oldVideoController?.removeListener(_onVideoFinished);
        oldVideoController?.dispose();
        // Initing new controller
        await initController();
      });

      // Making sure that controller is not used by setting it to null
      setState(() {
        _chewieController = null;
        widget.videoPlayerController = null;
      });
    }
    return _chewieController;
  }

  initController() async {
    _cacheManager = RespectHealthCacheManager.instance;
    var fileInfo = await _cacheManager.getFileFromCache(widget.video.videoUrl); 
    if (fileInfo == null) {
      print('[VideoControllerService]: No video in cache');
      print('[VideoControllerService]: Saving video to the cache');
      unawaited(_cacheManager.downloadFile(widget.video.videoUrl));
      widget.videoPlayerController =
          VideoPlayerController.network(widget.video.videoUrl);
    } else {
      print('[VideoControllerService]: Loading video from cache');
      print(fileInfo.file.path);
      widget.videoPlayerController =
          VideoPlayerController.file(File(fileInfo.file.path));
    }
    widget.videoPlayerController?.addListener(_onVideoFinished);
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController!,
        aspectRatio: 16 / 9,
        // Prepare the video to be played and display the first frame
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: true,
        allowPlaybackSpeedChanging: false,
        customControls: CustomControlsWidget(
            backgroundColor: Colors.blue, iconColor: Colors.white),
            
        // Errors can occur for` example when trying to play a video
        // from a non-existent URL
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    CurrentScreen.value = 'Player'; //this could be done more effectively with named navigation routes
    Wakelock.enable(); //keeps the screen active
    return FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _scaffold();
          } else {
            return SpinKitPumpingHeart(color: ColorUtils.teal, size: 100);
          }
        });
  }

  Widget _scaffold() {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.video.videoTitle),
        ),
        body: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: _chewieController!,
          ),
        ));
  }

  void _onVideoFinished() {
    if (widget.videoPlayerController!.value.isInitialized &&
        widget.videoPlayerController?.value.position ==
            widget.videoPlayerController?.value.duration) {
      _navigateAway();  // go back home or splash screen after the video had finished playing
    }
  }

  @override
  void dispose() {
    // properly dispose all objects and nullify them to avoid memory leak
    if (mounted) { //this is not always true when there was an error, causing more errors
      _markAsViewed();
      _disposeVideoControllers();
    }
    super.dispose();
  }

  void _disposeVideoControllers() {
    _chewieController?.dispose();
    widget.videoPlayerController?.removeListener(_onVideoFinished);
    widget.videoPlayerController?.dispose();
  }

  void _markAsViewed() async {
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

  _navigateAway() {
    var showCongrats = widget.video.fitnessVideoSet != null &&
        widget.video.fitnessVideoSet!.videosInWeek ==
            int.parse(widget.video.dayNumber);
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
        (route) => false, //if you want to disable back button navigation feature set to false
      );
    } // already unmounted and gone
  }
}
