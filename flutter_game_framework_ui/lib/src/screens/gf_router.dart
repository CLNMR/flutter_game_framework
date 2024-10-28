import 'package:flutter/material.dart';
import 'package:flutter_game_framework_ui/src/util/widget_ref_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';

import 'account_screen.r.dart';
import 'create_email_pw_screen.r.dart';
import 'game_list_screen.r.dart';
import 'home_screen.r.dart';
import 'join_game_screen.r.dart';
import 'login_screen.r.dart';
import 'new_game_screen.r.dart';
import 'onboarding_screen.r.dart';
import 'password_reset_screen.r.dart';
import 'setting_screen.r.dart';

/// A helper to get the of the app.
class GFRouter {
  GoRouter? _router;

  /// The go router.
  GoRouter get router => _router!;

  /// Initializes the router.
  void initialize(BuildContext context, WidgetRef ref) {
    _router ??= GoRouter(
      routes: [
        GoRoute(
          path: '/',
          redirect: (_, __) => '/home',
        ),
        ..._getRoutes(ref),
      ],
      initialLocation: LoginScreenRouting.path,
      debugLogDiagnostics: false,
      redirect: (context, state) => _guard(context, state, ref),
    );
  }

  /// The routes of the app.
  List<GoRoute> _getRoutes(WidgetRef ref) => [
        AccountScreenRouting.route,
        CreateEmailPwScreenRouting.route,
        GameListScreenRouting.route,
        // TODO: GameScreenRouting.route,
        HomeScreenRouting.route,
        SettingScreenRouting.route,
        JoinGameScreenRouting.route,
        LoginScreenRouting.route,
        NewGameScreenRouting.route,
        OnboardingScreenRouting.route,
        PasswordResetScreenRouting.route,
      ];

  String? _guard(BuildContext context, GoRouterState state, WidgetRef ref) {
    final userRequired = ![
      OnboardingScreenRouting.path,
      LoginScreenRouting.path,
      PasswordResetScreenRouting.path,
      CreateEmailPwScreenRouting.path,
    ].contains(state.fullPath);

    if (userRequired && ref.authState == AuthState.signedOut) {
      return '${LoginScreenRouting.path}?redirection='
          '${Uri.encodeComponent(state.fullPath ?? '')}';
    }
    // no redirect
    return null;
  }
}
