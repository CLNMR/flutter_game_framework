---
date: 2026-04-01T18:00:00Z
git_commit: c6edce3efbe7364ad107071f3e56539fd8e9b1bb
branch: main
repository: flutter_game_framework
topic: "SDK Upgrade, Tricking Bees Integration, UI Readability"
tags: [sdk-upgrade, dependency-upgrade, tricking-bees, integration, ui, theme, routing, codegen]
last_updated: 2026-04-01
---

# Handoff: main — SDK upgrade, tricking_bees integration, and UI improvements

## Context

Continuing from the previous handoff (cca3325). Colin is building two multiplayer board games — **tricking_bees** and **Warigin** — sharing infrastructure via **flutter_game_framework**. This session focused on upgrading the SDK/deps, finishing the tricking_bees integration with the framework, and making the UI readable on dark backgrounds.

**Repos:**
- Framework: `/Users/clnif/Documents/Repos/flutter_game_framework` — HEAD: `c6edce3`
- Tricking Bees: `/Users/clnif/Documents/Repos/trickgame/tricking_bees_flutter` — HEAD: `f1ec1b4`
- Warigin: `/Users/clnif/Documents/Repos/Warigin` (NOT yet integrated with framework)

## Tasks

### Completed This Session

1. **SDK floor bump + dependency upgrades** (framework commit `62395cb`)
   - Dart SDK floor: `>=3.4.1` → `>=3.10.0` across all packages
   - Flutter floor: `>=1.17.0` → `>=3.38.0` in UI package
   - flex_color_scheme: `^7.3.1` → `^8.4.0` (migrated `theme_constants.dart`: removed `blendTextTheme`, renamed `useTextTheme` → `useMaterial3Typography`, added `inputDecoratorBorderType`/`inputDecoratorIsFilled` defaults)
   - Pinned all `any`/empty constraints to explicit `^x.y.z` (riverpod `^3.1.0`, go_router `^17.1.0`, etc.)
   - Re-enabled 3 DCM dot-shorthand rules
   - Enabled `dot-shorthands` experiment in all `analysis_options.yaml` files
   - Fixed `build_extensions` in framework `build.yaml` (`.get.dart` → `.service.dart`)
   - Added `packageFilters: dependsOn: 'build_runner'` to melos `gen` script
   - Wired `gameScreenRoute` into `gf_router.dart`

2. **Tricking Bees framework integration** (trickgame commit `f482c22`)
   - Implemented `TBGame.copy()` (JSON round-trip), `init()` (Yust initDoc), `start()` (delegates to `startGame()`)
   - Removed redundant `isAuthenticatedPlayer()` stub
   - Fixed `customStartLogic()`: removed redundant `gameState` assignment
   - Enabled service builder: configured `build.yaml`, generated `tb_game.service.dart`
   - Built card removal UI for RoleC in `role_selection_display.dart`
   - Added missing `SelectThree` translation key
   - Bumped tb_core/tricking_bees SDK to `>=3.10.0`, aligned all deps with framework
   - Resolved ambiguous imports (`hide PlayerInstructionsRow, LogEntryListDisplay`)
   - Moved `ProviderScope` from `GameFramework.build()` to `main.dart` `runApp()`

3. **DCM + Dart lint cleanup** (trickgame commits `43182b7`, `c2fa569`)
   - Applied dot shorthands via `dcm fix` across all files
   - Removed unused imports, commented-out code
   - Fixed unnecessary nullable return types/parameters
   - Disabled non-applicable DCM rules in `analysis_options.yaml`
   - Replaced deprecated `withOpacity()` with `withValues(alpha:)`

4. **UI readability overhaul** (framework commit `e2ff4c0`)
   - `OwnText`: default color `Colors.black` → `Colors.white`
   - `OwnTextField`: default text color → white
   - `OwnButton`: explicit primary/onPrimary colors, bold text, elevation 4
   - `OwnSwitch`: white text and border
   - `OwnCounter`: white text, white70 disabled color
   - Wrapped screen content in semi-transparent dark cards (`Colors.black54`, `borderRadius: 12`) across login, signup, account, settings, new game, join game, game list screens
   - Set global `AppBarTheme` with white foreground/icons

5. **Theme extraction** (framework commit `c6edce3`, trickgame commit `f1ec1b4`)
   - `GameFramework.lightTheme` is now **required** (was optional with framework default)
   - Deleted `theme_constants.dart` from framework
   - Created `packages/tricking_bees/lib/design/tb_theme.dart` with `FlexScheme.mango`
   - Each game now owns its theme — Warigin can use a different scheme

