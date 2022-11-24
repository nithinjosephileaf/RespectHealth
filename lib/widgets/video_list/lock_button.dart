import 'package:flutter/material.dart';

class LockButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LockButtonState();
  }
}

class _LockButtonState extends State<LockButton> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MaterialButton(
        onPressed: () {},
        color: Colors.blue,
        textColor: Colors.white,
        child: Icon(
          Icons.lock,
          size: 64,
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