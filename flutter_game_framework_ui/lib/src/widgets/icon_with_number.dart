import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'outlined_text.dart';

/// A widget displaying an icon overlayed with a number.
class IconWithNumber extends StatelessWidget {
  /// Creates an [IconWithNumber].
  const IconWithNumber({
    super.key,
    required this.iconData,
    required this.displayNum,
    this.iconSize = 25,
    this.tooltip = '',
  });

  /// The icon to display in the background.
  final IconData iconData;

  /// The number to display in the foreground.
  final int displayNum;

  /// The size of the icon.
  final double iconSize;

  /// The tooltip to display.
  final String tooltip;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip.tr(),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: iconSize,
              ),
              OutlinedText(
                displayNum.toString(),
                fontSize: 14,
                outlineColor: Colors.black,
                fillColor: Colors.white,
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(IntProperty('displayNum', displayNum))
      ..add(DiagnosticsProperty<IconData>('iconData', iconData))
      ..add(StringProperty('tooltip', tooltip));
  }
}