6. **Bug fixes** (various commits)
   - Fixed OAuth error handling: `ScaffoldMessenger` instead of uninitialized `YustUi.alertService`
   - Fixed login/signup error display: snackbar instead of print-only
   - Fixed `GameButton`: `translate: false` for game ID/date, guard empty players, use `pushNamed` with `name!`
   - Fixed `NewGameScreen`/`HomeScreen`: use `pushNamed` with `gameScreenRoute.name!` instead of `.path`
   - Fixed `PlayerInstructionsRow` `RangeError` on empty status messages
   - Fixed `WaitingDisplay` layout overflow: `SingleChildScrollView`
   - Fixed `InGameDisplay` crash when user is spectator
   - Added "No active game found" snackbar for Resume Last Game
   - Added `.gitignore` for `pubspec_overrides.yaml`, symlinks, `.DS_Store`
   - Added missing `WAITING:` / `NEWGAME:` translation keys to en-US.json

## Critical References

- `CLAUDE.md` at framework repo root
- Previous handoff: `knowledge/local/scratch/handoffs/main/2026-04-01_11-59-17_framework-extraction-and-localization.md`
- Memory files at `~/.claude/projects/-Users-clnif-Documents-Repos-flutter_game_framework/memory/`

## Recent Changes

### Framework (5 commits since `cca3325`)

**Modified:**
- `flutter_game_framework_core/analysis_options.yaml` — enable dot-shorthands, re-enable DCM rules
- `flutter_game_framework_core/build.yaml` — fix build_extensions `.get.dart` → `.service.dart`
- `flutter_game_framework_ui/analysis_options.yaml` — enable dot-shorthands
- `flutter_game_framework_ui/lib/src/game_framework.dart` — `lightTheme` now required, removed ProviderScope from build, removed theme_constants import
- `flutter_game_framework_ui/lib/src/screens/gf_router.dart` — wired `gameScreenRoute` into routes
- `flutter_game_framework_ui/lib/src/screens/*.dart` — all screens: dark card wrappers, white text, routing fixes, error snackbars
- `flutter_game_framework_ui/lib/src/widgets/own_text.dart` — default white
- `flutter_game_framework_ui/lib/src/widgets/own_button.dart` — explicit primary colors, bold
- `flutter_game_framework_ui/lib/src/widgets/own_text_field.dart` — default white
- `flutter_game_framework_ui/lib/src/widgets/own_switch.dart` — white text/border
- `flutter_game_framework_ui/lib/src/widgets/own_counter.dart` — white text
- `flutter_game_framework_ui/lib/src/widgets/game_button.dart` — translate: false, guard empty players, fix routing
- `flutter_game_framework_ui/lib/src/widgets/o_auth_button.dart` — ScaffoldMessenger errors, removed yust_ui import
- `melos.yaml` — gen script packageFilters
- All `pubspec.yaml` files — SDK floor, dep pins

**Deleted:**
- `flutter_game_framework_ui/lib/src/design/theme_constants.dart` — theme now provided by games

### Tricking Bees (6 commits since `9b463be`)

**New files:**
- `packages/tricking_bees/lib/design/tb_theme.dart` — FlexScheme.mango theme
- `packages/tb_core/lib/src/models/game/tb_game.service.dart` — generated service
- `.gitignore` — pubspec_overrides, symlinks, .DS_Store

**Modified:**
- `packages/tb_core/lib/src/models/game/tb_game.dart` — copy/init/start implemented, @override currentRound, removed isAuthenticatedPlayer, dot shorthands
- `packages/tb_core/lib/src/models/game/tb_game_pre_game_handling.dart` — fixed customStartLogic
- `packages/tb_core/lib/src/models/game/tb_game_status_generation.dart` — LATER comment, dot shorthands
- `packages/tb_core/lib/src/models/game/tb_game_role_handling.dart` — non-nullable getFirstPlayerWithRole, removed commented code
- `packages/tb_core/lib/src/models/game/game_automatic_playing.dart` — switch for enum, non-nullable params
- `packages/tb_core/lib/src/models/game/game_card_playing.dart` — dot shorthands
- `packages/tb_core/lib/src/roles/*.dart` — dot shorthands, removed unused imports, non-nullable return types
- `packages/tb_core/build.yaml` — enable framework generator
- `packages/tb_core/pubspec.yaml` — SDK 3.10, aligned deps
- `packages/tb_core/analysis_options.yaml` — dot-shorthands, disabled inapplicable rules
- `packages/tb_core/lib/tb_core.dart` — uncommented service export
- `packages/tricking_bees/lib/main.dart` — ProviderScope, tbLightTheme
- `packages/tricking_bees/lib/screens/game_display/in_game_display.dart` — spectator guard, hide imports
- `packages/tricking_bees/lib/screens/game_display/waiting_display.dart` — SingleChildScrollView, hide imports
- `packages/tricking_bees/lib/screens/game_display/role_selection_display.dart` — card removal UI
- `packages/tricking_bees/lib/widgets/in_game/player_information/player_instructions_row.dart` — empty list guard
- `packages/tricking_bees/assets/localizables/en-US.json` — WAITING/NEWGAME keys, SelectThree
- `packages/tricking_bees/assets/localizables/de-DE.json` — SelectThree
- `packages/tricking_bees/analysis_options.yaml` — dot-shorthands, removed deprecated/unresolvable rules
- `packages/tricking_bees/pubspec.yaml` — SDK 3.10, aligned deps

