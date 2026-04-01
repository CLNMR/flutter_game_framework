import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import 'login_screen.r.dart';

/// The home screen of the app.
@Screen()
class AccountScreen extends ConsumerStatefulWidget {
  /// Creates a [AccountScreen].
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
      title: const OwnText(text: 'HEAD:account', type: OwnTextType.title),
      backgroundColor: Colors.black26,
      foregroundColor: Colors.white,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OwnText(
                text: 'Account settings not implemented yet.',
                translate: false,
              ),
              const SizedBox(height: 24),
              OwnButton(text: 'SignOut', onPressed: _logout),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _logout() async {
    final router = GoRouter.of(context);
    await Yust.authService.signOut();
    router.goNamed(LoginScreenRouting.path);
  }
}
