// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RoutingGenerator
// **************************************************************************

// ignore_for_file: directives_ordering, prefer_relative_imports
// ignore_for_file: prefer_const_constructors
import 'package:go_router/go_router.dart';
import 'home_screen.dart';

/// The path and route of the screen.
extension HomeScreenRouting on HomeScreen {
  /// The path of the screen.
  static const String path = '/home';

  /// The parameter of the screen.
  static const String? param = null;

  /// The route of the screen.
  static GoRoute route = GoRoute(
    path: path,
    name: path,
    builder: (
      context,
      state,
    ) =>
        HomeScreen(),
  );
}
