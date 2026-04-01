# flutter_game_framework

A shared Flutter package for building real-time multiplayer board games, extracted from two game projects: **tricking_bees** (trick-taking card game) and **Warigin** (hex-grid strategy game).

## Package Structure

- **`flutter_game_framework_core/`** - Dart-only core library (no Flutter dependency)
  - Abstract `Game` model extending `YustDoc` (Firestore-backed)
  - `Player`, `GameId`, `GameState` models with JSON serialization
  - Logging system: `LogEntry` base class + `LogEntryType` registry
  - `TrObject` / `RichTrObject` - dynamic translation objects with named args, gender, rich spans
  - Custom code generation: `@GenerateService` annotation + `ServiceGenerator` (source_gen)
  - `AppConfig`, `EnvVariables` for environment setup
  - Entry point: `lib/flutter_game_framework_core.dart` (22 exports)

- **`flutter_game_framework_ui/`** - Flutter UI library
  - 11 screens: home, login, signup, account, settings, new/join game, game list, onboarding, password reset
  - 13 reusable widgets: `OwnText`, `OwnButton`, `OwnTextField`, `OwnSwitch`, `OwnCounter`, etc.
  - GoRouter-based routing with `@Screen()` annotation codegen (`.r.dart` files)
  - `GameFramework` widget - top-level MaterialApp.router with theme + localization
  - `initialize()` - framework init accepting game-specific route, setup, factory, log types, rich types
  - `MergedAssetLoader` - loads and merges translations from multiple asset paths (framework + game)
  - Riverpod providers for auth state + current user
  - FlexColorScheme theming (yellowM3 light/dark)
  - Entry point: `lib/flutter_game_framework_ui.dart` (29 exports)

- **`flutter_game_framework_lints/`** - Custom lint rules (custom_lint)
  - `missing_translation_key` rule - warns when a static `.tr()` key is not in any translation JSON

## Key Dependencies

- `yust` / `yust_ui` - Firebase/Firestore backend framework (local path deps via `pubspec_overrides.yaml`)
- `flutter_riverpod` + `riverpod_annotation` - State management with codegen
- `go_router` - Navigation/routing
- `easy_localization` - Localization with JSON translation files
- `intl` - Number/date formatting
- `json_serializable` - JSON codegen
- `source_gen` + `build` - Custom code generation
- `firebase_auth` - Authentication
- `flex_color_scheme` - Theming
- `custom_lint` - Custom lint rules

## Code Generation

Run `dart run build_runner build` in each package. Generates:
- `.g.dart` - JSON serialization (json_serializable) and Riverpod providers
- `.r.dart` - Screen routing extensions (custom generator)
- `.service.dart` - Service classes (custom generator in core)

## Localization

Uses `easy_localization` with flat JSON files at `assets/localizables/{en-US,de-DE}.json`.

**Key prefix convention:** Widgets prepend prefixes to their text params:
- `OwnButton` -> `BUT:` prefix
- `OwnSwitch` -> `SWITCH:` prefix
- `OwnTextField` -> `TEXTFIELDLABEL:` prefix
- `OwnText` -> no prefix (key passed as-is)

Games use `MergedAssetLoader` to layer their translations on top of the framework's. See `flutter_game_framework_ui/README.md` for setup details.

**Validation:** `flutter test test/translation_validation_test.dart` checks key parity, no empty values, and that all static `.tr()` keys exist in the JSON.

## Architecture Pattern

The framework uses an **initialize + inject** pattern:
```dart
await initialize(
  gameScreenRoute: TBGameScreen.route,  // game-specific GoRoute
  gameSetup: TBGame.setup(),            // YustDocSetup for Firestore
  createNewGame: () => TBGame(),        // factory for new games
  additionalLogTypes: TBLogEntryType.values,
  additionalRichTrTypes: TBRichTrType.values,
);
```

Games extend `Game`, register their `LogEntryType` and `RichTrType` values, and provide a game screen. The framework handles auth, navigation, game CRUD, and shared UI.

The game's `main.dart` wraps `GameFramework` in `EasyLocalization` with `MergedAssetLoader`.

## Common Commands

```bash
# From each sub-package:
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Translation validation:
flutter test test/translation_validation_test.dart

# Custom lint check:
dart run custom_lint
```
