import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/context_extension.dart';
import '../util/widget_ref_extension.dart';

/// Displays the current status/instruction messages for the user.
///
/// Shows up to 3 lines of translated status text from
/// [Game.getStatusMessages]. Background color can indicate whether
/// the user has an action to take.
class PlayerInstructionsRow extends ConsumerWidget {
  /// Creates a [PlayerInstructionsRow].
  const PlayerInstructionsRow({
    super.key,
    required this.game,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
  });

  /// The current game.
  final Game game;

  /// Background color when the user has something to do.
  final Color activeColor;

  /// Background color when the user is waiting.
  final Color inactiveColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = game.getStatusMessages(ref.user);
    final isActive = game.hasStuffToDo(ref.user);

    final spans = <InlineSpan>[];
    for (var i = 0; i < messages.length; i++) {
      spans.add(
        context.trFromObjectToTextSpan(messages[i], game.shortenedPlayerNames),
      );
      if (i < messages.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return Container(
      width: double.infinity,
      color: isActive ? activeColor : inactiveColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 14 * 1.2 * 3,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            children: spans,
          ),
        ),
      ),
    );
  }
}
