import 'package:flutter/material.dart';

class RespectHealthLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final margin = MediaQuery.of(context).size.height - 80;
    return Padding(
        padding: EdgeInsets.only(top: margin, left: 20),
        child: Container(
          width: 80.0,
          height: 40.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/logo_sm.png'), fit: BoxFit.cover)),
        ));
  }
}
