import 'package:flutter/material.dart';

class AnimatedClipRect extends StatefulWidget {
  const AnimatedClipRect({
    Key? key,
    required this.child,
    required this.open,
    this.horizontalAnimation = true,
    this.verticalAnimation = true,
    this.alignment = Alignment.center,
    this.duration,
    this.reverseDuration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.animationBehavior = AnimationBehavior.normal,
  }) : super(key: key);

  final Widget child;
  final bool open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;

  ///The behavior of the controller when
  ///[AccessibilityFeatures.disableAnimations] is true.
  final AnimationBehavior animationBehavior;

  @override
  _AnimatedClipRectState createState() => _AnimatedClipRectState();
}

class _AnimatedClipRectState extends State<AnimatedClipRect>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: widget.duration ?? const Duration(milliseconds: 200),
        reverseDuration: widget.reverseDuration ??
            (widget.duration ?? const Duration(milliseconds: 200)),
        vsync: this,
        value: widget.open ? 1.0 : 0.0,
        animationBehavior: widget.animationBehavior);
    _animation = Tween(end: 1.0, begin: 0.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve ?? widget.curve,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.open
        ? _animationController!.forward()
        : _animationController!.reverse();
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (_, child) {
          return Align(
            alignment: widget.alignment,
            heightFactor: widget.verticalAnimation ? _animation!.value : 1.0,
            widthFactor: widget.horizontalAnimation ? _animation!.value : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
