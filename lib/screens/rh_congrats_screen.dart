import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../utils/current_screen.dart';
//shown after completion of each week (when the last video is viewed in the week)
class RhCongratsScreen extends StatefulWidget {
  RhCongratsScreen({required this.week});
  late int week;
  @override
  _CongratsScrenState createState() => _CongratsScrenState();
}

class _CongratsScrenState extends State<RhCongratsScreen> {
  late ConfettiController controllerTopCenter;
  @override
  void initState() {
    super.initState();
    setState(() {});
  }
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    CurrentScreen.value = 'Congrats';
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: Container(
              width: devWidth,
              height: devHeight - 30,
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.only(top: devHeight * 0.6, left: 0),
                    child: Column(children: [
                      Text('Congratulations!',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w700)),
                      Text('You completed week ${widget.week}!',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w700))
                    ]))
              ]),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/rh_trophy.png'),
                    fit: BoxFit.cover),
              ),
            ))
      ]),
    );
  }
}
