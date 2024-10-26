import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import '../widgets/own_text_field.dart';
import 'login_screen.r.dart';

/// The home screen of the app.
@Screen()
class CreateEmailPwScreen extends ConsumerStatefulWidget {
  /// Creates a [CreateEmailPwScreen].
  const CreateEmailPwScreen({super.key});

  @override
  ConsumerState<CreateEmailPwScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<CreateEmailPwScreen> {
  String _alias = '';
  String _email = '';
  String _password = '';

  bool get _canSignUp =>
      _alias.isNotEmpty && _isEmailValid && _password.length >= 6;

  // Email validation using RegExp
  bool get _isEmailValid {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return _email.isNotEmpty && emailRegExp.hasMatch(_email);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const OwnText(text: 'HEAD:appTitle', type: OwnTextType.title),
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OwnTextField(
                  label: 'signUpAlias',
                  onChanged: (text) => _alias = text,
                  autocorrect: false,
                ),
                const SizedBox(height: 16),
                OwnTextField(
                  label: 'signUpEmail',
                  onChanged: (text) => _email = text,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: _email.isNotEmpty && !_isEmailValid
                      ? const TextStyle(color: Colors.red)
                      : null,
                ),
                const SizedBox(height: 16),
                OwnTextField(
                  label: 'signUpPassword',
                  onChanged: (text) => _password = text,
                  obscureText: true,
                  autocorrect: false,
                  style: _password.isNotEmpty && _password.length < 6
                      ? const TextStyle(color: Colors.red)
                      : null,
                ),
                const SizedBox(height: 16),
                OwnButton(
                  text: 'CreateAccount',
                  // TODO: Disable button if not _canSignUp, but need to set
                  // state on every text entry and implement controllers.
                  onPressed: _trySignUp,
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _trySignUp() async {
    if (!_canSignUp) {
      return;
    }
    try {
      final router = GoRouter.of(context);
      await Yust.authService.signUp(_alias, '', _email, _password);
      router.goNamed(
        LoginScreenRouting.path,
        // TODO: Implement pathParameters properly, see login_screen.r.dart.
        // Didn't work when I tried to implement like game_screen.r.dart.
        // pathParameters: {'email': _email},
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
