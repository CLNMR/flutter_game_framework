import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';

import '../util/context_extension.dart';

/// The standard button
class OwnButton extends StatelessWidget {
  /// Creates a [OwnButton].
  const OwnButton({
    super.key,
    required this.text,
    this.trObject,
    this.icon,
    this.navigation = false,
    this.onPressed,
    this.warning = false,
    this.translate = true,
  });

  /// The text of the button.
  final String text;

  /// The translation object for more complex translations.
  final TrObject? trObject;

  /// The icon of the button.
  final IconData? icon;

  /// Whether the button should display a navigation icon.
  final bool navigation;

  /// Whether the button should be light red.
  final bool warning;

  /// The function to call when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button should translate its text.
  final bool translate;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        child: SizedBox(
          width: 200,
          height: 60,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) Icon(icon),
                Expanded(
                  child: Center(
                    child: Text(
                      translate
                          ? trObject == null
                              ? context.tr('BUT:$text')
                              : context.trFromObject(trObject!)
                          : text,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('text', text))
      ..add(DiagnosticsProperty<bool>('navigation', navigation))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(DiagnosticsProperty<bool>('warning', warning))
      ..add(DiagnosticsProperty<TrObject?>('trObject', trObject))
      ..add(DiagnosticsProperty<bool>('translate', translate));
  }
}
