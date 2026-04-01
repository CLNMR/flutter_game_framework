---
date: 2026-04-01T09:59:17Z
git_commit: cca3325ad37070be78eac7b7ad5132956fa518f7
branch: main
repository: flutter_game_framework
topic: "Framework Extraction, Localization, Testing, and Code Quality"
tags: [localization, easy_localization, melos, custom_lint, testing, framework-extraction, codegen]
last_updated: 2026-04-01
---

# Handoff: main — Framework extraction, localization migration, testing, and shared component extraction

## Context

Colin is building two multiplayer board games in Flutter — **tricking_bees** (trick-taking card game) and **Warigin** (hex-grid strategy game) — and extracting their shared infrastructure into **flutter_game_framework**. The framework is split into three packages: `flutter_game_framework_core` (Dart-only), `flutter_game_framework_ui` (Flutter), and `flutter_game_framework_lints` (custom_lint rules).

**Repos:**
- Framework: `/Users/clnif/Documents/Repos/flutter_game_framework`
- Tricking Bees: `/Users/clnif/Documents/Repos/trickgame/tricking_bees_flutter` (partially integrated)
- Warigin: `/Users/clnif/Documents/Repos/Warigin` (NOT yet integrated with framework)

All three repos are accessed in the same session via `/add-dir`.

## Tasks

### Completed This Session

1. **Localization migration** (commits `29e2491`..`d59448a`)
   - Removed broken Flutter built-in l10n (ARB files, l10n.yaml, generated S class, intl_utils)
   - Migrated to `easy_localization` with JSON translation files at `assets/localizables/{en-US,de-DE}.json`
   - Updated all widgets/screens to use `context.tr()` / `'key'.tr()` from easy_localization
   - Created `MergedAssetLoader` for games to layer their translations on framework defaults
   - Updated tricking_bees `main.dart` to wrap `GameFramework` in `EasyLocalization`
   - Key decision: easy_localization was chosen over Flutter built-in l10n because the `TrObject` system constructs keys dynamically at runtime (`'BUT:$text'`, `'ROLE:NAME:$name'`), which is incompatible with Flutter's typed-getter approach

2. **Translation validation** (commit `d59448a`)
   - Test at `flutter_game_framework_ui/test/translation_validation_test.dart`: checks key parity, no empty values, static key existence
   - Custom lint rule at `flutter_game_framework_lints/`: `missing_translation_key` warns on static `.tr()` keys not in JSON
   - **Note:** custom_lint plugin is currently **disabled** in `flutter_game_framework_ui/analysis_options.yaml` because it crashed the Dart Analysis Server. Can still be run manually via `dart run custom_lint`. The crash needs investigation.

3. **Melos workspace** (commit `135f8f2`)
   - Added `melos.yaml` at repo root with scripts: lint, lint-fix, test, gen, check-translations, custom-lint
   - Root `pubspec.yaml` with melos dev dependency
   - `melos bootstrap` resolves all 3 packages

4. **Dependency bumps** (commits `c87b360`, `81530fd`)
   - Bumped: collection, easy_localization, meta, pub_semver, google_fonts, build_runner, dart_code_metrics_presets, json_serializable, matcher, firebase_auth (^5→^6), intl (^0.19→^0.20), custom_lint_builder (^0.8.1), analyzer (^8.0.0 for lints package)
   - **Skipped major version jumps** that need code migration: riverpod (2→3), go_router (14→17), flex_color_scheme (7→8)
   - Pinned analyzer to `>=6.0.0 <10.0.0` in core/UI because `source_gen` 4.x uses the old element API removed in analyzer 10+

5. **Codegen fixes** (commit `f68c396`)
   - Fixed `build.yaml` in both packages: corrected package names (was `core_src`/`tb_core`, now `flutter_game_framework_core`/`flutter_game_framework_ui`)
   - Migrated `model_visitor.dart` in both packages: `visitor.dart` → `visitor2.dart`, `SimpleElementVisitor` → `SimpleElementVisitor2`
   - Added `riverpod_generator` dev dependency to UI package
   - Updated `providers.dart` to riverpod 4.x API (`Ref` instead of typed refs)
   - Replaced non-existent `YustUserService` with `Yust.databaseService.getFirstStream<YustUser>(YustUser.setup(), ...)`

