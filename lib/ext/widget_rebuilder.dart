import 'package:flutter/cupertino.dart';
// force refresh current context and rebuilds widgets tree
class WidgetRebuilder {
  void call(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
}
