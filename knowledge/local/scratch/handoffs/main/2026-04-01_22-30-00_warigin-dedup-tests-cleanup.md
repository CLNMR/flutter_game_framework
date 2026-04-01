---
date: 2026-04-01T22:30:00Z
git_commit: 8e03454
branch: main
repository: flutter_game_framework
topic: "Warigin Dedup, Full Test Coverage, and Cleanup"
tags: [warigin, deduplication, testing, cleanup, framework-enhancements]
last_updated: 2026-04-01
---

# Handoff: main — Warigin dedup, full test coverage, and cleanup

## Context

This session resumed from the deep refactor handoff (`2026-04-01_19-01-07_warigin-deep-refactor.md`) and completed all 6 deferred items from that handoff's "NOT done" section, plus 3 additional low-priority items that were identified but not yet addressed. The codebase went from 88 tests (2 failing) to 168 tests (0 failing).

**Repos:**
- Framework: `/Users/clnif/Documents/Repos/flutter_game_framework` — HEAD: `8e03454`
- Warigin: `/Users/clnif/Documents/Repos/Warigin` — HEAD: `131d148`
- Tricking Bees: `/Users/clnif/Documents/Repos/trickgame/tricking_bees_flutter` — unchanged

## Tasks Completed

### 1. Extend GameScreenBase / WaitingDisplayBase

**Framework:** Made `_debugStateButtons()` a public virtual `buildDebugActions()` on `GameScreenBaseState`.

**Warigin:** `GameScreen` now extends `GameScreenBase<WGGame>`, overriding `buildForState` for the state dispatch and `buildDebugActions` for WGGameState-specific debug buttons. `WaitingDisplay` replaced by `WaitingDisplayBase` used directly in `buildForState` with `onAddDevPlayer` callback.

**Files:**
- Framework: `game_screen_base.dart` — `buildDebugActions()` virtual method
- Warigin: `game_screen.dart` — rewritten to extend base
- Warigin: `waiting_display.dart` — **pending deletion** (see DELETE_THESE.md)

### 2. Use framework LogEntryListDisplay with buildExtraEntryContent

Replaced Warigin's custom `LogEntryListDisplay` with the framework's version. Fight report rendering extracted to `fight_report.dart`. Log entries flattened at the call site via `_flattenLogEntries`. Warigin's translation keys passed via `buildHeaderForRound` and `headerTranslationKey`. Later in the session, `buildEntryTextSpan` callback added to restore `onEnter`/`onExit` coordinate hover highlighting.

**Files:**
- Warigin: `fight_report.dart` — **new**, extracted fight report widgets
- Warigin: `in_game_display.dart` — uses framework `LogEntryListDisplay` with all callbacks
- Warigin: `log_entry_list_display.dart` — **pending deletion** (see DELETE_THESE.md)

### 3. Fix pre-existing game_test.dart failures

- `addUser` test: replaced `WGGame()` with `TestWGGame`, set user IDs, check by ID set instead of object equality (random placement order)
- `getLogEntries` test: changed `expect(logEntries, [])` to `expect(logEntries, isEmpty)` since `getLogEntries` returns a `Map`, not a `List`

### 4. Extract combat resolution from Board to game layer

Moved `_moveUnitWithAttack` and `tryMoveUnit` from `Board` to `WGGame` in `game_unit_movement.dart`. Board now only has `moveUnitBetweenCells(fromCell, toCell, currentRound)` — a pure cell operation with no game-logic side effects. The game layer handles validation, logging, dice rolls, combat resolution, and `destroyUnit` calls.

**Files:**
- Warigin: `board.dart` — removed `tryMoveUnit`, `_moveUnit`, `_moveUnitWithAttack`; added `moveUnitBetweenCells`; removed unused imports
- Warigin: `game_unit_movement.dart` — added `_tryMoveUnit`, `_resolveCombat`

### 5. Deduplicate PlayerInstructionsRow and context_extension

**Framework:**
- Fixed `getSpans` self-assignment bug in `initialization.dart` — the parameter `getSpans` shadowed the module-level variable. Renamed to `spanBuilder`, added `BuildContext` to callback signature.
- Added `decoration`, `textAlign`, `padding` params to `PlayerInstructionsRow`.
- Added `buildEntryTextSpan` callback to `LogEntryListDisplay`.

**Warigin:**
- Replaced `PlayerInstructionsRow` with framework version, passing Warigin's visual style (border, center align, padding).
- Wired `_buildCardOrEventSpans` via framework's `spanBuilder` hook in `main.dart`.
- Removed `_getCardOrEventSpans` from `context_extension.dart`; now uses framework `getSpans` hook.
- Renamed extension `UiRichTrObject` → `WGUiRichTrObject` to avoid ambiguity with framework extension.
- Kept Warigin's `context_extension.dart` for `onEnter`/`onExit` hover support.

**Files:**
- Framework: `initialization.dart` — `spanBuilder` param, fixed self-assignment
- Framework: `context_extension.dart` — passes `BuildContext` to `getSpans`
- Framework: `player_instructions_row.dart` — `decoration`, `textAlign`, `padding` params
- Warigin: `main.dart` — `spanBuilder: _buildCardOrEventSpans`
- Warigin: `context_extension.dart` — removed `_getCardOrEventSpans`, renamed extension
- Warigin: `rich_tr_object_extension.dart` — renamed to `WGUiRichTrObject`
- Warigin: `player_instructions_row.dart` — **pending deletion** (see DELETE_THESE.md)

