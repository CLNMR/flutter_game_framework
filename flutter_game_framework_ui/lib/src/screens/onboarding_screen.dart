import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../codegen/annotations/screen.dart';

/// The home screen of the app.
@Screen()
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates a [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) => const Center(child: Text('Onboarding'));
}
