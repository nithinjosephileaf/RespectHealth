import 'package:flutter/material.dart';

class TopBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          alignment: AlignmentDirectional.topStart,
          image: AssetImage('images/background.png'),
          fit: BoxFit.fitWidth
        )
      ),
    );
  }
}
