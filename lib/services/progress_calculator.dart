import 'package:respect_health/ext/participant_data.dart';

import '../models/fitness_video_set.dart';

class ProgressCalculator {

  ProgressCalculator();
  
   Future<double> run(FitnessVideoSet videoSet)  {
     return ParticipantData.localViewedList().then((list) {
      if (list == null) return 0;
      int? len = list.length;
      if (list.length == 0) return 0;
      int totalVideos = videoSet.videosInWeek * videoSet.numberOfWeeks;
      return ((100 * len) / totalVideos);
    });
   
  }
}