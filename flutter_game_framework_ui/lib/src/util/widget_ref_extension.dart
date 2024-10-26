import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yust/yust.dart';

import 'providers.dart';

/// Extension methods for [WidgetRef].
///
/// Adds methods to get the current state of the app.
extension WidgetRefExtension on WidgetRef {
  /// Returns the current [AuthState] of the app.
  AuthState get authState =>
      watch(authStateProvider).value ?? AuthState.waiting;

  /// Returns the current [YustUser] of the app.
  YustUser? get user => watch(userProvider).value;
}
