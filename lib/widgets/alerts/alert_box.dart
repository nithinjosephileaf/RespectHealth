import 'package:flutter/material.dart';
import 'package:respect_health/utils/color_utils.dart';
//dialog coming from the bottom with an animation (similar to toast notificaitons)
class AlertBox {
  final String title;
  final String content;
  final BuildContext context;

  AlertBox(this.title, this.content, this.context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.linear,
                ),
              ),
              child: child,
            ),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorUtils.coral,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.red[100],
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 60,
                padding: EdgeInsets.all(5),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Text(
                                  title.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                      color: ColorUtils.coral),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(content.toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: ColorUtils.coral))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(buildContext);
                          },
                          child: Icon(
                            Icons.clear,
                            color: ColorUtils.coral,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
