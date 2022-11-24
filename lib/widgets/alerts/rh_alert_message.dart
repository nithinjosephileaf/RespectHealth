import 'package:flutter/material.dart';
import 'package:respect_health/utils/color_utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RhAlertMessage {
  final String title;
  final String content;
  final BuildContext context;

  RhAlertMessage(this.title, this.content, this.context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: title,
      desc: content,
      buttons: [
        DialogButton(
          color: ColorUtils.purple,
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 140,
        )
      ],
    ).show();
  }

  
}
