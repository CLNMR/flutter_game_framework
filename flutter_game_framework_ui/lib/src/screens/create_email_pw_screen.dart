import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import '../widgets/own_text_field.dart';
import 'login_screen.r.dart';

/// The screen for creating a new account with email and password.
@Screen()
class CreateEmailPwScreen extends ConsumerStatefulWidget {
  /// Creates a [CreateEmailPwScreen].
  const CreateEmailPwScreen({super.key});

  @override
  ConsumerState<CreateEmailPwScreen> createState() =>
      _CreateEmailPwScreenState();
}

class _CreateEmailPwScreenState extends ConsumerState<CreateEmailPwScreen> {
  final _aliasController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get _alias => _aliasController.text;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool get _canSignUp =>
      _alias.isNotEmpty && _isEmailValid && _password.length >= 6;

  bool get _isEmailValid {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return _email.isNotEmpty && emailRegExp.hasMatch(_email);
  }

  @override
  void dispose() {
    _aliasController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              controller: _aliasController,
              label: 'signUpAlias',
              onChanged: (_) => setState(() {}),
              autocorrect: false,
            ),
            const SizedBox(height: 16),
            OwnTextField(
              controller: _emailController,
              label: 'signUpEmail',
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              style: _email.isNotEmpty && !_isEmailValid
                  ? const TextStyle(color: Colors.red)
                  : null,
            ),
            const SizedBox(height: 16),
            OwnTextField(
              controller: _passwordController,
              label: 'signUpPassword',
              onChanged: (_) => setState(() {}),
              obscureText: true,
              autocorrect: false,
              style: _password.isNotEmpty && _password.length < 6
                  ? const TextStyle(color: Colors.red)
                  : null,
            ),
            const SizedBox(height: 16),
            OwnButton(
              text: 'CreateAccount',
              onPressed: _canSignUp ? _trySignUp : null,
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _trySignUp() async {
    if (!_canSignUp) return;
    try {
      final router = GoRouter.of(context);
      await Yust.authService.createAccount(_alias, '', _email, _password);
      router.goNamed(LoginScreenRouting.path);
    } on Exception catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }
}
