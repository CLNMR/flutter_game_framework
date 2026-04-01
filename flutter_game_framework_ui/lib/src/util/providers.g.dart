// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current [AuthState].

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// The current [AuthState].

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// The current [AuthState].
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'ec96e43f2c64cac8350d6fa73d86fcf3286c4982';

/// The current [YustUser].

@ProviderFor(user)
final userProvider = UserProvider._();

/// The current [YustUser].

final class UserProvider
    extends
        $FunctionalProvider<AsyncValue<YustUser?>, YustUser?, Stream<YustUser?>>
    with $FutureModifier<YustUser?>, $StreamProvider<YustUser?> {
  /// The current [YustUser].
  UserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userHash();

  @$internal
  @override
  $StreamProviderElement<YustUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<YustUser?> create(Ref ref) {
    return user(ref);
  }
}

String _$userHash() => r'ce8bffdad2b5240b5915fd4352d3f3a4f9414b65';
