import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yust/yust.dart';
import 'package:yust_ui/yust_ui.dart';

import '../initialization.dart';

/// A base game screen that handles [YustDocBuilder] setup, game state
/// dispatch, and optional debug state-change buttons.
///
/// Subclasses implement [buildForState] to return the appropriate display
/// widget for each game state, and optionally override [onDebugStateChange]
/// for debug button behavior.
abstract class GameScreenBase<G extends Game> extends ConsumerStatefulWidget {
  /// Creates a [GameScreenBase].
  const GameScreenBase({super.key, required this.gameId});

  /// The ID of the game document to load.
  final String gameId;
}

/// Base state for [GameScreenBase].
abstract class GameScreenBaseState<G extends Game, W extends GameScreenBase<G>>
    extends ConsumerState<W> {
  /// The last loaded game instance, available for debug buttons.
  late G latestGame;

  /// Returns the widget to display for the given game and its current state.
  Widget buildForState(BuildContext context, G game);

  /// Called when a debug state-change button is pressed.
  /// Override to add game-specific reset logic.
  Future<void> onDebugStateChange(G game, GameState newState) async {
    game.gameState = newState;
    await game.save();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      backgroundColor: Colors.black26,
      foregroundColor: Colors.white,
      actions: noAuth ? buildDebugActions() : null,
    ),
    body: YustDocBuilder<G>(
      modelSetup: gameSetup as YustDocSetup<G>,
      id: widget.gameId,
      builder: (game, insights, context) {
        if (game == null) {
          return const Center(child: CircularProgressIndicator());
        }
        latestGame = game;
        return buildForState(context, game);
      },
    ),
  );

  /// Builds the debug action buttons shown in the app bar when [noAuth] is
  /// true. Override to provide game-specific debug state buttons.
  List<Widget> buildDebugActions() => GameState.values
      .map(
        (state) => IconButton(
          icon: Icon(
            IconData(state.iconCodePoint, fontFamily: 'MaterialIcons'),
          ),
          tooltip: state.name,
          onPressed: () => onDebugStateChange(latestGame, state),
        ),
      )
      .toList();
}
