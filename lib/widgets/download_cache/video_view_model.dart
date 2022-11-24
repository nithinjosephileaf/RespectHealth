import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:respect_health/utils/color_utils.dart';
import 'package:respect_health/widgets/download_cache/file_progress.dart';

class VideoDownloadStatus extends StatefulWidget {
  Stream<FileResponse>? fileStream;

  VideoDownloadStatus({
    Key? key,
    required this.fileStream,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoViewModelState();
}

class _VideoViewModelState extends State<VideoDownloadStatus> {
  @override
  Widget build(BuildContext context) {
    Widget body;
    return StreamBuilder<FileResponse>(
      stream: widget.fileStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (snapshot.data != null) {
              var progress = snapshot.data as DownloadProgress;
              body = FileProgress.callLinear(context, progress.progress);
              return body;
            } else {
              body = Icon(Icons.hourglass_bottom_rounded,
                  color: ColorUtils.purple, size: 50);
              return body;
            }
          case ConnectionState.none:
            if (snapshot.hasData) {
              var progress = snapshot.data as DownloadProgress;
              body = FileProgress.callLinear(context, progress.progress);
              return body;
            } else {
              body = Icon(Icons.hourglass_bottom_rounded,
                  color: ColorUtils.purple, size: 50);
              return body;
            }

          case ConnectionState.done:
            body =
                Icon(Icons.check_circle, color: ColorUtils.teal, size: 50);
            return body;
        }
      },
    );
  }
}
