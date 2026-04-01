import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/gf_router.dart';

/// A Framework to easily create real-time multiplayer board games in Flutter.
class GameFramework extends ConsumerStatefulWidget {
  /// The light theme for the app.
  final ThemeData lightTheme;

  /// The dark theme for the app.
  final ThemeData? darkTheme;

  /// Creates a [GameFramework].
  const GameFramework({super.key, required this.lightTheme, this.darkTheme});

  @override
  ConsumerState<GameFramework> createState() => _GameFrameworkState();
}

class _GameFrameworkState extends ConsumerState<GameFramework> {
  final _router = GFRouter();

  @override
  void initState() {
    super.initState();
    _router.initialize(context, ref);
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: _getBackgroundImage(context),
    child: MaterialApp.router(
      theme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: _router.router,
    ),
  );

  BoxDecoration _getBackgroundImage(BuildContext context) {
    const pathToBackground = 'assets/images/background.png';
    return const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(pathToBackground),
      ),
    );
  }
}
