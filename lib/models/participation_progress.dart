class ParticipationProgress {
  late int fitnessParticipationProgessId;
  late int participantId;
  late int fitnessVideoSetId;
  late String createdAt;
  late int currentWeek;
  late int currentDay;
  late String startedDate;
  late String lastSeenDate;
  late int percentageProgress;
  late String videoStoppedAt;

  ParticipationProgress(
      {required this.fitnessParticipationProgessId,
      required this.participantId,
      required this.fitnessVideoSetId,
      required this.createdAt,
      required this.currentWeek,
      required this.currentDay,
      required this.startedDate,
      required this.lastSeenDate,
      required this.percentageProgress,
      required this.videoStoppedAt});

  factory ParticipationProgress.fromJson(Map<String, dynamic> json) {
    return ParticipationProgress(
        fitnessParticipationProgessId:
            json['fitness_participation_progress_id'],
        participantId: json['participant_id'],
        fitnessVideoSetId: json['fitness_video_set_id'],
        createdAt: json['created_at'],
        currentWeek: json['current_week'],
        currentDay: json['current_day'],
        startedDate: json['started_date'],
        lastSeenDate: json['last_seen_date'],
        percentageProgress: json['percentage_progress'],
        videoStoppedAt: json['video_stopped_at']);
  }


  String toString() {
    return "(id: ${this.fitnessParticipationProgessId}, fitness_video_set_id: ${this.fitnessVideoSetId}) %%%%%%%${this.percentageProgress}";
  }
}