6. **Lint cleanup** (commits `e34d1bc`, `ab1f5bd`, `f46ceb3`)
   - Both `flutter analyze` and `dcm analyze` report zero issues across all packages
   - Disabled DCM rules incompatible with SDK floor 3.4.1: `prefer-shorthands-with-enums`, `prefer-shorthands-with-static-fields`, `prefer-returning-shorthands` (require Dart 3.6+ dot shorthands)
   - Disabled `avoid-shadowing` (intentional in service_generator), `avoid-unsafe-collection-methods` (game logic uses known-valid indices), `avoid-default-tostring` (assert messages)

7. **Test suite** (commit `6bd93c9`)
   - 100 tests across 11 test files in `flutter_game_framework_core/test/`
   - Coverage: GameId, Player, GameState, Game (queries, copy), pre-game handling (add/remove players, start, shuffle), LogEntryType, LogEntry (polymorphic deserialization), log serialization, TrObject, RichTrObject/RichTrType, string extensions, other_functions
   - `TestGame` mock and `createTestUser` helper in `test/test_helpers.dart`

8. **TODO implementations** (commit `9714041`)
   - Wired `Yust.authService.createAccount()` in signup screen with controllers and disabled button
   - Integrated `noAuth` bypass in login
   - Enabled player/gameState filters on "Resume Last Game"
   - Renamed deferred TODOs to `// LATER:` comments

9. **Shared component extraction** (commit `cca3325`)
   - `Game.shortenedPlayerNames` getter, `Game.getStatusMessages()`, `Game.hasStuffToDo()`, `Game.currentRound`
   - `PlayerInstructionsRow` widget with configurable active/inactive colors
   - `GameScreenBase<G extends Game>` abstract class with YustDocBuilder + state dispatch
   - `LogEntryListDisplay` with builder callbacks for round headers, extra entry content, decoration
   - `WaitingDisplayBase` with game info box, player list, start button, dev player button

## Critical References

- `CLAUDE.md` at repo root — main project documentation with package structure, deps, commands
- `flutter_game_framework_ui/README.md` — localization setup, MergedAssetLoader usage, key prefix conventions, lint rule docs
- Memory files at `~/.claude/projects/-Users-clnif-Documents-Repos-flutter_game_framework/memory/`

## Recent Changes

All changes are in the framework repo. Key files touched:

**Core package:**
- `flutter_game_framework_core/lib/src/models/game/game.dart` — added `shortenedPlayerNames`, `currentRound`, `getStatusMessages()`, `hasStuffToDo()`
- `flutter_game_framework_core/lib/src/codegen/builders/model_visitor.dart` — `SimpleElementVisitor2`
- `flutter_game_framework_core/build.yaml` — fixed package name references
- `flutter_game_framework_core/pubspec.yaml` — analyzer pin, firebase_auth ^6, test dep, version bumps
- `flutter_game_framework_core/analysis_options.yaml` — removed deprecated rules, disabled DCM rules incompatible with SDK 3.4

**UI package:**
- `flutter_game_framework_ui/lib/src/util/context_extension.dart` — rewrote to use easy_localization
- `flutter_game_framework_ui/lib/src/game_framework.dart` — uses `context.localizationDelegates`
- `flutter_game_framework_ui/lib/src/util/merged_asset_loader.dart` — **new**, merges JSON translations
- `flutter_game_framework_ui/lib/src/util/providers.dart` — riverpod 4.x `Ref`, direct Yust DB call
- `flutter_game_framework_ui/lib/src/screens/game_screen_base.dart` — **new**
- `flutter_game_framework_ui/lib/src/screens/waiting_display_base.dart` — **new**
- `flutter_game_framework_ui/lib/src/widgets/log_entry_list_display.dart` — **new**
- `flutter_game_framework_ui/lib/src/widgets/player_instructions_row.dart` — **new**
- `flutter_game_framework_ui/assets/localizables/{en-US,de-DE}.json` — **new**, framework translations
- `flutter_game_framework_ui/build.yaml` — fixed to use `generateRouting` + `.r.dart`

