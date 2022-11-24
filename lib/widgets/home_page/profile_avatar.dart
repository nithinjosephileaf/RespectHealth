import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/utils/color_utils.dart';

class ProfileAvatar extends StatefulWidget {
  final Participant participant;
  ProfileAvatar({required this.participant});

  @override
  State<StatefulWidget> createState() {
    return _ProfileAvatarState();
  }

  String participantInitials() {
    return this.participant.firstName[0] + this.participant.lastName[0];
  }
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProfileAvatar(
              '',
              radius: 50,
              backgroundColor: ColorUtils.teal,
              borderWidth: 4,
              initialsText: Text(
                widget.participantInitials(),
                style: TextStyle(
                    fontSize: 40,
                    color: ColorUtils.black,
                    fontWeight: FontWeight.w700),
              ),
              borderColor: ColorUtils.black,
              elevation: 5.0,
              foregroundColor: Colors.brown.withOpacity(0.5),
              showInitialTextAbovePicture: true,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Good ${_greeting()}, ${widget.participant.firstName}",
                  style: TextStyle(
                      color: ColorUtils.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 22),
                ),
              ],
            ),
            Expanded(
              child: Text(
                Jiffy().yMMMMd,
                style: TextStyle(color: ColorUtils.black, fontSize: 18),
              ),
            ),
          ],
        ),
        padding: EdgeInsets.only(left: 30));
  }

  //time of the day under user initials avatar
  String _greeting() {
    var timeNow = DateTime.now().hour;
    if (timeNow < 12) {
      return 'Morning';
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      return 'Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }
}
