import 'fitness_video_set.dart';

class Video {
  late String videoUrl;
  late String videoTitle;
  late String videoLength;
  late String description;
  late String videoId;
  late String dayNumber;
  late String weekNumber;
  late String fitnessVideoSetId = "1";
  late FitnessVideoSet? fitnessVideoSet;
  String thumbnailUrl = '';
  Video(
      {required this.videoTitle,
      required this.videoUrl,
      videoLength,
      videoId,
      description,
      dayNumber,
      weekNumber,
      fitnessVideoSetId,
      thumbnailUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    var video = Video(
        videoTitle: json["title"],
        videoUrl: json['file_location_path'],
        videoLength: json["video_length"],
        videoId: json['video_id'],
        description: json['description'],
        fitnessVideoSetId: json['fitness_video_set_id']);
    video.dayNumber = json['day_number'].toString();
    video.weekNumber = json['week_number'].toString();
    video.videoId = json['video_id'].toString();
    video.thumbnailUrl = json['video_thumbnail_url'].toString();
    if (json['fitness_video_set'] != null) {
      video.fitnessVideoSet =
          FitnessVideoSet.fromJson(json['fitness_video_set']);
    }
    return video;
  }

  String toString() {
    return "(id: ${this.videoId}, fitness_video_set_id: ${this.fitnessVideoSetId} thumb: ${this.thumbnailUrl} url: ${this.videoUrl})";
  }

  Map<String, dynamic> toJson() {
    return {
      'title' : this.videoTitle,
      'file_location_path' : this.videoUrl,       
      'video_length' : '0:00',
      'video_id' : this.videoId,
      'description': '',
      'fitness_video_set_id': this.fitnessVideoSetId,
      'day_number' : this.dayNumber,
      'week_number': this.weekNumber,
      'video_thumbnail_url': this.thumbnailUrl,
      'fitness_video_set': {
        'number_of_weeks': this.fitnessVideoSet!.numberOfWeeks,
        'videos_in_week': this.fitnessVideoSet!.videosInWeek,
        'set_name': this.fitnessVideoSet!.setName,
        'fitness_video_set_id': this.fitnessVideoSet!.fitnessVideoSetId
      }
    };
  }
  static List<Video> fromList(json) {
    return (json as List<dynamic>).map((v) => Video.fromJson(v)).toList();
  }
}
