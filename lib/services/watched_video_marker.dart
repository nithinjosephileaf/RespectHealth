import 'dart:io';

import 'package:cron/cron.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:respect_health/api/video_api.dart';
import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/video.dart';
import 'package:respect_health/utils/rh_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/file_downloader.dart';

//marked video locally as viewed then mark in the remote database
class WatchedVideoMarker {
  CacheManager _cacheManager = RespectHealthCacheManager.instance;
  final cron = Cron();
  final String cronSchedule = '0 */6 * * *'; //run every six hours
  //final String cronSchedule = '*/1 * * * * ';

  void call() async {
    try {
      List<Video> videos = await _extractVideosFromPreferences();

      cron.schedule(Schedule.parse(cronSchedule), () async {
        SharedPreferences.getInstance().then((prefs) async {
          var lastViewed = prefs.getString('lastViewed'); //last videwed video string

          if (lastViewed != null) {

            Video video = _getVideoFromLastViewed(lastViewed, videos);

            var participant = await Participant.fromPrefs();
            var videoSetId = lastViewed.split(":")[1];
            
            markVideoAsViewed(videoSetId, video, participant); //in the remote database
          } else {
            print("No video to mark remotely");
          }
        });
      });
    } on SocketException {
      print("Exception while marking video as watched. Will try again according to schedule");
    }
  }

  void markVideoAsViewed(String videoSetId, Video video, Participant participant) {
    VideosApi().markAsViewed(videoSetId, video, participant)
      .then((res) {
        if (res) {
          ParticipantData.clearViewed();
          _cacheManager.removeFile(video.videoUrl);
          VideoDownloader(video.videoUrl, video.videoId).deleteFile();
           //remove from local cache
        }
      }).catchError((error, stackTrace) {
        print("Exception while marking video as watched. Will try again according to the schedule");
    });
  }

  //load locally saved json response with all programme videos
  Future<List<Video>> _extractVideosFromPreferences() async {
    var videos = <Video>[];
    var participant = await ParticipantData.load();
    if (participant != null) {
      videos = Video.fromList(participant!['videos']);
    }
    return videos;
  }
  // get video from last viewed string and find it in videos
  Video _getVideoFromLastViewed(String lastViewed, List<Video> videos) {
    String videoId = lastViewed.split(":").first;
    Video video = videos.where((v) => v.videoId == videoId).first;
    return video;
  }
}
