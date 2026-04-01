import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// Loads and merges translations from multiple asset paths.
///
/// Later paths override earlier paths, so game translations override
/// framework defaults. Use this to layer game-specific translations on top
/// of the framework's shared translations.
///
/// Example:
/// ```dart
/// MergedAssetLoader([
///   'packages/flutter_game_framework_ui/assets/localizables', // framework
///   'assets/localizables',                                      // game
/// ])
/// ```
class MergedAssetLoader extends AssetLoader {
  /// Creates a [MergedAssetLoader] that loads from the given [assetPaths].
  MergedAssetLoader(this.assetPaths);

  /// The list of asset directory paths to load translations from.
  final List<String> assetPaths;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localeStr = '${locale.languageCode}-${locale.countryCode}';
    final merged = <String, dynamic>{};
    for (final assetPath in assetPaths) {
      try {
        final data = await rootBundle.loadString('$assetPath/$localeStr.json');
        merged.addAll(json.decode(data) as Map<String, dynamic>);
      } catch (_) {
        // Asset path may not have this locale; continue.
      }
    }
    return merged;
  }
}
