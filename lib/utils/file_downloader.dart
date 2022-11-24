import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class VideoDownloader {
  final String url;
  final String videoId;
  VideoDownloader(this.url, this.videoId);

  Future<Response<dynamic>?> call() async {
    try {
      var savePath = await filePath();
      print("Saving in $savePath");
      return await Dio().download(url, savePath);
    } on DioError catch (e) {
      print(e.message);
      print("Could not download video: $videoId");
      return null;
    } on Error catch (ex) {
      print(ex.toString());
      print("Could not download video: $videoId");
      return null;
    }
  }

  Future<String> filePath() async {
    final tempDir = await getTemporaryDirectory();
    return "${tempDir.path}/$videoId.mp4";
  }

  Future<bool> isDownloaded() async {
    var path = await filePath();
    return await File(path).exists();
  }

  Future<int> deleteFile() async {
    try {
      String path = await filePath();
      final file = File(path);

      await file.delete();
    } catch (e) {
      return 0;
    }
    return 0;
  }
}
