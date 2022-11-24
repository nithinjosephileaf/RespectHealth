import 'package:flutter/material.dart';
import 'package:respect_health/utils/color_utils.dart';
import 'package:respect_health/widgets/video_list/random_thumb.dart';

class Sections extends StatefulWidget {
  final Widget child;
  final double widthFull;
  final String thumbnail;
  final bool disabled;
  bool viewed = false;
  Sections(
      {required this.child,
      required this.widthFull,
      required this.thumbnail,
      required this.disabled,
      required this.viewed});

  @override
  State<StatefulWidget> createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: RandomThumb().image(context), // async work
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return CircularProgressIndicator();
              else
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 1.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: (widget.widthFull) / 1.8,
                      height: 170.0,
                      foregroundDecoration: widget.disabled
                          ? null
                          : (widget.viewed
                              ? BoxDecoration(
                                  color: ColorUtils.viewed,
                                  backgroundBlendMode: BlendMode.modulate)
                              : null),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: ColorUtils.disabled,
                          image: DecorationImage(
                              image: _image(snapshot.data),
                              colorFilter: widget.disabled
                                  ? ColorFilter.mode(
                                      Colors.grey.withOpacity(0.2),
                                      BlendMode.modulate)
                                  : null,
                              fit: BoxFit.cover)),
                      child: widget.child,
                    ),
                  ),
                );
          }
        });
  }

  _image(img) {
    if (!widget.thumbnail.startsWith('https')) {
      return AssetImage('images/unsplash2.png');
    } else {
      if (widget.disabled) {
        return NetworkImage(widget.thumbnail);
      } else if (!widget.disabled && widget.viewed) {
        return NetworkImage(widget.thumbnail);
      } else {
        return NetworkImage(widget.thumbnail);
      }
    }
  }
}
