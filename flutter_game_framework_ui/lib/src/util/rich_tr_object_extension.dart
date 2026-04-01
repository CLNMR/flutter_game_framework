import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';

/// Adds utility to display enriched text.
extension UiRichTrObject on RichTrObject {
  /// Returns a [InlineSpan] that represents the rich translation object.
  InlineSpan getEnrichedSpan(BuildContext context, List<String> playerNames) {
    switch (trType) {
      case RichTrType.player:
        final index = value as int;
        return _getPlayerSpan(playerNames[index], index);
      case RichTrType.number:
        return TextSpan(
          text: value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      case RichTrType.numberWithOperator:
        final val = value as int;
        return TextSpan(
          text: val > 0 ? '+ $val' : '- ${val.abs()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      case RichTrType.playerList:
        return _getSpanForList(value, RichTrType.player, context, playerNames);
      default:
        return TextSpan(
          text: value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
    }
  }

  /// Retrieve the TextSpan for a list of values of the same type.
  TextSpan _getSpanForList(
    List<dynamic> values,
    RichTrType singularType,
    BuildContext context,
    List<String> playerNames,
  ) {
    if (values.isEmpty) return const TextSpan();
    final spans = values
        .map(
          (val) => RichTrObject(singularType, value: val)
              .getEnrichedSpan(context, playerNames),
        )
        .expand((span) => [span, const TextSpan(text: ', ')])
        .toList()
      ..removeLast();

    if (spans.length > 1) {
      spans[spans.length - 2] = TextSpan(text: 'connectiveAnd'.tr());
    }
    return TextSpan(
      children: spans,
    );
  }

  InlineSpan _getPlayerSpan(String playerName, int factionIndex) => TextSpan(
        text: playerName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
}
