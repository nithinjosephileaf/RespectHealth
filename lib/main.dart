import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:pedantic/pedantic.dart';
import 'package:respect_health/screens/download_cache_screen.dart';
import 'package:respect_health/screens/error_screen.dart';
import 'package:respect_health/services/scheduled_video_cacher.dart';
import 'package:respect_health/services/watched_video_marker.dart';
import 'package:respect_health/utils/device_id.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:workmanager/workmanager.dart';

import 'api/particpant_api.dart';
import 'ext/participant_data.dart';
import 'ext/videos_background_cacher.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Called background task $task");
    switch (task) {
      case 'videoCache':
        //register these plugins for background task
        SharedPreferencesAndroid.registerWith();
        PathProviderAndroid.registerWith();
        var weekNumber = inputData!['weekNumber'] as String;
        await VideosBackgroundCacher.cacheNextWeek(weekNumber);
        ParticipantData.clearCachedWeek();
        return Future.value(true);

      case 'viewVideo':
        WatchedVideoMarker().call();
        return Future.value(true);
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  );
  WatchedVideoMarker().call();
  ScheduledVideoCacher().call();
  Workmanager().initialize(
      _callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  runApp(RespectHealthApp());
}

class RespectHealthApp extends StatefulWidget {
  static String initError = '';
  static RemoteMessage? lastMessage;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  @override
  _RespectHealthAppState createState() => _RespectHealthAppState();
}

class _RespectHealthAppState extends State<RespectHealthApp> {
  static bool _messageInitialized = false;
  static const MethodChannel _channel = MethodChannel('mainChannel');
  Map<String, String> channelMap = {
    "id": "mainChannel",
    "name": "mainChannel",
    "description": "Notifying participants",
  };
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print(message?.messageId.toString());
    });
    widget.messaging.getToken().then((token) {
      DeviceId.getId().then((deviceId) {
        print("Updating push notification google token...$token!");
        unawaited(ParticipantApi().updateDevice(deviceId, token!));
      });
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<dynamic>(
      future: _fetchDevice(), // async work
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _setupMessaging();
          return MaterialApp(
              navigatorKey: navigatorKey,
              home: (RespectHealthApp.initError == '')
                  ? DownloadCacheScreen()
                  : ErrorPage(RespectHealthApp.initError),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Poppins',
              ));
        } else {
          return Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                  child: const SpinKitPumpingHeart(
                      color: Color(0x0FDCD0), size: 100)));
        }
      });

  _fetchDevice() async {
    try {
      await ParticipantApi().fetchDevice();
    } on Exception catch (e) {
      print(e.toString());
      RespectHealthApp.initError = e.toString();
    }
  }

  void _setupMessaging() {
    if (_messageInitialized == false) {
      widget.messaging
          .requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )
          .then((settings) {
        _messageInitialized = true;
        print('User granted permission: ${settings.authorizationStatus}');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
