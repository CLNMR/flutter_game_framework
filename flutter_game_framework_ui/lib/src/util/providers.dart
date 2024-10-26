import 'package:flutter_game_framework_core/flutter_game_framework_core.dart'
    as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yust/yust.dart';

part 'providers.g.dart';

@riverpod

/// The current [AuthState].
Stream<AuthState> authState(AuthStateRef ref) =>
    Yust.authService.getAuthStateStream();

@riverpod

/// The current [YustUser].
Stream<YustUser?> user(UserRef ref) {
  ref.watch(authStateProvider);
  final authId = Yust.authService.getCurrentUserId();
  return core.YustUserService.getFirstStream(
    filters: [
      YustFilter(
        comparator: YustFilterComparator.equal,
        field: 'authId',
        value: authId,
      ),
    ],
  );
}
