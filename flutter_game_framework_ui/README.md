# flutter_game_framework_ui

Shared UI layer for building real-time multiplayer board games in Flutter. Provides screens (home, login, settings, game list, etc.), reusable widgets, routing, theming, and localization infrastructure.

## Localization

Uses [easy_localization](https://pub.dev/packages/easy_localization) with flat JSON translation files. The framework ships its own translations at `assets/localizables/{en-US,de-DE}.json` for all shared screens and widgets.

### Translation Key Prefixes

Widgets automatically prepend prefixes to their text parameters:

| Widget | Prefix | Example |
|---|---|---|
| `OwnButton(text: 'NewGame')` | `BUT:` | looks up `BUT:NewGame` |
| `OwnSwitch(firstOptionKey: 'Offline')` | `SWITCH:` | looks up `SWITCH:Offline` |
| `OwnTextField(label: 'logInEmail')` | `TEXTFIELDLABEL:` | looks up `TEXTFIELDLABEL:logInEmail` |
| `OwnText(text: 'HEAD:appTitle')` | *(none)* | looks up `HEAD:appTitle` as-is |

Other common prefixes used by convention: `HEAD:`, `LOG:`, `JOINGAME:`, `STATUS:`, `ROLE:`, `CARD:`, `EVENT:`.

### MergedAssetLoader

Games layer their own translations on top of the framework's using `MergedAssetLoader`. It loads JSON files from multiple asset paths and merges them. **Later paths override earlier paths**, so game translations take precedence over framework defaults.

```dart
// In your game's main.dart:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';

void main() async {
  await initialize(
    gameScreenRoute: MyGameScreen.route,
    gameSetup: MyGame.setup(),
    createNewGame: MyGame.new,
  );
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
      path: 'assets/localizables',
      fallbackLocale: const Locale('en', 'US'),
      assetLoader: MergedAssetLoader([
        'packages/flutter_game_framework_ui/assets/localizables', // framework
        'assets/localizables',                                      // your game
      ]),
      child: const GameFramework(),
    ),
  );
}
```

### Adding Translations for a New Game

1. Create `assets/localizables/en-US.json` and `de-DE.json` in your game package
2. Add game-specific keys (roles, cards, events, status messages, etc.)
3. Override framework keys where needed (e.g., `"HEAD:appTitle": "My Game"`)
4. Declare assets in your game's `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/localizables/en-US.json
       - assets/localizables/de-DE.json
   ```
5. Use `MergedAssetLoader` in `main.dart` as shown above

### Translation Validation

A test at `test/translation_validation_test.dart` checks:
- en-US and de-DE JSON files have identical key sets
- No empty translation values
- All static `.tr()` keys in source code exist in the JSON

Run with:
```bash
flutter test test/translation_validation_test.dart
```

### Custom Lint Rule

The `flutter_game_framework_lints` package provides an IDE-time lint rule `missing_translation_key` that warns when a static `.tr()` key is not found in any translation JSON file.

To enable in your game:

1. Add to `pubspec.yaml` dev_dependencies:
   ```yaml
   custom_lint: ^0.7.0
   flutter_game_framework_lints:
     path: ../path/to/flutter_game_framework_lints
   ```

2. Add to `analysis_options.yaml`:
   ```yaml
   analyzer:
     plugins:
       - custom_lint
   ```

3. Run manually:
   ```bash
   dart run custom_lint
   ```

The rule only flags `SimpleStringLiteral` keys (no interpolation). Dynamic keys like `context.tr('BUT:$text')` are intentionally skipped.
