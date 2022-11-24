import 'dart:convert';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';
import 'package:shared_preferences/shared_preferences.dart';
//local storage for participant. Wiped out when app uninstalls. Storing locally various information
class ParticipantData {
  //initial call to the backed with response containing all videos and urls
  static save(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', data['auth_token']);
    return prefs.setString('userData', json.encode(data));
  }

  static dynamic load() {
    return SharedPreferences.getInstance().then((prefs) {
      var data = prefs.getString('userData');
      return json.decode(data.toString());
    });
  }

  //skip to download first week of videos set to true after they have been downloaded
  static setSkipDownloading(bool value) {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('skipDownloading', value);
    });
  }

  static Future<bool> getSkipDownloading() {
    return SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('skipDownloading') == null) {
        return false;
      } else {
              return prefs.getBool(
        'skipDownloading',
      )!;
      }

    });
  }

  //jwt api token
  static Future<String> authToken() {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('authToken')!;
    });
  }

  //json response with videos (its used when device is off-line)
  static saveList(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('videoListData', json.encode(data));
  }

  //videos thumbnails urls (used when device goes off-line)
  static saveThumbs(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('videoThumbs', json.encode(data));
  }

  static getVideoList() async {
    return SharedPreferences.getInstance().then((prefs) {
      var data = prefs.getString('videoListData');
      return json.decode(data.toString());
    });
  }

  static getThumbs() async {
    return SharedPreferences.getInstance().then((prefs) {
      var data = prefs.getString('videoThumbs');
      return json.decode(data.toString());
    });
  }

  //last viewed video string stored locally "videoId:setId:participantId"
  //this will be set to null when send to the backend.
  static Future<String?> lastViewed() async {
    return SharedPreferences.getInstance().then((prefs) {
      var data = prefs.getString('lastViewed');
      return data;
    });
  }
  //when video is watched till the end a flag containing 3 values below is saved locally
  //then that flag is transfered over to remote database to mark video as watched there
  //
  static setLastViewed(
      Video video, Participant participant, ParticipationProgress progress) {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.setString('lastViewed',
          "${video.videoId}:${progress.fitnessVideoSetId}:${participant.participantId}");
    });
  }

  static clearViewed() {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.remove('lastViewed');
    });
  }

  //cache (download) video files for  week number
  static markForCaching(int weekNumber) {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('weekToCache', weekNumber);
    });
  }

  static Future<int?> getCachedWeek(int weekNumber) {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getInt('weekToCache');
    });
  }

  static clearCachedWeek() {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.remove('weekToCache');
    });
  }

  static Future<List<String>?> localViewedList() {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getStringList('localViewedList');
    });
  }

  static setLocalViewedList(List<String> list) {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('localViewedList', list);
    });
  }

  static clearLocalViewedList() {
    return SharedPreferences.getInstance().then((prefs) {
      prefs.remove('localViewedList');
    });
  }

  static removeLocalViewedList(String videoId) {
    return SharedPreferences.getInstance().then((prefs) {
     var list = prefs.getStringList('localViewedList');
     print("List before:::::");
     print(list.toString());
     list?.removeWhere((i) => i == videoId);
          print("List after:::::");
     print(list.toString());
     prefs.setStringList('localViewedList', list!);
    });
  }
}
