import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';
import 'package:respect_health/utils/file_downloader.dart';
import 'package:respect_health/utils/rh_cache_manager.dart';

import '../models/fitness_video_set.dart';
//this should be called at the end of each week to cache (download) next week videos
class VideosBackgroundCacher {
  List<String> _fetchWeeks = <String>[]; //ie ["1"] or ["2", "3"]
  List<dynamic> _videos = <dynamic>[];

  VideosBackgroundCacher(fetchWeeks) {
    _fetchWeeks = fetchWeeks;
  }

  Future<List<dynamic>> getVideos() async {
    var participant = await ParticipantData.load();
    _videos = Video.fromList(participant['videos']);
    switch (_fetchWeeks.length) {
      case 2:
        return _partialVideos(_fetchWeeks[0], _fetchWeeks[1]);
      case 1:
        return _partialVideosWeekly(_fetchWeeks[0]);
    }
    throw Exception("Invalid number of week array to fetch");
  }

  List<dynamic> _partialVideos(String week1, String week2) {
    _videos.sort((a, b) {
      return a.weekNumber.compareTo(b.weekNumber);
    });
    return _videos
        .where((vid) => vid.weekNumber == week1 || vid.weekNumber == week2)
        .toList();
  }

  List<dynamic> _partialVideosWeekly(String week) {
    _videos.sort((a, b) {
      return a.weekNumber.compareTo(b.weekNumber);
    });
    return _videos.where((vid) => vid.weekNumber == week).toList();
  }

  static Future cacheVideos(List<dynamic> videos) async {
    for (var video in videos) {
      var videoItem = video as Video;
      final fileInfo = await RespectHealthCacheManager.instance
          .getFileFromCache(videoItem.videoId);
      if (fileInfo == null) {
        print("Downloading....${videoItem.videoUrl}");
        //you could also use the same without cache manager see the method below
        await RespectHealthCacheManager.instance
            .downloadFile(videoItem.videoUrl, key: videoItem.videoId);
      } else {
        print(video.videoUrl + "...already cached...");
      }
    }
    ParticipantData.clearCachedWeek(); // clear the week that's been marked for caching/downloading
  }


  static Future cacheVideosWithoutCacheManager(List<dynamic> videos) async {
    for (var video in videos) {
      var videoItem = video as Video;
      var downloader = VideoDownloader(videoItem.videoUrl, videoItem.videoId);
      downloader.isDownloaded().then((isDownloaded) async {
        if (isDownloaded) {
          print(video.videoUrl + "...already cached...");
      } else {
        print("Downloading....${videoItem.videoUrl}");
        await downloader.call();
      }
      });
    }
    ParticipantData.clearCachedWeek(); // clear the week that's been marked for caching/downloading
  }


  static cacheNextWeek(String week) async {
    var cacher = VideosBackgroundCacher([week]);
    var videos = await cacher.getVideos();
    //await cacheVideos(videos);
    await cacheVideosWithoutCacheManager(videos);
  }

  static void cacheNextWeekIfNeeded(ParticipationProgress participantProgress, FitnessVideoSet videoSet) {
    if (VideosBackgroundCacher.shouldRunVideoCache(participantProgress)) {
      int nextWeekNumber = participantProgress.currentWeek + 1;
      ParticipantData.markForCaching(nextWeekNumber);
      VideosBackgroundCacher.cacheNextWeek(nextWeekNumber.toString());
    }
  }

  // caches every other week for the next two weeks
  static bool shouldRunVideoCache(ParticipationProgress progress) {
    bool cacheNeeded = 5 == progress.currentDay;
    return cacheNeeded;
  }
}