**Removed from tracking:**
- `pubspec_overrides.yaml` files (now gitignored)
- `packages_external/yust`, `packages_external/yust_ui` symlinks

## Learnings

### Dot shorthands are experimental in Dart 3.10
- `flutter analyze` accepts dot shorthand syntax, but the **compiler** requires `--enable-experiment=dot-shorthands`
- Must add `analyzer: enable-experiment: [dot-shorthands]` to `analysis_options.yaml` in every package that uses or depends on code with dot shorthands
- Flutter reads this config and passes the flag to the compiler

### ProviderScope placement with Riverpod 3.x
- `ProviderScope` must be **above** any `ConsumerWidget`/`ConsumerStatefulWidget` in the tree
- `GameFramework` is a `ConsumerStatefulWidget`, so `ProviderScope` must wrap it (in `main.dart`), not be inside its `build()` method

### GoRouter named routes
- `GoRoute.path` is the pattern (e.g., `/game/:gameId`), `GoRoute.name` is the identifier (e.g., `/game`)
- `pushNamed` expects the name, not the path pattern
- The generated `.r.dart` files set `name: path` (the base path without parameters)

### FlexColorScheme 8.x
- `FlexScheme.honey` doesn't exist — available bee-like schemes: `mango` (warm golden), `amber`, `gold`
- `blendTextTheme` deprecated (no-op), `useTextTheme` renamed to `useMaterial3Typography`
- `inputDecoratorBorderType` default changed to underline, `inputDecoratorIsFilled` default changed to false

### Theme ownership
- The framework should NOT define a default theme — each game needs its own colors
- `GameFramework.lightTheme` is now required; games create their theme in a local `design/` file
- The `AppBarTheme` with white foreground should be included in each game's theme via `.copyWith()`

### UI on dark backgrounds
- All framework screens use `Colors.transparent` scaffold with a dark background image
- Widget defaults (OwnText, OwnTextField, etc.) must use white text, not black
- Content areas need semi-transparent dark card wrappers (`Colors.black54`) for readability
- `OwnText` with dynamic data (game IDs, dates) needs `translate: false`

### Service generator produces LibraryBuilder output
- The `build_extensions` in `build.yaml` must match `generatedExtension` in the `LibraryBuilder` (`.service.dart`)
- The generated file is a standalone library, NOT a `part` file — don't use `part` directive
- Export it from the barrel file instead
- The generated `save()` extension is shadowed by TBGame's instance method — harmless

## Next Steps

### High Priority
1. **Migrate Warigin to use the framework** — the big remaining task. Needs:
   - Game model extending framework's `Game`
   - Player model alignment
   - Logging system migration
   - Delete duplicate screens/widgets
   - Wire `initialize()` + `EasyLocalization` + `MergedAssetLoader`
   - Create Warigin-specific theme (different from mango)
   - Enable `dot-shorthands` experiment

2. **Have tricking_bees use framework's extracted components** — `GameScreenBase`, `WaitingDisplayBase`, `LogEntryListDisplay`, `PlayerInstructionsRow` exist in the framework but tricking_bees still has its own versions with game-specific customizations. Evaluate what can be migrated vs. kept.

3. **Investigate custom_lint crash** — the `missing_translation_key` rule crashes the analysis server (sync dart:io reads). Still disabled in `analysis_options.yaml`.

### Medium Priority
4. **Fix remaining translation key issues** — the `WAITING:` keys show warnings on fresh start due to easy_localization caching. Verify all keys load correctly after `flutter clean`.

5. **Improve spectator experience** — `InGameDisplay` shows a basic text message for spectators. Could show a read-only game board.

6. **Add `noAuth` / `emuMode` properly** — `testMode` env var in `launch.json` is unused. Should map to `noAuth` or be removed. `emulatorAddress` is defined but not passed to `initialize()`.

### Low Priority
7. **Paginated game lists** — join_game_screen and game_list_screen use basic `YustDocsBuilder` with limit.
8. **Player offline heartbeat** — write timestamp every 2 minutes, show offline after 3 minutes.
9. **Major dependency upgrades deferred** — source_gen 4.x still uses old analyzer element API; analyzer pinned to `<10.0.0`.
10. **Update `index.html`** — Flutter web deprecation warnings about serviceWorkerVersion and FlutterLoader.loadEntrypoint.
