import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';

import '../initialization.dart';
import '../util/widget_ref_extension.dart';
import '../codegen/annotations/screen.dart';
import '../util/ui_helper.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import 'account_screen.r.dart';
import 'game_list_screen.r.dart';
import 'join_game_screen.r.dart';
import 'new_game_screen.r.dart';
import 'setting_screen.r.dart';

/// The home screen of the app.
@Screen()
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeading(),
                _buildNewGameButton(context),
                _buildJoinGameButton(context),
                _buildResumeGameButton(context),
                _buildSettingButton(context),
                // if (noAuth) _buildResumeTestGameButton(context), TODO
                _buildResumeLastGameButton(context),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeading() => SizedBox(
        height: 100,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: 0,
              child: _buildAvatar(),
            ),
            const OwnText(
              text: 'HEAD:appTitle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  Widget _buildAvatar() {
    final user = ref.user;
    return GestureDetector(
      onTap: _goToAccountScreen(context),
      child: CircleAvatar(
        backgroundColor: (user == null)
            ? Colors.black
            : UIHelper.getColorFromString(user.email),
        child: Text(
          (user == null) ? 'X' : user.firstName.substring(0, 2).toUpperCase(),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  VoidCallback _goToAccountScreen(BuildContext context) =>
      () async => context.push(AccountScreenRouting.path);

  Widget _buildNewGameButton(BuildContext context) => OwnButton(
        text: 'NewGame',
        onPressed: _goToNewGameScreen(context),
      );

  VoidCallback _goToNewGameScreen(BuildContext context) =>
      () async => context.push(NewGameScreenRouting.path);

  Widget _buildJoinGameButton(BuildContext context) => OwnButton(
        text: 'JoinGame',
        onPressed: _goToJoinGameScreen(context),
      );

  VoidCallback _goToJoinGameScreen(BuildContext context) =>
      () async => context.push(JoinGameScreenRouting.path);

  Widget _buildResumeGameButton(BuildContext context) => OwnButton(
        text: 'YourGames',
        onPressed: _goToGameListScreen(context),
      );

  VoidCallback _goToGameListScreen(BuildContext context) =>
      () async => context.push(GameListScreenRouting.path);

  Widget _buildSettingButton(BuildContext context) => OwnButton(
        text: 'Setting',
        onPressed: _goToSettingScreen(context),
      );

  Widget _buildResumeTestGameButton(BuildContext context) => OwnButton(
        text: 'TestGame',
        onPressed: () async =>
            context.push('${gameScreenRoute.path}/3jBRBbwVVMwyYukbQ6UW'),
      );
  Widget _buildResumeLastGameButton(BuildContext context) => OwnButton(
        text: 'LastGame',
        // TODO: Disable if no games by user exist, and debug filters which
        // didn't work.
        onPressed: () async {
          final router = GoRouter.of(context);
          final game = await Yust.databaseService.getFirstFromDB<Game>(
            gameSetup,
            orderBy: [
              YustOrderBy(
                field: 'modifiedAt',
                descending: true,
              ),
            ],
            // filters: [
            //   YustFilter(
            //     field: 'playerNames',
            //     comparator: YustFilterComparator.arrayContains,
            //     value: ref.user!.id,
            //   ),
            //   YustFilter(
            //     field: 'gameState',
            //     comparator: YustFilterComparator.notEqual,
            //     value: GameState.finished.toJson(),
            //   ),
            // ],
          );
          if (game == null) return;
          // print('Opening game: ${game.id}');
          await router.push('${gameScreenRoute.path}/${game.id}');
        },
      );

  VoidCallback _goToSettingScreen(BuildContext context) =>
      () async => context.push(SettingScreenRouting.path);
}