### 6. Round event tests (30 tests)

Tests for Poison (5), Plague (4), Veteran (5), Necromancy (3), Rebirth (4), BurningWall (5), event interactions (1). Uses `TestWGGame` + `createInProgressGame()` from `game_in_progress_test.dart`. Checks outcomes (inputRequirement, unit counts, unit types) instead of flags (due to `FieldValue.delete()` test environment limitation).

**File:** `packages/wg_core/test/round_event_test.dart`

### 7. Card effect tests (46 tests)

Tests for all 12 cards: Avatar (5), Confusion (5), Truce (3), LightningStrike (4), Guerrilla (3), Corruption (3), FierySpeech (4), Prophecy (3), Rebels (4), Marauder (4), Pathfinder (3), Swamp (5). Covers normal play, edge case rejections, and elite effects.

**File:** `packages/wg_core/test/card_effect_test.dart`

### 8. Fix generated save() extension shadow

Added `skipSaveExtension` flag to `@GenerateService` annotation. When true, the generator skips emitting the save/update/delete extension (which was dead code when the class defines its own `save()` override). Used on `WGGame`. Regenerated `game.service.dart`.

**Files:**
- Framework: `generate_service.dart` — added `skipSaveExtension` field
- Framework: `service_generator.dart` — conditional extension generation
- Warigin: `game.dart` — `@gf.GenerateService(skipSaveExtension: true)`
- Warigin: `game.service.dart` — regenerated, `WGGameSave` extension removed

### 9. Fix Faction.fromJson/toJson case mismatch

`toJson()` returns lowercase (`"heaven"`) but `fromJson()` compared against `name` (capitalized `"Heaven"`). Fixed by making `fromJson` compare case-insensitively.

**File:** `packages/wg_core/lib/src/models/faction.dart`

## Pending Cleanup

`DELETE_THESE.md` in the Warigin root lists 3 files to delete manually (sandbox blocked `rm`):
```
rm packages/warigin/lib/screens/game_display/waiting_display.dart \
   packages/warigin/lib/widgets/in_game/log_entry_list_display.dart \
   packages/warigin/lib/widgets/in_game/player_information/player_instructions_row.dart
```
Then: `git add -u && git commit --amend --no-edit`

## Test Summary

| Test file | Count | Status |
|---|---|---|
| `game_test.dart` | 2 | All pass (were 2 failing) |
| `other_functions_test.dart` | 2 | All pass |
| `models_test.dart` | 39 | All pass |
| `game_lifecycle_test.dart` | 31 | All pass |
| `game_in_progress_test.dart` | 18 | All pass |
| `round_event_test.dart` | 30 | All pass (new) |
| `card_effect_test.dart` | 46 | All pass (new) |
| **Total** | **168** | **0 failures** |

## Learnings

### `FieldValue.delete()` in test environment
`deleteFlag` sets `flags[key] = FieldValue.delete()` — a Firestore sentinel. In tests (where `save()` is a no-op), the key persists in the map with this sentinel value. `checkForFlag(key)` returns `true` and `getFlagList(key)` throws. Fix: check outcomes (inputRequirement, unit counts) instead of flags.

### Extension name conflicts across packages
When both the framework and Warigin define `extension UiRichTrObject on RichTrObject`, importing both causes `ambiguous_extension_member_access`. Fix: rename one extension (Warigin → `WGUiRichTrObject`) or use `import ... hide`.

### `getSpans` parameter shadowing
The framework's `initialize(getSpans: ...)` parameter shadowed the module-level `getSpans` variable, causing `getSpans = getSpans` to be a self-assignment no-op. The `spanBuilder` hook was never stored. Fix: rename the parameter.

### Board shouldn't drive game state
`Board._moveUnitWithAttack` was calling `game.addLogEntry`, `game.destroyUnit`, reading `game.currentRound` — an inversion of control where the data model drove game logic. After extraction, Board only exposes `moveUnitBetweenCells(fromCell, toCell, currentRound)` and `getReachableCells(coord, game)`. Combat resolution lives on `WGGame._resolveCombat`.

## Next Steps

All items from the previous handoff's "NOT done" section are complete. Remaining work that could be done in future sessions:

### Improvements
1. **Investigate `Faction.name` property** — `name` getter shadows the enum's built-in `name` property with `.capitalize()`. This is fragile — consider using a separate `displayName` getter.
2. **Stateful expansion tracking in LogEntryListDisplay** — Warigin's old widget tracked user expansion toggles in `expandedState: Map<int, bool>`. The framework's widget resets expansion on every rebuild. Could add a stateful variant.
3. **`Crusade` and `SwordsIntoPlowshares` event tests** — These two events have no tests yet (they were not in the original "zero coverage" list since they're simpler, but coverage would be valuable).

### Technical Debt
4. **Remove `DELETE_THESE.md`** — After deleting the 3 listed files.
5. **`context_extension.dart` full dedup** — Warigin still has its own version for `onEnter`/`onExit`. If the framework's `trFromObjectToTextSpan` were extended with optional hover callbacks, Warigin's copy could be eliminated entirely.
6. **`WGPlayer` equality** — Neither `Player` nor `WGPlayer` has `==`/`hashCode`. Tests work around this by comparing IDs.
