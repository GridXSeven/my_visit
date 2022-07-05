import 'package:flutter/material.dart';
import 'package:visits_prod/components/animations/animatied_clip_rect.dart';

class SwitchAnimatedContainer extends StatefulWidget {
  SwitchAnimatedContainer({
    required this.children,
    required this.index,
  });

  final List<Widget> children;
  final int index;

  @override
  _SwitchAnimatedContainerState createState() =>
      _SwitchAnimatedContainerState();
}

class _SwitchAnimatedContainerState extends State<SwitchAnimatedContainer> {
  int? currentItem;
  bool opened = true;

  @override
  Widget build(BuildContext context) {
    print(widget.index);
    if (widget.index != currentItem &&
        currentItem != null &&
        widget.children[currentItem!] != null) {
      setState(() {
        opened = false;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          currentItem = widget.index;
          if (widget.children[currentItem!] != null) {
            opened = true;
          }
        });
      });
    } else if (widget.index != currentItem) {
      setState(() {
        currentItem = widget.index;
        opened = true;
      });
    }
    return AnimatedClipRect(
      open: opened,
      horizontalAnimation: false,
      verticalAnimation: true,
      alignment: Alignment.center,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
      curve: Curves.ease,
      reverseCurve: Curves.ease,
      child: currentItem != null && widget.children[currentItem!] != null
          ? widget.children[currentItem!]
          : Container(),
    );
  }
}
