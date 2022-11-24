import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';

class RandomThumb {
  Future<List<String>> _initImages(context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    return manifestMap.keys.where((String key) => key.contains('thumb')).toList();
  }

  Future<String> image(context) async {
    List<String> images = await _initImages(context);
    int min = 0;
    int max = images.length - 1;
    var rnd = new Random();
    int r = min + rnd.nextInt(max - 1);
    String img = images[r].toString();
    return img;
  }
}
