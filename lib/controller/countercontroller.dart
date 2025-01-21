import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  final int targetNumber;
  final Duration duration;
  final Curve curve;

  late AnimationController _controller;
  late Animation<int> _animation;

  final currentValue = 0.obs;

  CounterController({
    required TickerProvider vsync,
    required this.targetNumber,
    required this.duration,
    this.curve = Curves.linear,
  }) {
    _controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );

    _animation = IntTween(
      begin: 0,
      end: targetNumber,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ))
      ..addListener(() {
        currentValue.value = _animation.value;
      });

    _controller.forward();
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }
}