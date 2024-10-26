import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yust/yust.dart';

import 'providers.dart';

/// Extension methods for [Ref].
///
/// Adds methods to get the current state of the app.
extension RefExtension on Ref {
  /// Returns the current [AuthState] of the app.
  AuthState get authState => read(authStateProvider).value ?? AuthState.waiting;

  /// Returns the current [YustUser] of the app.
  YustUser? get user => read(userProvider).value;
}
