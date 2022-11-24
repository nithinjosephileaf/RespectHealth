import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:respect_health/utils/color_utils.dart';

class RespectHealthNavigation extends StatefulWidget {
  const RespectHealthNavigation({Key? key}) : super(key: key);

  @override
  _RespectHealthNavigation createState() => _RespectHealthNavigation();
}

class _RespectHealthNavigation extends State<RespectHealthNavigation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
      child: GNav(
        gap: 8,
        color: Colors.white,
          activeColor: Colors.white,
          iconSize: 48,
          tabBackgroundColor: Colors.white.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          duration: Duration(milliseconds: 1000),
          tabs: [
            GButton(
              icon: LineIcons.home,
              textStyle: TextStyle(fontSize: 26, color: ColorUtils.black),
              text: 'Home',
            )
          ],
          selectedIndex: 0,
          onTabChange: (index) {
            setState(() {
              //selectedIndex = index;
            });
          }
      )
    );
  }
}
