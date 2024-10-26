import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../codegen/annotations/screen.dart';

/// The home screen of the app.
@Screen()
class PasswordResetScreen extends ConsumerStatefulWidget {
  /// Creates a [PasswordResetScreen].
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<PasswordResetScreen> {
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('PasswordReset'));
}