**Lints package:**
- `flutter_game_framework_lints/` — **entire package is new**

**Tricking Bees (separate repo):**
- `packages/tricking_bees/lib/main.dart` — wraps GameFramework in EasyLocalization with MergedAssetLoader
- `packages/tricking_bees/pubspec.yaml` — firebase_auth ^6.0.1
- `packages/tb_core/pubspec.yaml` — cloud_firestore ^6.0.0

## Learnings

### Localization architecture
- The `TrObject` system stores translation keys as strings and constructs them dynamically (`'BUT:$text'`, `'ROLE:NAME:$name'`). This is **fundamentally incompatible** with Flutter's built-in typed l10n (which generates one getter per key). `easy_localization` with its `context.tr('key')` is the right fit.
- Widgets prepend prefixes: `OwnButton` → `BUT:`, `OwnSwitch` → `SWITCH:`, `OwnTextField` → `TEXTFIELDLABEL:`, `OwnText` → no prefix. JSON keys must match what the code looks up at runtime.
- `MergedAssetLoader` loads from multiple paths; later paths override earlier ones. Framework assets are at `packages/flutter_game_framework_ui/assets/localizables/` from the game's perspective.
- `EasyLocalization` widget must be **above** `MaterialApp` in the widget tree. Since `GameFramework` IS a `MaterialApp.router`, the game's `main.dart` wraps it.

### Analyzer / codegen compatibility
- `source_gen` 4.x uses the old analyzer element API (`element.dart`, `visitor.dart`). Analyzer 10+ removed these entirely. Analyzer 9 has `visitor2.dart` with `SimpleElementVisitor2` but still has `element.dart` with `ConstructorElement`/`ExtensionElement`. **Pin analyzer to `<10.0.0`** until source_gen migrates.
- The `model_visitor.dart` files exist in BOTH core and UI packages (duplicated). Both needed the `visitor2.dart` migration.
- `build.yaml` had leftover references to `core_src` and `tb_core` packages from before the extraction. The correct package names are `flutter_game_framework_core` and `flutter_game_framework_ui`.

### Custom lint rule
- `custom_lint_builder` 0.8.1 uses `DiagnosticReporter` (not `ErrorReporter`). Must import from `package:analyzer/error/listener.dart`.
- The lint rule doing synchronous `dart:io` file reads inside the analysis server **crashes it**. The plugin is disabled in `analysis_options.yaml` for now. It works fine via `dart run custom_lint`. Needs investigation — possibly switch to async or cache differently.
- DCM ignore comments must be on the **exact line** the analyzer flags, not the line above. The dart formatter can move comments, breaking ignores. For persistent issues, disable rules in `analysis_options.yaml` instead.

### Yust API
- `Yust.authService.signUp()` was renamed to `Yust.authService.createAccount(firstName, lastName, email, password)`.
- `YustUser` constructor requires named params: `YustUser(email: '', firstName: '', lastName: '')`.
- `YustDocSetup` requires `collectionName`, `fromJson`, `newDoc`.

### DCM rules vs SDK version
- Dot shorthand rules (`prefer-shorthands-with-enums`, `prefer-shorthands-with-static-fields`, `prefer-returning-shorthands`) require Dart 3.6+ but the SDK floor is 3.4.1. Disable them until the SDK constraint is bumped.

### Riverpod 4.x migration
- Provider functions take `Ref` instead of typed refs like `AuthStateRef` / `UserRef`.
- Requires `riverpod_generator` as dev dependency for code generation.

## Artifacts

