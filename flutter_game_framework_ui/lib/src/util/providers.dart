import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yust/yust.dart';

part 'providers.g.dart';

/// The current [AuthState].
@riverpod
Stream<AuthState> authState(Ref ref) => Yust.authService.getAuthStateStream();

/// The current [YustUser].
@riverpod
Stream<YustUser?> user(Ref ref) {
  ref.watch(authStateProvider);
  final authId = Yust.authService.getCurrentUserId();
  return Yust.databaseService.getFirstStream<YustUser>(
    YustUser.setup(),
    filters: [
      YustFilter(
        comparator: YustFilterComparator.equal,
        field: 'authId',
        value: authId,
      ),
    ],
  );
}
