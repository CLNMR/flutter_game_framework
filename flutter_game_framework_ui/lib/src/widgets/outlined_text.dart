import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget displaying text with an outline.
class OutlinedText extends StatelessWidget {
  /// Creates an [OutlinedText].
  const OutlinedText(
    this.text, {
    super.key,
    this.fontSize = 40,
    this.outlineColor = Colors.black,
    this.fillColor = Colors.white,
    this.strokeWidth = 2,
  });

  /// The text to display.
  final String text;

  /// The size of the text.
  final double fontSize;

  /// The color of the outline.
  final Color outlineColor;

  /// The color of the fill.
  final Color fillColor;

  /// The width of the outline.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          // Outlined text
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = outlineColor,
            ),
          ),
          // Solid text
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: fillColor,
            ),
          ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('text', text))
      ..add(DoubleProperty('fontSize', fontSize))
      ..add(ColorProperty('outlineColor', outlineColor))
      ..add(ColorProperty('fillColor', fillColor))
      ..add(DoubleProperty('strokeWidth', strokeWidth));
  }
}
