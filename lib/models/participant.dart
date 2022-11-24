import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/models/video.dart';

class Participant {
  String firstName = '';
  String lastName = '';
  bool purgeCache = false;
  late String participantId;
  late String uuid;
  late List<Video> videos = <Video>[];

  String get fullName => "$firstName $lastName";

  Participant(
      {required this.firstName,
      required this.lastName,
      required List videos,
      required this.participantId,
      purgeCache,
      uuid});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
        firstName: json["first_name"],
        lastName: json['last_name'],
        participantId: json['participant_id'].toString(),
        uuid: json['unique_device_id'],
        purgeCache: json['purge_cache'] as bool,
        videos: Video.fromList(json['videos']));
  }

  static Future<Participant> fromPrefs() async {
    var participant = await ParticipantData.load();
    return Participant.fromJson(participant);
  }
}
