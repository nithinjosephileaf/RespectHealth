import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RhAlertConfirmation{
  final String title;
  final String content;
  final BuildContext context;
  final Function confirmedFn;

  RhAlertConfirmation(this.title, this.content, this.context, this.confirmedFn) {
      Alert(
      context: this.context,
      type: AlertType.warning,
      title: this.title,
      desc: this.content,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => confirmedFn(),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
}
