import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:respect_health/ext/participant_data.dart';
import 'package:respect_health/ext/videos_background_cacher.dart';
import 'package:respect_health/main.dart';
import 'package:respect_health/models/fitness_video_set.dart';
import 'package:respect_health/models/participant.dart';
import 'package:respect_health/models/participation_progress.dart';
import 'package:respect_health/models/video.dart';
import 'package:respect_health/screens/home_screen.dart';
import 'package:respect_health/utils/current_screen.dart';
import 'package:respect_health/utils/disposable_widget.dart';
import 'package:respect_health/utils/rh_cache_manager.dart';
import 'package:respect_health/widgets/download_cache/video_view_model.dart';

// ignore: must_be_immutable
class DownloadCacheScreen extends StatefulWidget with DisposableWidget {
  FitnessVideoSet videoSet = new FitnessVideoSet(
      numberOfWeeks: 7, videosInWeek: 5, setName: 'test', fitnessVideoSetId: 1);
  @override
  _DownloadCacheScreenState createState() => _DownloadCacheScreenState();
}

class _DownloadCacheScreenState extends State<DownloadCacheScreen> {
  List<Video> _videos = <Video>[];
  bool isOffline = false;
  ValueNotifier<Map<String, String>> downloaded =
      ValueNotifier(LinkedHashMap());
  late Participant _participant;
  late LinkedHashMap<String, Stream<FileResponse>> streams;
  bool _skipDownloading = false;
  ParticipationProgress? _participationProgress;

  @override
  void initState() {
    super.initState();
    setState(() {
      streams = LinkedHashMap();
      downloaded.value = LinkedHashMap();
      ParticipantData.getSkipDownloading().then((skip) {
        print("Skip initial downloading is: " + skip.toString());
        _skipDownloading = skip;
      });
      downloaded.addListener(() async {
        if (_skipDownloading || downloaded.value.length == _videos.length) {
          await ParticipantData.setSkipDownloading(true);
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(
                        participant: _participant,
                        weekNumber: _participationProgress!.currentWeek,
                        videoSet: widget.videoSet,
                        participationProgress: _participationProgress,
                        participationProgressId: _participationProgress!
                            .fitnessParticipationProgessId)),
                (route) => false);
          }
        } else {
          print('Not all videos have been downloaded yet');
        }
      });
    });
    //hack to refresh/rebuild progress bars
    if (RespectHealthApp.initError != '') {
      Timer(Duration(seconds: 4), () {
        _refresh();
      });
    }
  }

  _initDownloadService() async {
    var participant = await ParticipantData.load();
    _participant = await Participant.fromPrefs();
    //_participant.purgeCache = participant['purge_cache'] as bool;  //not used anymore, remove from backend, we changed how things are cached.
    widget.videoSet =
        FitnessVideoSet.fromJson(participant['fitness_video_sets']);
    _participationProgress = ParticipationProgress.fromJson(
        participant['fitness_participation_progress']);
    if (isOffline) {
      _videos = Video.fromList(participant['videos'])
          .where((vid) => vid.weekNumber == "1")
          .toList();
    } else {
      _videos = await VideosBackgroundCacher(["1"]).getVideos() as List<Video>;
    }
    if (_skipDownloading) {
      for (var vid in _videos) {
        _addToDownloaded(vid);
      }
    }
    for (var vid in _videos) {
      vid.fitnessVideoSet = widget.videoSet;
      _downloadVideo(vid);
    }
  }

  void _downloadVideo(Video video) async {
    var cacheManager = RespectHealthCacheManager.instance; //cache is signleton
    final fileInfo = await cacheManager.getFileFromCache(video.videoUrl);
    if (fileInfo == null) {
      //no file in the cache. Add it to download
      streams[video.videoId] = cacheManager
          .getFileStream(video.videoUrl, withProgress: true)
          .asBroadcastStream();
      var stream = streams[video.videoId] as Stream<FileResponse>;
      stream.listen((value) {
        if (value is FileInfo) {
          _addToDownloaded(video);
        }
      });
    } else {
      _addToDownloaded(video); // its there already. add it to downloaded map
    }
  }

  bool _isDownloaded(Video video) {
    return downloaded.value.values
        .contains(video.videoId); // we have a video id in the set
  }

  void _addToDownloaded(Video video) {
    downloaded.value[video.videoId] = video.videoId;
    downloaded.notifyListeners(); //notify about the change
  }

  @override
  Widget build(BuildContext context) {
    CurrentScreen.value = 'Download';
    return _fututreWidget(context);
  }

  void _refresh() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => this.build(context)));
  }

  Widget _buildList() {
    return Ink(
        color: Colors.grey[100],
        child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _videos.length,
            itemBuilder: (context, int index) {
              var video = _videos[index];
              return Card(
                  child: ListTile(
                      dense: false,
                      subtitle: SizedBox(
                          width: 500,
                          height: 100,
                          child: _isDownloaded(video)
                              ? Icon(Icons.check_circle,
                                  color: Colors.greenAccent, size: 50)
                              : VideoDownloadStatus(
                                  fileStream: streams[video.videoId])),
                      title: Text(
                          "${video.videoTitle.toString()} - ${video.videoUrl}"),
                      leading: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: video.thumbnailUrl.startsWith('https')
                                ? Image(
                                    image: NetworkImage(video.thumbnailUrl),
                                    width: 100,
                                    height: 100)
                                : Icon(Icons.movie, size: 100),
                          ))));
            }));
  }

  //wrap api call in a widget with states. Will call ConnectionState.done bit when api responded successfully
  Widget _fututreWidget(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _initDownloadService(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Center(
                          child: const SpinKitPumpingHeart(
                              color: Color(0x0FDCD0), size: 100)));
                case ConnectionState.done:
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                        child: Row(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              width: 600,
                              child:
                                  Text('Caching all videos. Please be patient'),
                            ),
                          )
                        ]),
                      ),
                      Expanded(
                        child: _buildList(),
                      ),
                    ],
                  );
              }
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
