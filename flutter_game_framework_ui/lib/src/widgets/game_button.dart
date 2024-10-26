import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../flutter_game_framework_ui.dart';
import '../util/app_gradients.dart';
import '../util/widget_ref_extension.dart';
import 'own_text.dart';
import 'player_icon.dart';

/// A button that displays a summary of a game and leads to the game screen.
class GameButton extends ConsumerWidget {
  /// Creates a [GameButton].
  const GameButton({super.key, required this.game});

  /// The game to display.
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.all(5),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              final goRouter = GoRouter.of(context);
              await game.tryAddUser(ref.user!);
              await goRouter.pushNamed(
                gameScreenRoute.path,
                pathParameters: {'gameId': game.id},
              );
            },
            child: Container(
              height: 40,
              width: 400,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
                gradient: AppGradients.indigoToYellow,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OwnText(text: game.gameId.toString()),
                  const SizedBox(width: 5),
                  OwnText(
                    text: (game.createdAt != null)
                        ? DateFormat('MM-dd HH:mm')
                            .format(game.createdAt!.toLocal())
                        : '',
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: OwnText(
                      text: 'gameButPlayers'.tr() +
                          game.players
                              .map((player) => player.displayName)
                              .join(' - '),
                      translate: false,
                      ellipsis: true,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (game.gameState != GameState.waitingForPlayers) ...[
                    // OwnText(
                    //   trObject: TrObject(
                    //     'RoundDisplay',
                    //     args: [
                    //       game.currentRound.toString(),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(width: 5),
                    // IconWithNumber(
                    //   iconData: Icons.format_list_bulleted,
                    //   displayNum: game.currentSubgame,
                    // ),
                    const OwnText(text: 'gameButConnectiveOf'),
                  ],
                  // IconWithNumber(
                  //   iconData: Icons.numbers,
                  //   displayNum: game.subgameNum,
                  //   tooltip: 'gameButSubgameNum'.tr(),
                  // ),
                  const SizedBox(width: 5),
                  if (game.gameState == GameState.waitingForPlayers) ...[
                    PlayerIcon(
                      index: game.players.length - 1,
                      displayNumber: true,
                    ),
                    const OwnText(text: 'gameButConnectiveOf'),
                  ],
                  PlayerIcon(
                    index: game.playerNum - 1,
                    displayNumber: true,
                    tooltip: 'gameButPlayerNum'.tr(),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
