// Flutter code sample for InheritedNotifier

// This example shows three spinning squares that use the value of the notifier
// on an ancestor [InheritedNotifier] (`SpinModel`) to give them their
// rotation. The [InheritedNotifier] doesn't need to know about the children,
// and the `notifier` argument doesn't need to be an animation controller, it
// can be anything that implements [Listenable] (like a [ChangeNotifier]).
//
// The `SpinModel` class could just as easily listen to another object (say, a
// separate object that keeps the value of an input or data model value) that
// is a [Listenable], and get the value from that. The descendants also don't
// need to have an instance of the [InheritedNotifier] in order to use it, they
// just need to know that there is one in their ancestry. This can help with
// decoupling widgets from their models.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpinModel extends InheritedNotifier<AnimationController> {
  SpinModel({
    Key key,
    AnimationController notifier,
    Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static double of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SpinModel>()
        .notifier
        .value;
  }
}

class Spinner extends StatelessWidget {
  final double width;

  const Spinner(this.width);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: SpinModel.of(context) * 2.0 * math.pi,
      child: Container(
        width: width,
        height: 100,
        color: Colors.green,
        child: const Center(
          child: Text('Whe'),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinModel(
      notifier: _controller,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          Spinner(100),
          Spinner(80),
          Spinner(50),
        ],
      ),
    );
  }
}
