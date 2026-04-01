import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/widget_ref_extension.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import '../widgets/player_icon.dart';

/// A base waiting/lobby display for games.
///
/// Shows game ID, player list with icons, a start button for the owner,
/// and an optional dev "add player" button. Subclasses can provide
/// additional game info via [buildGameSpecificInfo].
class WaitingDisplayBase extends ConsumerWidget {
  /// Creates a [WaitingDisplayBase].
  const WaitingDisplayBase({
    super.key,
    required this.game,
    this.onStart,
    this.decoration,
    this.buildGameSpecificInfo,
    this.onAddDevPlayer,
  });

  /// The current game.
  final Game game;

  /// Called when the start button is pressed. If null, calls [game.start()].
  final VoidCallback? onStart;

  /// Decoration for the game info container.
  final Decoration? decoration;

  /// Builds additional game-specific info below the player list.
  final Widget Function(BuildContext context)? buildGameSpecificInfo;

  /// Called to add a dev/bot player (shown only in noAuth mode).
  final VoidCallback? onAddDevPlayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.user;
    final isOwner = game.isUserOwner(user);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGameInfoBox(context),
            const SizedBox(height: 20),
            if (isOwner && game.arePlayersComplete)
              OwnButton(
                text: 'StartGame',
                onPressed: onStart ?? game.start,
              ),
            if (isOwner && !game.arePlayersComplete)
              OwnText(
                text: game.public
                    ? 'promptOwnerToStart'
                    : 'promptOwnerToStartWithoutShuffle',
              ),
            if (!isOwner)
              OwnText(
                trObject: TrObject(
                  'waitingForPlayers',
                  namedArgs: {
                    'number': (game.playerNum - game.players.length).toString(),
                    'gameId': game.gameId.toString(),
                  },
                ),
              ),
            if (noAuth && onAddDevPlayer != null) ...[
              const SizedBox(height: 16),
              OwnButton(
                text: 'Add Player',
                translate: false,
                onPressed: onAddDevPlayer,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfoBox(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: decoration ??
            BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OwnText(text: 'gameIdHeader'.tr()),
                SelectableText(
                  game.gameId.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPlayerList(),
            if (buildGameSpecificInfo != null) ...[
              const SizedBox(height: 12),
              buildGameSpecificInfo!(context),
            ],
          ],
        ),
      );

  Widget _buildPlayerList() => Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OwnText(text: 'playersHeader'.tr()),
              Text(
                '${game.players.length} / ${game.playerNum}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              game.players.length,
              (index) => _buildPlayerChip(index),
            ),
          ),
        ],
      );

  Widget _buildPlayerChip(int index) {
    final player = game.players[index];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlayerIcon(index: index),
          const SizedBox(width: 4),
          Text(player.displayName),
        ],
      ),
    );
  }
}
