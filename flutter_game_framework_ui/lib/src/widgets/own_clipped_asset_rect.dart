import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget to display a part of an asset (such as a card or event icon) using
/// a clipped rectangle.
/// The default values should be used for standard cards.
class OwnClippedAssetRect extends StatelessWidget {
  /// Creates an [OwnClippedAssetRect].
  const OwnClippedAssetRect({
    super.key,
    required this.imagePath,
    this.heightFactor = 0.6,
    this.scale = 1.3,
    this.cornerRadius = 8,
  });

  /// The path to the asset to display.
  final String imagePath;

  /// The height factor of the image.
  final double heightFactor;

  /// The scale of the image.
  final double scale;

  /// The corner radius of the image.
  final double cornerRadius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cornerRadius),
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: heightFactor,
            child: Transform.scale(
              scale: scale,
              child: Image.asset(imagePath),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('imagePath', imagePath))
      ..add(DoubleProperty('heightFactor', heightFactor))
      ..add(DoubleProperty('scale', scale))
      ..add(DoubleProperty('cornerRadius', cornerRadius));
  }
}
