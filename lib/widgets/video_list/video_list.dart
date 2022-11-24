import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:respect_health/api/video_api.dart';
import 'package:respect_health/ext/dimensions_data.dart';
import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/models/fitness_video_set.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';
import 'package:respect_health/widgets/video_list/locked_video.dart';
import 'package:respect_health/widgets/video_list/video_item.dart';
import 'package:respect_health/widgets/video_list/viewed_video.dart';

class VideoList extends StatefulWidget with DimensionsData {
  static String placeholderImg =
      'https://swoopmotorsports.com/wp-content/uploads/2015/07/video-placeholder.jpg';
  late int weekNumber;
  late Participant participant;
  late FitnessVideoSet videoSet;
  List<Video>? _children;
  Map<String, dynamic>? thumbs;
  late ParticipationProgress participationProgress;
  final Function() notifyParent;
  VideoList(
      {Key? key,
      required this.weekNumber,
      required participant,
      required videoSet,
      required participationProgress,
      required this.notifyParent})
      : super(key: key) {
    this.participant = participant;
    this.videoSet = videoSet;
    this.participationProgress = participationProgress;
  }
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  late Video firstVideo;
  @override
  void initState() {
    _fetchListForToday();
    _loadOffline();
    super.initState();
  }

  void _loadOffline() {
    ParticipantData.getVideoList().then((vds) {
      if (vds != null) {
        var videos = Video.fromList(vds);
        widget._children = videos;
        ParticipantData.getThumbs().then((thmbs) {
          widget.thumbs = thmbs;
        });
      }
    });
  }

  Future<List<Video>> _fetchListForToday() async {
    try {
      return VideosApi()
          .todayFor(widget.participant.participantId,
              widget.videoSet.fitnessVideoSetId.toString())
          .then((list) async {
        widget._children = list;
        var toSerialize = list.map((v) => v.toJson()).toList();
        await ParticipantData.saveList(toSerialize);
        await _fetchThumbs();
        return list;
      });
    } on SocketException {
      widget._children = ParticipantData.getVideoList();
      return widget._children!;
    }
  }

  _fetchThumbs() async {
    try {
      await VideosApi()
          .getThumbnails(widget.videoSet.fitnessVideoSetId.toString())
          .then((data) {
        ParticipantData.saveThumbs(data);
        widget.thumbs = data;
      });
    } on SocketException {
      widget.thumbs = await ParticipantData.getThumbs();
    }
  }

  int _swapIndex() {
    return widget._children!
        .map((v) {
          return int.parse(v.dayNumber) - 1;
        })
        .toList()
        .first;
  }

  //this will generate list with thumbnaiils for all videos in the past/future (witth the exception of current day video)
  List<Widget> _listItems() {
    print(_swapIndex());
    print(widget._children?.length);

    var flatten = <Widget>[];

    List.generate(widget.videoSet.videosInWeek, (i) {
      print(i);
      print(_swapIndex());
      if (widget.weekNumber == widget.participationProgress.currentWeek &&
          _swapIndex() == i) {
        print("Available video");
        widget._children!.forEach((v) {
          flatten.add(VideoItem(
              video: v,
              participant: widget.participant,
              participationProgress: widget.participationProgress,
              notifyParent: widget.notifyParent));
        });
      } else if (widget.weekNumber < widget.participationProgress.currentWeek) {
        print("Viewed video");
        flatten.add(ViewedVideo(
            thumbnail: _thumbUrl(i),
            title: "Session ${i + 1}",
            videoId: _videoId(i),
            notifyParent: widget.notifyParent)); //get index
      } else if (_swapIndex() < i) {
        print("Locked video");
        flatten
            .add(LockedVideo(thumbnail: _thumbUrl(i), title: "Day ${i + 1}"));
      } else if (_swapIndex() > i) {
        print("Last case");
        flatten.add(ViewedVideo(
            thumbnail: _thumbUrl(i),
            title: "Session ${i + 1}",
            videoId: _videoId(i),
            notifyParent: widget.notifyParent));
      }
    });

    return flatten;
  }

  String _thumbUrl(int index) {
    var weekThumbs = widget.thumbs![widget.weekNumber.toString()];

    if (weekThumbs == null) {
      weekThumbs = <dynamic>[];
    } else {
      weekThumbs = widget.thumbs![widget.weekNumber.toString()];
    }
    var thumb = weekThumbs.firstWhere((v) {
      return v != null &&
          v['day_number'] != null &&
          v['day_number'] - 1 == index;
    }, orElse: () => {'day_number': index + 1});
    return thumb['video_thumbnail_url'] == null
        ? VideoList.placeholderImg
        : thumb['video_thumbnail_url'];
  }

  String _videoId(int index) {
    var weekThumbs = widget.thumbs![widget.weekNumber.toString()];

    if (weekThumbs == null) {
      weekThumbs = <dynamic>[];
    } else {
      weekThumbs = widget.thumbs![widget.weekNumber.toString()];
    }
    var thumb = weekThumbs.firstWhere((v) {
      return v != null &&
          v['day_number'] != null &&
          v['day_number'] - 1 == index;
    }, orElse: () => {'day_number': index + 1});
    return thumb['video_id'] == null ? "0" : thumb['video_id'].toString();
  }

  @override
  Widget build(BuildContext context) {
    _loadOffline();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
    return FutureBuilder<List<Video>>(
      future: _fetchListForToday(), // async work
      builder: (BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Padding(
                padding: const EdgeInsets.only(bottom: 20.0, right: 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                  child: GridView(
                      // itemCount: widget._children!.length > 1
                      //     ? widget.videoSet.videosInWeek +
                      //     widget._children!.length -
                      //     1
                      //     : widget.videoSet.videosInWeek,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: widget.aspectRatio(context),
                        crossAxisSpacing: widget.crossSpacing(context),
                      ),
                      children: _listItems()),
                ));
        }
      },
    );
  }
}
