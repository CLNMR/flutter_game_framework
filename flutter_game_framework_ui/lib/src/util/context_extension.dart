import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_gen/gen_l10n/game_framework_localizations.dart';
import 'rich_tr_object_extension.dart';
import '../initialization.dart';
import 'package:flutter/widgets.dart' show BuildContext;

/// An extension for [BuildContext].
extension BuildContextExtension on BuildContext {
  /// Whether the app is run in dark mode or not.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Translates a [TrObject] to a string.
  String trFromObject(TrObject trObject) {
    final translatedNamedArgs = trObject.namedArgsTrObjects?.map(
      (key, value) => MapEntry(key, trFromObject(value)),
    );
    return loc.tr(
      trObject.text,
      args: trObject.args,
      namedArgs: {}
        ..addAll(trObject.namedArgs ?? {})
        ..addAll(translatedNamedArgs ?? {}),
      gender: trObject.gender,
    );
  }

  /// Translates a [TrObject] to a stylized [TextSpan].
  TextSpan trFromObjectToTextSpan(TrObject trObject, List<String> playerNames) {
    final translation = trFromObject(trObject);
    final spans = getSpans?.call(trObject) ?? <InlineSpan>[];
    if (trObject.richTrObjects == null || trObject.richTrObjects!.isEmpty) {
      return TextSpan(children: spans..add(TextSpan(text: translation)));
    }
    final richMap =
        Map.fromEntries(trObject.richTrObjects!.map((e) => MapEntry(e.key, e)));
    // Search for all remaining named arguments in the translated text, and
    // replace them manually with the corresponding TextSpan.
    final exp = RegExp(r'\{(.+?)\}');
    translation.splitMapJoin(
      exp,
      onMatch: (m) {
        final key = m.group(1);
        if (key != null && richMap.containsKey(key)) {
          spans.add(
            richMap[key]!.getEnrichedSpan(this, playerNames),
          );
        }
        return '';
      },
      onNonMatch: (m) {
        spans.add(
          TextSpan(
            text: m,
          ),
        );
        return '';
      },
    );
    return TextSpan(children: spans);
  }
}

  

class MissingFlutterQuillLocalizationException extends UnimplementedError {
  MissingFlutterQuillLocalizationException();
  @override
  String? get message =>
      '$AppLocalizations instance is required and could not found.\n'
      'Add the delegate `AppLocalizations.delegate` to your widget app (e.g., MaterialApp) to fix.\n'
      'If the issue continues, consider reporting a bug.\n'
      'See https://github.com/singerdmx/flutter-quill/blob/master/doc/translation.md';
}

extension LocalizationsExt on BuildContext {
  /// Require the [AppLocalizations] instance.
  ///
  /// `loc` is short for `localizations`
  AppLocalizations get loc {
    return AppLocalizations.of(this) ??
        (throw MissingFlutterQuillLocalizationException());
  }
}


