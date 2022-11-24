import 'dart:io';
import 'package:device_info/device_info.dart';

class DeviceId {
  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print(androidDeviceInfo.androidId);
      return androidDeviceInfo.androidId;
    }
  }
}
