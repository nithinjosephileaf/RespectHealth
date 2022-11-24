import 'package:flutter/material.dart';

class CheckButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckButtonState();
  }
}

class _CheckButtonState extends State<CheckButton> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MaterialButton(
        onPressed: () {},
        color: Colors.transparent,
        textColor: Colors.white,
        child: Icon(
          Icons.check_box,
          size: 64,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(0),
        shape: CircleBorder(),
      )
    ],
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}