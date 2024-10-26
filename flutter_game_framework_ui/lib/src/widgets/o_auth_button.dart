import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';
import 'package:yust_ui/yust_ui.dart';

import 'custom_icons.dart';

/// Displays buttons for signing in with different OAuth authentication methods.
class OAuthButton extends ConsumerWidget {
  /// Creates an [OAuthButton].
  const OAuthButton({
    super.key,
    required this.authMethod,
    this.redirection,
  });

  /// The authentication method to display the button for.
  final YustAuthenticationMethod authMethod;

  /// The route to redirect to after a successful sign in.
  final String? redirection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = _determineKey(authMethod);
    final buttonStyle = IconButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
    final onPressed = _determineOnPressed(context, ref, authMethod);
    final icon = _determineIcon(context, authMethod);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: IconButton(
          key: key,
          style: buttonStyle,
          onPressed: onPressed,
          icon: SizedBox(
            width: double.infinity,
            height: 40,
            child: icon,
          ),
        ),
      ),
    );
  }

  Key? _determineKey(YustAuthenticationMethod authMethod) {
    switch (authMethod) {
      case YustAuthenticationMethod.mail:
        return null;
      case YustAuthenticationMethod.microsoft:
        return const Key('signInWithMicrosoftButton');
      case YustAuthenticationMethod.google:
        return const Key('signInWithGoogleButton');
      case YustAuthenticationMethod.apple:
        return const Key('signInWithAppleButton');
      case YustAuthenticationMethod.openId:
        return const Key('otherProvidersButton');
    }
  }

  Function()? _determineOnPressed(
    BuildContext context,
    WidgetRef ref,
    YustAuthenticationMethod authMethod,
  ) {
    switch (authMethod) {
      case YustAuthenticationMethod.microsoft:
        return () async => _signInWithMicrosoft(context, ref);
      case YustAuthenticationMethod.google:
        return () async => _signInWithGoogle(context, ref);
      case YustAuthenticationMethod.apple:
        return () async => _signInWithApple(context, ref);
      default:
        return null;
    }
  }

  Widget? _determineIcon(
    BuildContext context,
    YustAuthenticationMethod authMethod,
  ) {
    final color = Theme.of(context).colorScheme.onSurface;

    switch (authMethod) {
      case YustAuthenticationMethod.mail:
        return null;
      case YustAuthenticationMethod.microsoft:
        return Icon(CustomIcons.microsoft, color: color);
      case YustAuthenticationMethod.google:
        return Icon(CustomIcons.google, color: color);
      case YustAuthenticationMethod.apple:
        return Icon(CustomIcons.apple, color: color);
      case YustAuthenticationMethod.openId:
        return Icon(Icons.format_list_bulleted, color: color);
    }
  }

  Future<void> _signInWithMicrosoft(BuildContext context, WidgetRef ref) async {
    await _signInWithProvider(
      context,
      ref,
      () async => Yust.authService
          .signInWithMicrosoft()
          .timeout(const Duration(seconds: 300)),
      redirection,
    );
  }

  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    await _signInWithProvider(
      context,
      ref,
      () async => Yust.authService
          .signInWithGoogle()
          .timeout(const Duration(seconds: 300)),
      redirection,
    );
  }

  Future<void> _signInWithApple(BuildContext context, WidgetRef ref) async {
    await _signInWithProvider(
      context,
      ref,
      () async => Yust.authService
          .signInWithApple()
          .timeout(const Duration(seconds: 300)),
      redirection,
    );
  }

  Future<void> _signInWithProvider(
    BuildContext context,
    WidgetRef ref,
    Future<YustUser?> Function() authenticationCallback,
    String? redirection,
  ) async {
    try {
      final router = GoRouter.of(context);
      await authenticationCallback();

      if (redirection != null) {
        router.go(redirection);
      } else {
        router.go('/');
      }
    } on PlatformException catch (err) {
      await YustUi.alertService.showAlert('Error', err.message!);
    } on TimeoutException catch (_) {
      await YustUi.alertService.showAlert(
        'Error',
        'Timeout while trying to sign in.',
      );
    } on FirebaseAuthException catch (err) {
      final errorMessage = err.toString();
      await YustUi.alertService.showAlert('Error', errorMessage);
    } catch (err) {
      await YustUi.alertService.showAlert('Error', err.toString());
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<YustAuthenticationMethod>('authMethod', authMethod))
      ..add(StringProperty('redirection', redirection));
  }
}
