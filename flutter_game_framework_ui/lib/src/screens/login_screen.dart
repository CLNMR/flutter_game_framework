import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/o_auth_button.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import '../widgets/own_text_field.dart';
import 'create_email_pw_screen.r.dart';
import 'home_screen.r.dart';

/// The home screen of the app.
@Screen()
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates a [LoginScreen].
  const LoginScreen({super.key, this.initialEmail});

  /// The route to redirect to after a successful sign in.
  final String? redirection = '';

  /// The email address, if sent from the password creation screen.
  final String? initialEmail;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('redirection', redirection))
      ..add(StringProperty('initialEmail', initialEmail));
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeading(),
                // if (noAuth) _buildQuickLogin(context), TODO
                _buildLoginWithEmailPw(context),
                _buildCreateAccountButton(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OAuthButton(
                      authMethod: YustAuthenticationMethod.google,
                      redirection: widget.redirection,
                    ),
                    OAuthButton(
                      authMethod: YustAuthenticationMethod.apple,
                      redirection: widget.redirection,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeading() => const OwnText(
        text: 'HEAD:appTitle',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: Colors.white,
        ),
      );

  Widget _buildQuickLogin(BuildContext context) => OwnButton(
        text: 'Quick Dev Login',
        onPressed: () async {
          _emailController.text = '1@xxx.xxx';
          _passwordController.text = 'xxxxxx';
          await _tryLogin();
        },
      );

  Widget _buildCreateAccountButton(BuildContext context) => OwnButton(
        text: 'CreateAccount',
        onPressed: _goToCreateEmailPwScreen(context),
      );

  VoidCallback _goToCreateEmailPwScreen(BuildContext context) =>
      () async => context.push(CreateEmailPwScreenRouting.path);

  Widget _buildLoginWithEmailPw(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            OwnTextField(
              controller: _emailController,
              label: 'logInEmail',
              onChanged: (text) {
                setState(() {});
              },
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
            const SizedBox(height: 16),
            OwnTextField(
              controller: _passwordController,
              label: 'logInPassword',
              onChanged: (text) {
                setState(() {});
              },
              obscureText: true,
              autocorrect: false,
              onEditingComplete: _tryLogin,
            ),
            const SizedBox(height: 16),
            OwnButton(
              text: 'Login',
              onPressed: isLoginDisabled ? null : _tryLogin,
            ),
          ],
        ),
      );

  /// Whether the login button should be disabled.
  bool get isLoginDisabled =>
      _emailController.text.isEmpty || _passwordController.text.isEmpty;

  /// Tries to log in the user.
  Future<void> _tryLogin() async {
    // if (isLoginDisabled && !noAuth) return; TODO
    if (isLoginDisabled) return;
    try {
      final router = GoRouter.of(context);
      await Yust.authService
          .signIn(_emailController.text, _passwordController.text);
      router.goNamed(HomeScreenRouting.path);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<bool>('isLoginDisabled', isLoginDisabled));
  }

  // LaterTODO: Show mask to choose alias, save alias in first name instead of
  // real name
}
