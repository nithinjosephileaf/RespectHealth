import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:respect_health/utils/device_id.dart';
import 'package:respect_health/widgets/alerts/rh_alert_message.dart';

import '../utils/current_screen.dart';

//Error page shown when lauched and when the device is not properly registered in the backend.
// 1. Add in authorized devices
// 2. Add participant with all its information and assign this device to him
// 3. Assign video set
class ErrorPage extends StatefulWidget {
  @override
  String message;
  ErrorPage(this.message);

  @override
  State<StatefulWidget> createState() {
    return _ErrorPageState();
  }
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => {
          DeviceId.getId().then((deviceId) {
            RhAlertMessage(
                widget.message,
                'You must add this device in the application backend, The device id is: $deviceId',
                this.context);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    CurrentScreen.value = 'ErrorPage';
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/error.png",
            fit: BoxFit.contain,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.14,
            left: MediaQuery.of(context).size.width * 0.065,
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)))),
              onPressed: () {
                DeviceId.getId().then((deviceId) {
                  Clipboard.setData(ClipboardData(text: deviceId));
                  RhAlertMessage(
                      'Device ID copied!',
                      'Copied device Id into clipboard. Please paste it in the backend/email/or text message',
                      this.context);
                });
              },
              child: Text(widget.message),
            ),
          )
        ],
      ),
    );
  }
}
