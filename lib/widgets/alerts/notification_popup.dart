import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
//full screen notification
class NotificationPopup {
  show(title, content, context) {
    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => TemplateSuccess(options),
    );
    popup.show(
      title: title,
      content: Container(
        color: Colors.white12,
        child: Text(content),
      ),
      actions: [
        popup.button(
          label: 'Close',
          onPressed: () {
            Navigator.of(context).pop();
          }),
      ],
    );
  }

  handleNotifcation(messages, RemoteMessage event, BuildContext context) {
    RemoteNotification? notification = event.notification;
    AndroidNotification? android = event.notification?.android;
    var title = notification?.title.toString();
    var body = notification?.body.toString();
    if (android != null && notification != null) {
      if (messages.contains(event) == false) {
        NotificationPopup().show(title!, body!, context);
        messages.add(event);
      }
    }
  }
}
