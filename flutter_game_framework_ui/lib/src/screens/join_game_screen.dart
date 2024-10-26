import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';
import 'package:yust_ui/yust_ui.dart';

import '../initialization.dart';
import '../util/widget_ref_extension.dart';
import '../codegen/annotations/screen.dart';
import '../util/game_id_formatter.dart';
import '../widgets/game_button.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import '../widgets/own_text_field.dart';

/// A screen to join a game waiting for more players.
@Screen()
class JoinGameScreen extends ConsumerStatefulWidget {
  /// Creates a [JoinGameScreen].
  const JoinGameScreen({super.key});

  @override
  ConsumerState<JoinGameScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<JoinGameScreen> {
  final _gameIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const OwnText(text: 'HEAD:joinGame', type: OwnTextType.title),
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(child: _buildGameList(context)),
              const SizedBox(height: 20),
              _buildJoinPrivateGameButton(context),
            ],
          ),
        ),
      );

  Widget _buildJoinPrivateGameButton(BuildContext context) => SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'GameID',
                hintText: 'XXX-XXX-XXX',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
              controller: _gameIdController,
              inputFormatters: [GameIdInputFormatter()],
            ),
            const SizedBox(height: 8),
            OwnTextField(
              label: 'joinGamePassword',
              controller: _passwordController,
            ),
            const SizedBox(height: 8),
            OwnButton(text: 'JoinGame', onPressed: _joinPrivateGame),
          ],
        ),
      );
  Future<void> _joinPrivateGame() async {
    final gameId = _gameIdController.text;
    final password = _passwordController.text;
    final router = GoRouter.of(context);
    try {
      final game = await Yust.databaseService.getFirst<Game>(
        gameSetup,
        filters: [
          YustFilter(
            field: 'gameId',
            comparator: YustFilterComparator.equal,
            value: gameId,
          ),
          YustFilter(
            field: 'password',
            comparator: YustFilterComparator.equal,
            value: password,
          ),
        ],
      );
      if (game == null) {
        throw Exception('Game not found');
      }
      if (!game.allowSpectators && game.arePlayersComplete) {
        // await YustUi.alertService.showAlert(
        //   'Game full',
        //   // ignore: lines_longer_than_80_chars
        //   "You can't join this game as it's full and doesn't allow spectators.",
        // );
        return;
      }
      await game.tryAddUser(ref.user!);
      await router.pushNamed('/game', pathParameters: {'gameId': gameId});
    } catch (e) {
      // await YustUi.alertService
      //     .showAlert('Game not found or password incorrect', '');
      return;
    }
  }

  Widget _buildGameList(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(3),
        ),
        child: YustDocsBuilder<Game>(
          // TODO: Build properly with a dynamically loading list
          modelSetup: gameSetup,
          builder: (g, _, __) {
            final games = g
                .where(
                  (doc) =>
                      !doc.players.any((player) => player.id == ref.user!.id) &&
                      doc.playerNum != doc.players.length,
                )
                .toList();
            if (games.isEmpty) {
              return const Center(
                child: OwnText(text: 'JOINGAME:noGamesFound'),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) => GameButton(game: games[index]),
              itemCount: games.length,
            );
          },
          orderBy: [YustOrderBy(field: 'modifiedAt', descending: true)],
          filters: [
            YustFilter(
              field: 'gameState',
              comparator: YustFilterComparator.equal,
              value: GameState.waitingForPlayers.toJson(),
            ),
            YustFilter(
              field: 'public',
              comparator: YustFilterComparator.equal,
              value: true,
            ),
          ],
          showLoadingSpinner: true,
        ),
      );
}
