import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'rich_tr_object_extension.dart';
import '../initialization.dart';

/// An extension for [BuildContext].
extension BuildContextExtension on BuildContext {
  /// Whether the app is run in dark mode or not.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Translates a [TrObject] to a string.
  String trFromObject(TrObject trObject) {
    final translatedNamedArgs = trObject.namedArgsTrObjects?.map(
      (key, value) => MapEntry(key, trFromObject(value)),
    );
    return this.tr(
      trObject.text,
      args: trObject.args,
      namedArgs: {}
        ..addAll(trObject.namedArgs ?? {})
        ..addAll(translatedNamedArgs ?? {}),
      gender: trObject.gender,
    );
  }

  /// Translates a [TrObject] to a stylized [TextSpan].
  ///
  /// Optional [onEnter]/[onExit] callbacks are forwarded to the [enrichSpan]
  /// hook (if set) for interactive spans like coordinate hover highlighting.
  TextSpan trFromObjectToTextSpan(
    TrObject trObject,
    List<String> playerNames, {
    void Function(Object)? onEnter,
    void Function(Object)? onExit,
  }) {
    final translation = trFromObject(trObject);
    final spans = getSpans?.call(this, trObject) ?? <InlineSpan>[];
    if (trObject.richTrObjects == null || trObject.richTrObjects!.isEmpty) {
      return TextSpan(children: spans..add(TextSpan(text: translation)));
    }
    final richMap = Map.fromEntries(
      trObject.richTrObjects!.map((e) => MapEntry(e.key, e)),
    );
    // Search for all remaining named arguments in the translated text, and
    // replace them manually with the corresponding TextSpan.
    final exp = RegExp(r'\{(.+?)\}');
    translation.splitMapJoin(
      exp,
      onMatch: (m) {
        final key = m.group(1);
        if (key != null && richMap.containsKey(key)) {
          final obj = richMap[key]!;
          spans.add(
            enrichSpan?.call(
                  this,
                  obj,
                  playerNames,
                  onEnter: onEnter,
                  onExit: onExit,
                ) ??
                obj.getEnrichedSpan(this, playerNames),
          );
        }
        return '';
      },
      onNonMatch: (m) {
        spans.add(TextSpan(text: m));
        return '';
      },
    );
    return TextSpan(children: spans);
  }
}
