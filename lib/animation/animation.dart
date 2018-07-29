import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class CityNameAnimator extends StatefulWidget {
  @override
  _CityAnimatorState createState() => new _CityAnimatorState();
}

class _CityAnimatorState extends State<CityNameAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