**Framework repo — new files:**
- `melos.yaml`, `pubspec.yaml` (workspace root)
- `flutter_game_framework_lints/` (entire package: 5 files)
- `flutter_game_framework_ui/assets/localizables/{en-US,de-DE}.json`
- `flutter_game_framework_ui/lib/src/util/merged_asset_loader.dart`
- `flutter_game_framework_ui/lib/src/screens/game_screen_base.dart`
- `flutter_game_framework_ui/lib/src/screens/waiting_display_base.dart`
- `flutter_game_framework_ui/lib/src/widgets/log_entry_list_display.dart`
- `flutter_game_framework_ui/lib/src/widgets/player_instructions_row.dart`
- `flutter_game_framework_ui/test/translation_validation_test.dart`
- `flutter_game_framework_ui/README.md`
- `flutter_game_framework_core/test/` (11 test files + test_helpers.dart)
- `.gitignore` (comprehensive)

**Framework repo — deleted files:**
- `flutter_game_framework_ui/l10n.yaml`
- `flutter_game_framework_ui/lib/generated/` (3 files)
- `flutter_game_framework_ui/lib/l10n/` (3 ARB files)
- `flutter_game_framework_core/lib/src/util/yust_user_extension.dart`
- `flutter_game_framework_core/lib/src/util/yust_user_extension.service.dart`

**Tricking Bees repo — modified:**
- `packages/tricking_bees/lib/main.dart`
- `packages/tricking_bees/pubspec.yaml`
- `packages/tb_core/pubspec.yaml`

## Next Steps

### High Priority
1. **Migrate Warigin to use the framework** — This is the big remaining task. Warigin has NOT yet integrated with flutter_game_framework at all. It needs:
   - `wg_core`'s `Game` to extend framework's `Game`
   - `Player` model alignment
   - Logging system migration to framework's `LogEntry`/`LogEntryType`
   - `TrObject` extension (like tricking_bees did with `TBTrObject`)
   - Delete duplicate screens (home, login, account, settings, game list, join, new game) — use framework's
   - Delete duplicate widgets (OwnText, OwnButton, OwnSwitch, etc.) — use framework's
   - Wire up `initialize()` with Warigin-specific game route/setup/factory
   - Wrap in `EasyLocalization` with `MergedAssetLoader`

2. **Have tricking_bees use the new extracted components** — GameScreenBase, WaitingDisplayBase, LogEntryListDisplay, PlayerInstructionsRow are in the framework but tricking_bees still uses its own versions. Migrate to use the framework versions.

3. **Investigate custom_lint crash** — The `missing_translation_key` rule crashes the analysis server. Likely caused by synchronous `dart:io` file reads. Consider lazy/async loading or caching the key set at plugin startup instead of per-file.

### Medium Priority
4. **Major dependency upgrades** — riverpod 2→3, go_router 14→17, flex_color_scheme 7→8 were skipped. Each requires code migration.
5. **Bump SDK floor to 3.6+** — Would enable dot shorthand syntax and allow re-enabling DCM rules.
6. **Add game screen route to gf_router.dart** — Currently commented out, the framework router doesn't include the game-specific screen route.

### Low Priority
7. **Paginated game lists** — join_game_screen and game_list_screen use basic `YustDocsBuilder` with limit. Should use infinite scroll.
8. **Player offline heartbeat** — Write timestamp every 2 minutes, show offline after 3 minutes.
9. **Alias chooser** — Show mask after login to pick display name.

## Notes

- The framework uses local path dependencies to yust/yust_ui via `pubspec_overrides.yaml`. The yust repos are at `../../yust` and `../../yust_ui` relative to the framework UI package. These are excluded from git.
- `melos bootstrap` must be run from the framework root to resolve all packages. Individual `flutter pub get` may fail due to melos workspace interference.
- The `expandable` package is used in `LogEntryListDisplay` for collapsible round panels — it's already a dependency of both games.
- Translation key naming: both games use a Python script (`scripts/python/run_localizables.py` in Warigin) to compile YAML source files into the JSON format with prefixes. The framework's JSON was created manually from the ARB files.
- The `getSpans` function pointer in `initialization.dart` allows games to inject custom `InlineSpan` generation for `TrObject` (used by tricking_bees for role-colored text).
