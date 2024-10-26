import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A text field.
class OwnTextField extends StatelessWidget {
  /// Creates a [OwnTextField].
  OwnTextField({
    super.key,
    this.placeholder,
    TextEditingController? controller,
    this.onChanged,
    this.onEditingComplete,
    String? initialText,
    this.label = '',
    this.obscureText = false,
    this.autocorrect = true,
    this.translateLabel = true,
    this.keyboardType,
    this.style,
  }) : controller = controller ?? TextEditingController(text: initialText);

  /// The placeholder text.
  final String? placeholder;

  /// The controller for the text field.
  final TextEditingController controller;

  /// The callback when the text is changed.
  final Function(String text)? onChanged;

  /// The Callback when the text is submitted.
  final Function()? onEditingComplete;

  /// The label of the text field.
  final String label;

  /// Whether the text should be obscured.
  final bool obscureText;

  /// Whether the text should be autocorrected.
  final bool autocorrect;

  /// Whether the label should be translated.
  final bool translateLabel;

  /// The type of keyboard to use.
  final TextInputType? keyboardType;

  /// The style of the text.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          label: Text(
            translateLabel ? context.tr('TEXTFIELDLABEL:$label') : label,
          ),
        ),
        style: style ?? const TextStyle(color: Colors.black),
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
        onEditingComplete: onEditingComplete,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('placeholder', placeholder))
      ..add(
        DiagnosticsProperty<TextEditingController?>('controller', controller),
      )
      ..add(
        ObjectFlagProperty<Function(String text)?>.has('onChanged', onChanged),
      )
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('obscureText', obscureText))
      ..add(DiagnosticsProperty<bool>('autocorrect', autocorrect))
      ..add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType))
      ..add(
        ObjectFlagProperty<Function()?>.has(
          'onEditingComplete',
          onEditingComplete,
        ),
      )
      ..add(DiagnosticsProperty<bool>('translateLabel', translateLabel))
      ..add(DiagnosticsProperty<TextStyle?>('style', style));
  }
}
