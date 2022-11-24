import 'package:flutter/material.dart';
import 'package:respect_health/models/fitness_video_set.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/widgets/download_cache/progress_indicator.dart';
import 'package:respect_health/widgets/home_page/profile_avatar.dart';
import 'package:respect_health/widgets/home_page/week_info.dart';

import '../../api/video_api.dart';

class Header extends StatefulWidget {
  final double width, height;
  int index;
  final Participant participant;
  final ParticipationProgress? participantProgress;
  final FitnessVideoSet videoSet;
  double? localProgress = 0;
  Header(
      {Key? key,
      required this.width,
      required this.height,
      required this.index,
      required this.participant,
      required this.participantProgress,
      required this.videoSet,
      this.localProgress})
      : super(key: key);
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  _loadProgress() {
    if (widget.participantProgress == null) return;
    VideosApi()
        .getProgress(widget.participantProgress!.fitnessParticipationProgessId
            .toString())
        .then((progress) {
      if (mounted) {
        setState(() {
          widget.localProgress = progress.percentageProgress.toDouble();
        });
      }
    });
  }

  double _progressValue() {
    if (widget.localProgress != null && widget.localProgress! > 0)
      return widget.localProgress! / 100;
    else
      return widget.participantProgress!.percentageProgress.toDouble() / 100;
  }

  @override
  Widget build(BuildContext context) {
    //_loadProgress();
    return Positioned(
        left: 00,
        top: 50,
        height: widget.height,
        width: widget.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: WeekInfo(number: widget.index + 1)),
              ProfileAvatar(participant: widget.participant),
              RhProgressIndicator(progress: _progressValue())
            ]));
  }
}
