---
date: 2026-04-01T19:01:07Z
git_commit: 45c1291
branch: main
repository: flutter_game_framework
topic: "Warigin Deep Refactor — Bug Fixes, Deduplication, Tests"
tags: [warigin, migration, bug-fixes, testing, deduplication, refactoring]
last_updated: 2026-04-01
---

# Handoff: main — Warigin deep refactor after framework migration

## Context

Following the Warigin → flutter_game_framework migration (previous handoff: `2026-04-01_18-30-25_warigin-framework-migration.md`), this session completed four deferred migration tasks and then performed a deep codebase analysis that uncovered 14 bugs, 14 duplicate files, 4 dead files, and critical design issues. All were addressed across 5 phases.

**Repos:**
- Framework: `/Users/clnif/Documents/Repos/flutter_game_framework` — HEAD: `45c1291`
- Warigin: `/Users/clnif/Documents/Repos/Warigin` — HEAD: `b4caec2`
- Tricking Bees: `/Users/clnif/Documents/Repos/trickgame/tricking_bees_flutter` — HEAD: `a5fa317`

## Tasks

### Completed — Migration follow-ups (first half of session)

1. **Migrate LogEntry/LogEntryType to framework base classes** — Created `WGLogEntryType` class with 18 static const `LogEntryType` values. Updated all 18 concrete log entries to extend framework's `LogEntry`. Deleted Warigin's parallel `log_entry.dart` and `log_entry_type.dart`. Framework changes: `showEventDisplay` signature updated to `Future<void>` with 4 params (`imagePath`, `colorCode`); `initialize()` changed to `insertAll(0, ...)` for game type priority. TB's `LogTrickWon` updated to match.

2. **Rename Player → WGPlayer** — Class renamed in `player_id.dart`, all references updated across 9 files + 1 test. Framework's `Player` added to barrel re-export. Codegen regenerated.

3. **Abstract GameEventHandler → WGGameEventHandler** — Renamed to `WGGameEventHandler extends gf.GameEventHandler` with `covariant WGGame` parameters. Updated `RoundEvent`, `GameCard`, `game_event_handling.dart`, `overlaid_action_icon.dart`.

4. **End-to-end lifecycle testing** — 31 tests covering creation → joining → bidding → card selection → hero selection → state transitions → JSON round-trips → log entry registration. Uses `TestWGGame` with no-op `save()`.

### Completed — Deep refactor (second half of session)

5. **Phase 1: Critical bug fixes (7 fixes)**
   - `activeCards = const []` → mutable `[]` (`game.dart:60`)
   - Early return after `_handleWin` in `moveUnit` (`game_unit_movement.dart:10-13`)
   - `getPlayer` spectator fallback (`game.dart:544-547`)
   - Deep copy `initialCards` inner lists (`game.dart:87`)
   - `heroesLeftToSet` spectator guard (`game_status_generation.dart:71-72`)
   - `commitHeroSelection` flag + double-save fix (`game_hero_selection.dart:34-42`)
   - `wgGameState = notRunning` in `_handleWin` (`game_unit_movement.dart:46`)

6. **Phase 2: Delete duplicates + dead code (14 files removed)**
   - wg_core: `app_config.dart`, `env_variables.dart` deleted; `custom_types.dart` pruned to `TurnNumber` only
   - warigin UI: 6 exact copies deleted (custom_icons, game_id_formatter, ui_helper, shared_preferences_helper, app_gradients, own_clipped_asset_rect)
   - Dead: `player_cards_row_old.dart`, `fight_log_display.dart` deleted

7. **Phase 3: Medium bug fixes (6 fixes)**
   - `sort: true` returns copy instead of mutating stored lists (`game.dart:679,711,718`)
   - "Players needed" counts non-placeholder players (`game_status_generation.dart:23-25`)
   - `nextPlayer` recursion depth limit (`game.dart:393`)
   - `mounted` check in `InGameDisplay` (`in_game_display.dart:228`)
   - `hasClients` check ordering (`log_entry_list_display.dart:79`)
   - Dev buttons guarded behind `noAuth` (`waiting_display.dart:24,29`)

