import 'dart:io';

import 'package:cron/cron.dart';
import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/ext/videos_background_cacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This class checks every hour (cronSchedule) whether there is a global flag set
// (weekToCache) to start caching videos for that week. If there is the caching (downloading)
// process will start to get the next week videos and flag is cleared 
class ScheduledVideoCacher {
  final cron = Cron();
  final String cronSchedule = '0 */6 * * *';  //every 6th hour
  //final String cronSchedule = '*/1 * * * * '; //every minute - for testing
  void call() {
    try {
      cron.schedule(Schedule.parse(cronSchedule), () async {
        SharedPreferences.getInstance().then((prefs) async {
          var weekToCache = prefs.getInt('weekToCache');

          if (weekToCache != null) {
            VideosBackgroundCacher.cacheNextWeek(weekToCache.toString())
              .then((res) {
                ParticipantData.clearCachedWeek();
              });
          } else {
            print("No video set week marked for caching"); 
            // next week should be marked for caching with 
            //scheduled video cacher when watched last video of the week has been watched. 
            //it runs a cron job every 6th hour of the day checking if this had happend. 
          }
        });
      });
    } on SocketException {
      print("Error caching videos - will try again soon...");
    }
  }
}
