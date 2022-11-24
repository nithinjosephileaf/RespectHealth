import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/utils/rh_cache_manager.dart';

import 'base_uri.dart';

class ParticipantApi {
  //the very first call to fetch all participant information based on unique device id

  Future<Participant> fetchDevice() async {
    // var deviceId = await DeviceId.getId();
    var deviceId = "11f00a29230cf038";
    final response =
        await http.get(Uri.parse("${BaseUri.unauthorized}/uuid/$deviceId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await ParticipantData.save(data);
      var cacheManager = RespectHealthCacheManager.instance;
      var participantId = data['participant_id'];
      var purgeCache = data['purge_cache'] as bool;
      if (purgeCache) {
        cacheManager.emptyCache().whenComplete(() {
          updateCacheSetting(participantId.toString());
        });
      }
      return Participant.fromJson(data);
    } else {
      throw Exception('This device is not registered');
    }
  }

  //second call that sends push notification token to the backend and saved it. When the device registered for push notifications.
  //This token is used to send messages to particular device.
  Future<void> updateDevice(
      String deviceId, String pushNotificationToken) async {
    HttpClient webHttpClient = new HttpClient();
    webHttpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    dynamic ioClient = new IOClient(webHttpClient);

    final response = await ioClient.patch(
        Uri.parse("${BaseUri.unauthorized}/uuid/$deviceId"),
        body: {"push_notification_id": pushNotificationToken});
    if (response.statusCode != 200) {
      throw Exception('Unable to update this device');
    }
  }

  Future<void> updateCacheSetting(String participantId) async {
    final authToken = await ParticipantData.authToken();
    final response = await http.patch(
        Uri.parse("${BaseUri.value}/participant/$participantId"),
        headers: {"Authorization": "Bearer $authToken"},
        body: {"purge_cache": "false"});
    if (response.statusCode != 200) {
      throw Exception('Unable to update this device');
    }
  }
}
