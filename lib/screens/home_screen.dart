import 'dart:async';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cron/cron.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:respect_health/api/video_api.dart';
import 'package:respect_health/ext/dimensions_data.dart';
import 'package:respect_health/ext/widget_rebuilder.dart';
import 'package:respect_health/models/fitness_video_set.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/utils/color_utils.dart';
import 'package:respect_health/widgets/alerts/alert_box.dart';
import 'package:respect_health/widgets/alerts/notification_popup.dart';
import 'package:respect_health/widgets/home_page/header.dart';
import 'package:respect_health/widgets/home_page/progress_timeline.dart';
import 'package:respect_health/widgets/home_page/respect_health_logo.dart';
import 'package:respect_health/widgets/home_page/top_background.dart';
import 'package:respect_health/widgets/video_list/video_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../ext/rh_swiper_control.dart';
import '../utils/current_screen.dart';

class HomeScreen extends StatefulWidget {
  final cron = Cron();
  final String cronSchedule =
      "3 6 * * *"; //this is disabled. Refresh happens on push notification arrival
  // final String cronSchedule = "* * * * *"; //this is disabled. Refresh happens on push notification arrival
  //refresh screen at 6:03 after checks had been run on the backend at 6:00.
  //If this is changed on the backend - see progressCheck.js it should be changed should be changed respectively after this process runs
  Participant participant;
  FitnessVideoSet videoSet;
  int participationProgressId;
  int weekNumber;
  static bool batteryWarningShown = false;
  ParticipationProgress? participationProgress;
  double? localProgress;
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }

  HomeScreen(
      {required participant,
      required videoSet,
      required participationProgressId,
      required weekNumber,
      participationProgress})
      : videoSet = videoSet,
        weekNumber = weekNumber,
        participant = participant,
        participationProgressId = participationProgressId {
    this.videoSet = videoSet;
    this.participant = participant;
    this.weekNumber = weekNumber;
    this.participationProgress = participationProgress;
    this.participationProgressId = participationProgressId;
  }
}

class HomeScreenState extends State<HomeScreen>
    with DimensionsData, WidgetsBindingObserver {
  static var messages = <String>[];
  AppLifecycleState? _notification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _refreshLocalProgress();
    setState(() {
      widget.weekNumber = 1;
      CurrentScreen.value = 'Home';
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    if (mounted) super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //below is disabled - refresh happens on push notification arrival. Was according to the cron setup
    widget.cron.schedule(Schedule.parse(widget.cronSchedule), () async {
      _refreshLocalProgress();
    });
    //ParticipantData.clearLocalViewedList(); //uncoment to allow watching video more than once
    CurrentScreen.value = 'Home';
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      if (mounted) {
        handleMessage(event);
        _refreshLocalProgress();
        refreshData();
        WidgetRebuilder().call(context);
      }
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      handleMessage(message);
      if (mounted) WidgetRebuilder().call(context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
      if (mounted) WidgetRebuilder().call(context);
    });
    return VisibilityDetector(
        key: Key("homeScreenKey"),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1.0) {
            refreshData();
            WidgetRebuilder().call(context);
          }
        },
        child: FutureBuilder(
            future: _fetchProgress(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return _widgetWrappedPopScope();
                default:
                  return SpinKitPumpingHeart(color: ColorUtils.teal, size: 100);
              }
            }));
  }

  Widget pageWidget(BuildContext context, int index, FitnessVideoSet videoSet) {
    return RefreshIndicator(
        onRefresh: () async {
          refreshData();
        },
        child: Stack(
          children: <Widget>[
            TopBackground(),
            Header(
                width: MediaQuery.of(context).size.width,
                height: 165,
                index: index,
                participantProgress: widget.participationProgress,
                participant: widget.participant,
                videoSet: widget.videoSet,
                localProgress: widget.localProgress),
            Align(
                alignment: Alignment
                    .topCenter, // This will horizontally center from the top
                child: Padding(
                  child: Container(
                    child: ProgressTimeline(
                        progress: widget.participationProgress,
                        videoSet: videoSet),
                  ),
                  padding: EdgeInsets.only(
                      top: 200, left: weekProgressLeftMargin(context)),
                )),
            VideoList(
                weekNumber: index + 1,
                participant: widget.participant,
                participationProgress: widget.participationProgress,
                videoSet: videoSet,
                notifyParent: _refreshLocalProgress),
            RespectHealthLogo()
          ],
        ));
  }

  // when push notification message arrives.
  void handleMessage(RemoteMessage event) async {
    RemoteNotification? notification = event.notification;
    AndroidNotification? android = event.notification?.android;
    var title = notification?.title.toString();
    var body = notification?.body.toString();
    if (android != null && notification != null) {
      if (messages.contains(event.messageId) == false) {
        NotificationPopup().show(title!, body!, context);
        messages.add(event.messageId.toString());
      }
    }
  }

  void handleBackgroundMessage(RemoteMessage event) async {
    RemoteNotification? notification = event.notification;
    AndroidNotification? android = event.notification?.android;
    var title = notification?.title.toString();
    var body = notification?.body.toString();
    if (android != null && notification != null) {
      NotificationPopup().show(title!, body!, context);
    }
  }

  Widget _widgetWrappedPopScope() {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Color(0xFFEAEAEA),
          body: Swiper(
            loop: false,
            itemBuilder: (BuildContext context, int index) {
              return pageWidget(context, index, widget.videoSet);
            },
            itemCount: widget.participationProgress!.currentWeek,
            index: widget.participationProgress == null
                ? 0
                : widget.participationProgress!.currentWeek - 1,
            pagination: SwiperPagination.rect,
            control: RhSwiperControl(
                color: ColorUtils.black,
                size: 50,
                disableColor: ColorUtils.black.withOpacity(0.2)),
          ),
        ),
        onWillPop: () async => true);
  }

  _refreshLocalProgress() {
    _fetchProgress().then((progr) {
      var progress = progr as ParticipationProgress;
      if (mounted) {
        setState(() {
          widget.localProgress = progress.percentageProgress.toDouble();
          widget.weekNumber = progress.currentWeek;
        });
      }
    });
  }

  Future<dynamic> _fetchProgress() async {
    return VideosApi().getProgress(widget.participationProgressId.toString());
  }

  refreshData() async {
    try {
      var progress = await _fetchProgress() as ParticipationProgress;
      widget.participationProgress = progress;
      if (mounted) {
        setState(() => widget.weekNumber = progress.currentWeek);
      }
      _refreshLocalProgress();
    } on SocketException {
      AlertBox(
          "ERROR",
          "Please connect to the internet and pull down the screen to refresh video list",
          context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      print(state);
    });
  }
}
