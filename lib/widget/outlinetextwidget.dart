import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';

class OutlineText extends StatelessWidget {
  final ExtendedText child;
  final double strokeWidth;
  final Color? strokeColor;
  final TextOverflow? overflow;

  const OutlineText(
    this.child, {
    super.key,
    this.strokeWidth = 2,
    this.strokeColor,
    this.overflow,
  });


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          child.textSpan?.toPlainText() ?? "",
          style: TextStyle(
            fontSize: child.style?.fontSize,
            fontWeight: child.style?.fontWeight,
            foreground: Paint()
              ..color = strokeColor ?? Theme.of(context).shadowColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth,
          ),
          overflow: overflow,
        ),
        child
      ],
    );
  }
}
