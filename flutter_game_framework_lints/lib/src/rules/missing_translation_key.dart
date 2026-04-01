import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Warns when a static translation key used with `.tr()` or `context.tr()`
/// is not found in any JSON translation file.
///
/// Only checks `SimpleStringLiteral` — string literals without interpolation.
/// Dynamic keys like `'BUT:$text'` are intentionally skipped.
class MissingTranslationKeyRule extends DartLintRule {
  MissingTranslationKeyRule() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_translation_key',
    problemMessage:
        'Translation key not found in any JSON translation file.',
    correctionMessage: 'Add this key to your translation JSON files.',
  );

  Set<String>? _cachedKeys;
  String? _cachedProjectRoot;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final projectRoot = _findProjectRoot(resolver.path);
    if (projectRoot == null) return;

    // Load and cache translation keys when the project root changes.
    if (_cachedKeys == null || _cachedProjectRoot != projectRoot) {
      _cachedProjectRoot = projectRoot;
      _cachedKeys = _loadAllTranslationKeys(projectRoot);
    }
    final keys = _cachedKeys!;
    if (keys.isEmpty) return;

    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'tr') return;

      final target = node.target;

      // Case 1: 'someKey'.tr()
      if (target is SimpleStringLiteral) {
        if (!keys.contains(target.value)) {
          reporter.atNode(target, _code);
        }
        return;
      }

      // Case 2: context.tr('someKey') — check first positional argument.
      final args = node.argumentList.arguments;
      if (args.isNotEmpty && args.first is SimpleStringLiteral) {
        final key = (args.first as SimpleStringLiteral).value;
        if (!keys.contains(key)) {
          reporter.atNode(args.first, _code);
        }
      }
    });
  }

  /// Walk up from the analyzed file to find the project root (directory
  /// containing pubspec.yaml).
  String? _findProjectRoot(String filePath) {
    var dir = Directory(filePath).parent;
    for (var i = 0; i < 20; i++) {
      if (File('${dir.path}/pubspec.yaml').existsSync()) {
        return dir.path;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
    return null;
  }

  /// Loads translation keys from all `en-US.json` files found in common
  /// locations relative to the project root.
  Set<String> _loadAllTranslationKeys(String projectRoot) {
    final keys = <String>{};
    final paths = [
      '$projectRoot/assets/localizables/en-US.json',
      // Framework package translations accessible from game projects.
      '$projectRoot/packages/flutter_game_framework_ui/assets/localizables/en-US.json',
    ];

    // Also check for symlinked/local framework packages.
    final pubspecOverrides =
        File('$projectRoot/pubspec_overrides.yaml');
    if (pubspecOverrides.existsSync()) {
      // Best effort: also check the direct framework path.
      final fwPath =
          '$projectRoot/../flutter_game_framework/flutter_game_framework_ui/assets/localizables/en-US.json';
      paths.add(fwPath);
    }

    for (final path in paths) {
      final file = File(path);
      if (!file.existsSync()) continue;
      try {
        final data = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
        keys.addAll(data.keys);
      } catch (_) {
        // Malformed JSON; skip.
      }
    }
    return keys;
  }
}
