import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';

/// The home screen of the app.
@Screen()
class SettingScreen extends ConsumerStatefulWidget {
  /// Creates a [SettingScreen].
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
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
                text: 'Settings not implemented yet.',
                translate: false,
              ),
              const SizedBox(height: 24),
              OwnButton(text: 'ChangeLocale', onPressed: _changeLocale),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _changeLocale() async {
    final router = GoRouter.of(context);
    await context.setLocale(
      context.locale == const Locale('en', 'US')
          ? const Locale('de', 'DE')
          : const Locale('en', 'US'),
    );
    router.refresh();
  }
}
