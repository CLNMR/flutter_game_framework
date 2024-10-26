import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../codegen/annotations/screen.dart';
import '../initialization.dart';
import '../util/widget_ref_extension.dart';

import '../widgets/own_button.dart';
import '../widgets/own_switch.dart';
import '../widgets/own_text.dart';
import '../widgets/own_text_field.dart';

/// The home screen of the app.
@Screen()
class NewGameScreen extends ConsumerStatefulWidget {
  /// Creates a [NewGameScreen].
  const NewGameScreen({super.key});

  @override
  ConsumerState<NewGameScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<NewGameScreen> {
  late Game _game;

  @override
  void initState() {
    super.initState();
    _game = createNewGame();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const OwnText(text: 'HEAD:NewGame'),
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OwnText(text: _game.gameId.toString(), translate: false),
                OwnSwitch(
                  firstOptionKey: 'Offline',
                  secondOptionKey: 'Online',
                  secondOption: _game.online,
                  onChange: (value) {
                    setState(() => _game.online = value);
                  },
                ),
                if (_game.online) ...[
                  OwnSwitch(
                    firstOptionKey: 'Private',
                    secondOptionKey: 'Public',
                    secondOption: _game.public,
                    onChange: (value) {
                      setState(() => _game.public = value);
                    },
                  ),
                  if (!_game.public)
                    OwnTextField(
                      label: 'password',
                      initialText: _game.password,
                      onChanged: (value) {
                        setState(() => _game.password = value);
                      },
                    ),
                ],
                OwnButton(
                  text: 'StartGame',
                  onPressed: () async {
                    final router = GoRouter.of(context);
                    _game.init();
                    await _game.tryAddUser(ref.user!);
                    await router.pushNamed(
                      gameScreenRoute.path,
                      pathParameters: {'gameId': _game.id},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
