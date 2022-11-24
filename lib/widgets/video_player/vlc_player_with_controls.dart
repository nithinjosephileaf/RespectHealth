
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'controls_overlay.dart';


class VlcPlayerWithControls extends StatefulWidget {
  final VlcPlayerController controller;
  final bool showControls;

  VlcPlayerWithControls({
    Key? key,
    required this.controller,
    this.showControls = true,
  })  : super(key: key);

  @override
  VlcPlayerWithControlsState createState() => VlcPlayerWithControlsState();
}

class VlcPlayerWithControlsState extends State<VlcPlayerWithControls>
    with AutomaticKeepAliveClientMixin {
  static const _playerControlsBgColor = Colors.blue;

  late VlcPlayerController _controller;

  //
  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;
  OverlayEntry? _overlayEntry;

  //
  double sliderValue = 0.0;
  double volumeValue = 50;
  String position = '';
  String duration = '';
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;
  bool validPosition = false;

  double recordingTextOpacity = 0;
  DateTime lastRecordingShowTime = DateTime.now();
  bool isRecording = false;

  //
  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose(); 
    _controller.removeListener(listener);
    _controller.stopRendererScanning().then((_) {
      _controller.dispose().then((_) {
        
      });
    });
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_controller.value.isInitialized) {
      var oPosition = _controller.value.position;
      var oDuration = _controller.value.duration;
      if (oPosition.inSeconds == oDuration.inSeconds) {

      }
      if (oDuration.inHours == 0) {
        var strPosition = oPosition.toString().split('.')[0];
        var strDuration = oDuration.toString().split('.')[0];
        position =
            "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
        duration =
            "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
      } else {
        position = oPosition.toString().split('.')[0];
        duration = oDuration.toString().split('.')[0];
      }
      validPosition = oDuration.compareTo(oPosition) >= 0;
      sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      numberOfCaptions = _controller.value.spuTracksCount;
      numberOfAudioTracks = _controller.value.audioTracksCount;
      // update recording blink widget
      if (_controller.value.isRecording && _controller.value.isPlaying) {
        if (DateTime.now().difference(lastRecordingShowTime).inSeconds >= 1) {
          lastRecordingShowTime = DateTime.now();
          recordingTextOpacity = 1 - recordingTextOpacity;
        }
      } else {
        recordingTextOpacity = 0;
      }
      // check for change in recording state
     
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        Expanded(
          child: Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Center(
                  child: VlcPlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                    placeholder: Center(child: CircularProgressIndicator()),
                  ),
                ),
                ControlsOverlay(key: ValueKey('VideoPlayer'), controller: _controller),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.showControls,
          child: Container(
            color: _playerControlsBgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.white,
                  iconSize: 40,
                  icon: _controller.value.isPlaying
                      ? Icon(Icons.pause_circle_outline)
                      : Icon(Icons.play_circle_outline),
                  onPressed: _togglePlaying,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        position,
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      Text(' - ',style: TextStyle(color: Colors.white, fontSize: 40)),
                      
                      Text(
                        duration,
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        /*Visibility(
          visible: widget.showControls,
          child: Container(
            color: _playerControlsBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.volume_down,
                  size: 40,
                  color: Colors.white,
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 100,
                    value: volumeValue,
                    activeColor: Colors.white,
                    onChanged: _setSoundVolume,
                  ),
                ),
                Icon(
                  Icons.volume_up,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),*/
      ],
    );
  }
  

  void _setSoundVolume(value) {
    setState(() {
      volumeValue = value;
    });
    _controller.setVolume(volumeValue.toInt());
  }

  void _togglePlaying() async {
    _controller.value.isPlaying
        ? await _controller.pause()
        : await _controller.play();
  }


  
}