class FitnessVideoSet {
  late int numberOfWeeks;
  late int videosInWeek;
  late String setName;
  late int fitnessVideoSetId;

  FitnessVideoSet(
      {required this.numberOfWeeks,
      required this.videosInWeek,
      required this.setName,
      required this.fitnessVideoSetId});

  factory FitnessVideoSet.fromJson(Map<String, dynamic> json) {
    var fvs = FitnessVideoSet(
        numberOfWeeks: json['number_of_weeks'],
        videosInWeek: json['videos_in_week'],
        setName: json['set_name'],
        fitnessVideoSetId: json['fitness_video_set_id']);
    return fvs;
  }
}
