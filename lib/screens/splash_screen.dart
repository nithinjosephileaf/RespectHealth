import 'dart:async';
import 'package:flutter/material.dart';
import 'package:respect_health/screens/download_cache_screen.dart';
import 'package:respect_health/screens/rh_congrats_screen.dart';
import 'package:respect_health/widgets/home_page/top_background.dart';
import '../utils/current_screen.dart';

//Screen that shows other screens just for x seconds (aka Splash screen)
class SplashScreen extends StatefulWidget {
  int week;
  SplashScreen({required this.week});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static int _howLongToShowInSeconds = 5;

  void route() {//removes all previous screens from the stack and goes to downloadscript
   if (mounted) {
      Navigator.pushAndRemoveUntil<dynamic>(context, MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => DownloadCacheScreen()), 
          // go back to first screen, it goes to home if download needs to be skipped),
        (route) => false,//if you want to disable back feature set to false
      );
   }
  }

  initiateRoute() {
    var duration = Duration(seconds: _howLongToShowInSeconds);
    return Timer(duration, route);
  }

  @override
  void initState() {
    initiateRoute();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  

  @override
  Widget build(context) {
    CurrentScreen.value = 'Splash';
    return Scaffold(
        body: Column(children: [
          TopBackground(),
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[RhCongratsScreen(week: widget.week)],
        ),
      )
    ]));
  }
}
