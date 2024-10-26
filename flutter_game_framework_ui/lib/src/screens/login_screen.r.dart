// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RoutingGenerator
// **************************************************************************

// ignore_for_file: directives_ordering, prefer_relative_imports
// ignore_for_file: prefer_const_constructors
import 'package:go_router/go_router.dart';
import 'login_screen.dart';

/// The path and route of the screen.
extension LoginScreenRouting on LoginScreen {
  /// The path of the screen.
  static const String path = '/login';

  /// The parameter of the screen.
  static const String param = 'email';

  /// The route of the screen.
  static GoRoute route = GoRoute(
    path: path,
    name: path,
    builder: (
      context,
      state,
    ) =>
        LoginScreen(initialEmail: state.pathParameters[param]),
  );
}
