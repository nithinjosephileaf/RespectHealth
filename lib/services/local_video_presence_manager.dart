import 'package:respect_health/ext/participant_data.dart';

// This class manages local seen videos list (with their ids). 
// uses local  preferences
////Used to immediately mark video as 'seen' after being watched (thumbnail color changes from available to green)
///Even though this information is send also to remote database immediately we do not refresh thumbnails 
///based on remote information straight away but the next day, when unlocked next video
///  THis is just to indicate to the user before moving to the next day
class LocalVideoPresenceManager {
  Future<List<String>> getLocalList() async {
    var localList = await ParticipantData.localViewedList();
    return localList ?? <String>[];
  }

  void setLocalList(List<String> localList) async {
    await ParticipantData.setLocalViewedList(localList);
  }

  Future<bool> addToLocalList(String itemId) async {
    var localList = await getLocalList();
    if (localList.contains(itemId) == false) {
      localList.add(itemId);
      setLocalList(localList);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeFromLocalList(String itemId) async {
    var localList = await getLocalList();
    if (localList.contains(itemId) == false) {
      return false;
    } else {
      await ParticipantData.clearLocalViewedList();
      return true;
    }
  }

  clearLocalList() async {
    ParticipantData.clearLocalViewedList();
  }

  Future<bool> isInLocalList(String itemId) async {
    var localList = await getLocalList();
    return localList.contains(itemId);
  }
}
