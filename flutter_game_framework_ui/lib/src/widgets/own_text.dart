import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';

import '../util/context_extension.dart';

/// The type of a text.
enum OwnTextType {
  /// A title text.
  title(20),

  /// A subtitle text.
  subtitle(18),

  /// A body text.
  body(12),

  /// A small text.
  small(8);

  const OwnTextType(this.fontsize);

  /// The text size.
  final int fontsize;
}

/// A text field.
class OwnText extends StatelessWidget {
  /// Creates a [OwnText].
  const OwnText({
    super.key,
    this.text,
    this.type = OwnTextType.body,
    this.style,
    this.align,
    this.translate = true,
    this.trObject,
    this.trObjects,
    this.ellipsis = false,
  });

  /// The text to display.
  final String? text;

  /// The type of the text.
  final OwnTextType type;

  /// The style of the text.
  final TextStyle? style;

  /// Whether to translate the text.
  final bool translate;

  /// How the text should be aligned horizontally.
  final TextAlign? align;

  /// The translation object for more complex translations.
  /// If this is set, [text] is ignored.
  /// Only one of [trObject] and [trObjects] should be set.
  final TrObject? trObject;

  /// The translation objects for more complex translations.
  /// If this is set, [text] is ignored.
  final List<TrObject>? trObjects;

  /// Whether to add an ellipsis to the text.
  final bool ellipsis;

  @override
  Widget build(BuildContext context) {
    final listOfTrObjects = trObjects ?? [];
    if (trObject != null) listOfTrObjects.add(trObject!);
    return Text(
      translate
          ? listOfTrObjects.isEmpty
              ? context.tr(text ?? '')
              : listOfTrObjects.map(context.trFromObject).join('\n')
          : text ?? '',
      textAlign: align,
      style: style ??
          TextStyle(
            color: Colors.black,
            fontSize: type.fontsize.toDouble(),
          ),
      overflow: TextOverflow.fade,
      maxLines: ellipsis ? 1 : null,
      softWrap: true,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('text', text))
      ..add(EnumProperty<OwnTextType>('type', type))
      ..add(DiagnosticsProperty<TextStyle?>('style', style))
      ..add(DiagnosticsProperty<bool>('translate', translate))
      ..add(DiagnosticsProperty<TrObject?>('trObject', trObject))
      ..add(IterableProperty<TrObject>('trObjects', trObjects))
      ..add(DiagnosticsProperty<bool>('ellipsis', ellipsis))
      ..add(EnumProperty<TextAlign?>('align', align));
  }
}
