import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Definindo os tipos de animação disponíveis
enum AnimationType { fade, scale, rotate, fadeRebound }

// Widget personalizado que aplica animações com base no tipo especificado
class CustomAnimatedWidget extends StatefulWidget {
  final Widget child;
  final AnimationType animationType;
  final RxBool animate; // Variável observável passada como argumento

  const CustomAnimatedWidget({
    required this.child,
    required this.animationType,
    required this.animate,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomAnimatedWidget> createState() => _CustomAnimatedWidgetState();
}

class _CustomAnimatedWidgetState extends State<CustomAnimatedWidget> {
  late Widget currentChild;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    currentChild = widget.child;

    if (widget.animationType == AnimationType.fadeRebound) {
      widget.animate.listen((_) {
        _startFadeRebound();
      });
    }
  }

  _startFadeRebound() {
    setState(() => opacity = 0.0);
    Future.delayed(const Duration(milliseconds: 150)).then((value) {
      setState(() {
        opacity = 1.0;
        currentChild = widget.child;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationType == AnimationType.fadeRebound) {
      return AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 150),
        child: currentChild,
      );
    }

    return Obx(() {
      switch (widget.animationType) {
        case AnimationType.fade:
          return AnimatedOpacity(
            opacity: widget.animate.value ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: widget.child,
          );
        case AnimationType.scale:
          return AnimatedScale(
            scale: widget.animate.value ? 1.0 : 0.5,
            duration: const Duration(seconds: 1),
            child: widget.child,
          );
        case AnimationType.rotate:
          return AnimatedRotation(
            turns: widget.animate.value ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: widget.child,
          );
        default:
          return widget.child;
      }
    });
  }
}
