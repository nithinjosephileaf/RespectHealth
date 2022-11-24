import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';

import 'base_uri.dart';

class VideosApi {
  // get videos for today (by participant Id and from video set)
  Future<List<Video>> todayFor(String participantId, String videoSetId) async {
    final authToken = await ParticipantData.authToken();
    var requestUrl = Uri.parse(
        "${BaseUri.value}/videoset/today/$videoSetId/participant/$participantId");
    final response = await http
        .get(requestUrl, headers: {"Authorization": "Bearer $authToken"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ParticipantData.saveList(data);
      return Video.fromList(data);
    } else {
      throw Exception('Unable to fetch excercise video list');
    }
  }

  //get current participant progress
  Future<ParticipationProgress> getProgress(
      String participationProgressId) async {
    final authToken = await ParticipantData.authToken();
    var requestUrl = Uri.parse(
        "${BaseUri.value}/participationprogress/$participationProgressId");
    final response = await http
        .get(requestUrl, headers: {"Authorization": "Bearer $authToken"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return ParticipationProgress.fromJson(data);
    } else {
      throw Exception('Unable to fetch particpation progress');
    }
  }

  // mark video from video set and for given participant as viewed.
  Future<bool> markAsViewed(
      String vSetId, Video video, Participant participant) async {
    final authToken = await ParticipantData.authToken();
    // var requestUrl = Uri.parse(
    //     "${BaseUri.value}/videoset/view/$vSetId/participant/${participant.participantId}");
    // final response = await http.post(
    //   requestUrl,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'Authorization': "Bearer $authToken"
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     'day': video.dayNumber,
    //     'week': video.weekNumber,
    //     'videoIds': [video.videoId.toString()]
    //   }),
    // );
    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   throw Exception('Unable to mark this video as viewed');
    // }
    return false;
  }

  //get all thumbnails urls for video set with id
  Future<Map<String, dynamic>> getThumbnails(String videoSetId) async {
    final authToken = await ParticipantData.authToken();
    var requestUrl = Uri.parse("${BaseUri.value}/video/thumbs/$videoSetId");
    final response = await http
        .get(requestUrl, headers: {"Authorization": "Bearer $authToken"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Unable to fetch video thumbails');
    }
  }

  Future<Map<String, dynamic>> getSummaryInformation(
      String videoSetId, String participantId) async {
    final authToken = await ParticipantData.authToken();
    var requestUrl = Uri.parse(
        "${BaseUri.value}/summary/$videoSetId/participant/$participantId");
    final response = await http
        .get(requestUrl, headers: {"Authorization": "Bearer $authToken"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Unable to fetch summary');
    }
  }
}
