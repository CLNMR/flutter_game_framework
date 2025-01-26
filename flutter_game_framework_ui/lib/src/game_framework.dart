import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'design/theme_constants.dart' as theme_constants;
import 'screens/gf_router.dart';

/// A Framework to easily create real-time multiplayer board games in Flutter.
class GameFramework extends ConsumerStatefulWidget {
  final ThemeData? _lightTheme;
  final ThemeData? _darkTheme;

  /// Creates a [GameFramework].
  const GameFramework({super.key, ThemeData? lightTheme, ThemeData? darkTheme})
      : _lightTheme = lightTheme,
        _darkTheme = darkTheme;

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
  Widget build(BuildContext context) => EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        path: 'assets/localizables', // TODO: Pass in to GameFramework
        fallbackLocale: const Locale('en', 'US'),
        child: ProviderScope(
          child: DecoratedBox(
            decoration: _getBackgroundImage(context),
            child: MaterialApp.router(
              theme: widget._lightTheme ?? theme_constants.lightTheme,
              darkTheme: widget._darkTheme ?? theme_constants.darkTheme,
              themeMode: ThemeMode.light,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              routerConfig: _router.router,
            ),
          ),
        ),
      );

  BoxDecoration _getBackgroundImage(BuildContext context) {
    // final pathToBackground = 'assets/images/backgrounds/background_'
    //     '${context.isDarkMode ? 'dark' : 'light'}.jpg';
    const pathToBackground = 'assets/images/background.png';
    return const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(pathToBackground),
      ),
    );
  }
}
