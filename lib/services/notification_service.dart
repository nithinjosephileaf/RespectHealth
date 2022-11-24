import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
/// this class is not used as of yet but you could utilise it for local notifications
/// flutter_local_notifications plugin allow to send local app notifications as opposed to the friebase ones. 
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  Future<void> showNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, 
    NotificationDetails details, String? message, String? title) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        message,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 120)),
        details,
        androidAllowWhileIdle: true,
        
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

  }

  NotificationService._internal();
  NotificationDetails init(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
   const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'mainChannel',
    'mainChannel',
    'Notifying participants',
    visibility: NotificationVisibility.public,
    playSound: true,
    priority: Priority.max,
    importance: Importance.max,
  );
  tz.initializeTimeZones();  //  <----init time zone
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: _androidNotificationDetails);
         flutterLocalNotificationsPlugin.initialize(initializationSettings);
    return platformChannelSpecifics;
  }
}