8. **Phase 4: Test coverage (57 new tests)**
   - `models_test.dart`: 39 tests — Faction, CellType, Board, Unit, UnitDiceRoll, PlayerStatusInfo
   - `game_in_progress_test.dart`: 18 tests — setCorrectInputRequirement, nextPlayer, recursion safety, win conditions, getStatusMessages, deep copy, sort safety

9. **Phase 5: Design improvements**
   - Fixed critical `getStatusMessages` shadow bug — extension method was invisible because base `Game` class defines an instance method with the same name. Moved to `@override` on `WGGame` (`game.dart:263-278`). Private helpers remain in extension in `game_status_generation.dart`.

### NOT done (deferred for future session)

- **Extend `GameScreenBase`/`WaitingDisplayBase`** — Warigin's `GameScreen` and `WaitingDisplay` reimplement framework base classes. Requires UI restructuring.
- **Use framework's `LogEntryListDisplay` with callback** — Warigin reimplements the framework's log display with fight-report baked in. Framework provides `buildExtraEntryContent` callback for this.
- **Extract combat resolution from `Board`** — `Board._moveUnitWithAttack` mutates `WGGame` bidirectionally. Should be moved to game layer.
- **`PlayerInstructionsRow`** and **`context_extension.dart`** reimplementations — ~80% shared with framework, diverge on `onEnter`/`onExit` hover callbacks for coordinate highlighting.
- **Round event and card effect tests** — All 12 cards and 10 events have zero test coverage.
- **Fix pre-existing `game_test.dart` failures** — `addUser` test calls `save()` without mock; `getLogEntries` test expects `[]` but gets `{}`.

## Critical References

- Previous handoff: `knowledge/local/scratch/handoffs/main/2026-04-01_18-30-25_warigin-framework-migration.md`
- Plan: `~/.claude/plans/witty-mixing-bachman.md`
- CLAUDE.md at framework root

## Recent Changes

### Framework (committed: `45c1291`)
- `flutter_game_framework_core/lib/src/models/logging/log_entry.dart` — `showEventDisplay` signature: `Future<void>`, 4-param callback
- `flutter_game_framework_ui/lib/src/initialization.dart` — `insertAll(0, ...)` for game type priority

### Tricking Bees (committed: `a5fa317`)
- `packages/tb_core/lib/src/models/game/logging/turn_start.dart` — `showEventDisplay` 4-param callback

### Warigin (committed: `b4caec2`)
**New files:**
- `packages/wg_core/lib/src/models/game/logging/wg_log_entry_type.dart` — 18 static const LogEntryType values
- `packages/wg_core/test/game_lifecycle_test.dart` — 31 lifecycle tests
- `packages/wg_core/test/models_test.dart` — 39 model tests
- `packages/wg_core/test/game_in_progress_test.dart` — 18 in-progress phase tests

**Deleted files (14):**
- `packages/wg_core/lib/src/models/game/logging/log_entry.dart`
- `packages/wg_core/lib/src/models/game/logging/log_entry_type.dart`
- `packages/wg_core/lib/src/util/app_config.dart`
- `packages/wg_core/lib/src/util/env_variables.dart`
- `packages/warigin/lib/util/app_gradients.dart`
- `packages/warigin/lib/util/game_id_formatter.dart`
- `packages/warigin/lib/util/ui_helper.dart`
- `packages/warigin/lib/util/shared_preferences_helper.dart`
- `packages/warigin/lib/widgets/custom_icons.dart`
- `packages/warigin/lib/widgets/own_clipped_asset_rect.dart`
- `packages/warigin/lib/widgets/in_game/player_information/player_cards_row_old.dart`
- `packages/warigin/lib/widgets/in_game/fight_log_display.dart`

