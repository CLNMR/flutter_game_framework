import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yust/yust.dart';
import 'package:yust_ui/yust_ui.dart';

import '../initialization.dart';
import '../util/widget_ref_extension.dart';
import '../codegen/annotations/screen.dart';
import '../widgets/game_button.dart';
import '../widgets/own_text.dart';

/// A screen to resume a joined game.
@Screen()
class GameListScreen extends ConsumerStatefulWidget {
  /// Creates a [GameListScreen].
  const GameListScreen({super.key});

  @override
  ConsumerState<GameListScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<GameListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const OwnText(
            text: 'HEAD:gameList',
            type: OwnTextType.title,
          ),
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                ..._buildListOfGames(
                  'CurrentGames',
                  GameState.values
                      .where((state) => state != GameState.finished)
                      .toList(),
                ),
                ..._buildListOfGames(
                  'ArchivedGames',
                  [GameState.finished],
                ),
              ],
            ),
          ),
        ),
      );

  List<Widget> _buildListOfGames(String title, List<GameState> gameStates) => [
        OwnText(
          text: title,
          type: OwnTextType.subtitle,
        ),
        Expanded(
          child: YustDocsBuilder<Game>(
            limit: 10,
            // TODO: Build properly with a dynamically loading list
            modelSetup: gameSetup,
            showLoadingSpinner: true,
            builder: (games, _, __) => ListView.builder(
              itemBuilder: (context, index) => GameButton(game: games[index]),
              itemCount: games.length,
            ),
            filters: [
              YustFilter(
                field: 'playerNames',
                comparator: YustFilterComparator.arrayContains,
                value: Player.fromUser(ref.user!).id,
              ),
              YustFilter(
                field: 'gameState',
                comparator: YustFilterComparator.inList,
                value: gameStates.map((state) => state.toJson()).toList(),
              ),
            ],
            // LATER: Refine orderBy
            orderBy: [
              YustOrderBy(field: 'gameState', descending: false),
              YustOrderBy(field: 'modifiedAt', descending: true),
            ],
          ),
        ),
      ];
}