**Heavily modified:**
- `packages/wg_core/lib/src/models/game/game.dart` — B1-B5 fixes, `getStatusMessages` override, `nextPlayer` depth param, `activeCards`/`heroesLeftToSet` constructor changes, deep copy, sort safety, `getPlayer`/`soloPlayerId` safety
- `packages/wg_core/lib/src/models/game/game_unit_movement.dart` — B2 early return after win, B7 wgGameState sync
- `packages/wg_core/lib/src/models/game/game_hero_selection.dart` — B6 flag/double-save fix
- `packages/wg_core/lib/src/models/game/game_status_generation.dart` — B5 spectator guard, B9 players-needed fix, getStatusMessages moved to class body
- `packages/wg_core/lib/src/models/game_event_handler.dart` — WGGameEventHandler extends gf.GameEventHandler
- `packages/wg_core/lib/src/models/player_id.dart` — Player → WGPlayer
- `packages/wg_core/lib/wg_core.dart` — barrel updated with framework re-exports
- All 18 concrete log entry files — migrated to framework LogEntry
- `packages/warigin/lib/main.dart` — `additionalLogTypes: WGLogEntryType.values`
- `packages/warigin/lib/screens/game_display/in_game_display.dart` — B11 mounted check
- `packages/warigin/lib/screens/game_display/waiting_display.dart` — noAuth guard
- `packages/warigin/lib/widgets/in_game/log_entry_list_display.dart` — B12 hasClients fix

## Learnings

### `getStatusMessages` extension shadow bug
The framework's `Game` base class defines `getStatusMessages` as an instance method returning `[]`. Warigin's `game_status_generation.dart` defined it as an extension method on `WGGame`. In Dart, instance methods always beat extension methods — so the Warigin implementation was never called through normal dispatch. The UI showed empty status messages. Fix: move to `@override` on `WGGame` class body (`game.dart:263-278`), keep private helpers in extension.

### `const` default parameter lists are unmodifiable
`const []` and `const [3, 3, 3]` as default parameter values create compile-time constant objects that throw `UnsupportedError` when mutated. This only manifests when the object is used without a JSON round-trip (which creates new mutable instances). Fix: use nullable params with `??` in initializer list.

### `Map.from()` creates shallow copies
`Map<int, List<CardCatalog>>.from(initialCards)` copies map entries but NOT the inner lists. `remainingCards[0]` and `initialCards[0]` are the same `List` object. Fix: `initialCards.map((k, v) => MapEntry(k, List<CardCatalog>.from(v)))`.

### Execution continues after state-setting methods
`_handleWin` sets `gameState = finished` but doesn't return/throw. Callers must check `gameState` after calling it and return early if the game ended.

### Yust mock doesn't work in Flutter test environment
`Yust.mocked(forUI: false)` throws `UnsupportedError: Not supported in Flutter Environment` when used with `flutter test`. The subclass-override pattern (override `save()` in a `TestWGGame`) is the correct approach for testing without Firestore.

## Next Steps

### High Priority
1. **Extend `GameScreenBase`/`WaitingDisplayBase`** — deduplicate game screen scaffolding
3. **Use framework `LogEntryListDisplay` with callback** — pass fight-report via `buildExtraEntryContent`
4. **Round event tests** — Poison, Plague, Veteran, Necromancy, Rebirth, BurningWall (all zero coverage)

### Medium Priority
5. **Card effect tests** — Truce, Swamp, Pathfinder, Confusion, Avatar (complex state machines)
6. **Extract combat from Board** — move `_moveUnitWithAttack` logic to game layer
7. **Fix `game_test.dart`** — update old tests to use `TestWGGame` pattern
8. **`PlayerInstructionsRow`/`context_extension.dart`** — investigate using framework's base with hover callback

### Low Priority
9. **Investigate generated `WGGameSave.save()` shadow** — `game.service.dart` generates a `save()` extension that is shadowed by the class method
10. **`Faction.fromJson/toJson` case mismatch** — `toJson()` returns lowercase but `fromJson` matches capitalized `name`
