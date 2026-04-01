# Univelop Code Review Rules

This document defines the internal review rules for the Univelop codebase.
Claude Code uses these rules to review changes and provide actionable feedback.

---

## Rule 1: New External Packages Require Approval

**Severity:** Blocker
**Approver:** Jannis Rosenbaum

Any new external package added to a `pubspec.yaml` must be approved by Jannis Rosenbaum before merging.

### What to check:
- Compare `pubspec.yaml` changes against master — any new `dependencies` or `dev_dependencies` entry that was not present before is a new package.
- Git dependencies, path dependencies to new packages, and pub.dev dependencies all count.
- Version bumps of existing packages do NOT count as new packages.

### Review output:
- List each new package with its source (pub.dev, git, path).
- State: "New package requires approval by Jannis Rosenbaum."

---

## Rule 2: Business Logic and UI Separation

**Severity:** Error

Business logic must live in `uni_core`. The `univelop` package is strictly for UI/presentation.

### What belongs in `uni_core`:
- Data models (YustDoc subclasses)
- Services (@GenerateService)
- Expression evaluation logic
- Filtering, sorting, validation logic
- Workflow execution engine
- Brick value computation (getMainValue, getValueNew)
- Any function that processes, transforms, or decides on data

### What belongs in `univelop`:
- Widgets and Screens (ConsumerWidget, StatelessWidget, StatefulWidget)
- Widget-specific state (TextEditingController, FocusNode, animation state)
- Navigation (GoRouter routes, guards)
- Dialogs, bottom sheets, snackbars
- Theme, styles, layout helpers
- Calling services/logic from uni_core and rendering the result

### What to check:
- New or modified `.dart` files in `packages/univelop/lib/` must NOT contain:
  - Database queries (Yust.databaseService calls, YustDocSetup usage outside of providers)
  - Complex data transformations or business rules
  - Filter/sort logic beyond simple UI state
  - Validation rules (beyond form-field-level UI validation)
  - Expression evaluation
  - Workflow step execution
- New or modified `.dart` files in `packages/uni_core/lib/` must NOT contain:
  - Flutter imports (`package:flutter/material.dart`, `package:flutter/widgets.dart`)
  - Widget classes
  - BuildContext usage
  - UI-specific code (showDialog, Navigator, ScaffoldMessenger)

### Review output:
- Flag each violation with file path, line number, and what should be moved where.

---

## Rule 3: Data Structure Changes Require Approval

**Severity:** Blocker
**Approver:** Jannis Rosenbaum

Any change to a YustDoc model's data structure must be approved by Jannis Rosenbaum.

### What counts as a data structure change:
- Creating a new class that extends `YustDoc`
- Adding, removing, or renaming a field/property in a YustDoc subclass
- Changing the type of an existing field
- Modifying `toJson()` / `fromJson()` serialization behavior
- Adding or modifying `@JsonKey` annotations
- Changing `@GenerateService()` parameters (e.g., adding `updateMask`)
- Adding or modifying `YustDocSetup` configuration (e.g., `onInit`, `onMigrate`)

### What does NOT count:
- Adding methods that do not affect stored data
- Adding computed getters that derive from existing fields
- Refactoring internal logic without changing the persisted shape

### What to check:
- Look for changes in files matching `**/models/*.dart` within `uni_core`
- Check if any YustDoc subclass has new/removed/changed fields
- Check for new files containing `extends YustDoc`

### Review output:
- List each affected model and what changed (new field, removed field, type change).
- State: "Data structure change requires approval by Jannis Rosenbaum."

---

## Rule 4: New Bricks Must Be AI Ready

**Severity:** Error

Every new brick must be AI ready from the start. This means all configurable settings must be declared in the `BrickCatalogItem`.

### Requirements for AI readiness:

1. **`enabledForAiAgent: true`** must be set on the `BrickCatalogItem`.
2. **`aiDescription`** must be set on the `BrickCatalogItem` — a short description of what the brick does.
3. **All settings** must be listed in the `settings` list of `BrickCatalogItem` as `CatalogSetting` entries.
4. **Each `CatalogSetting`** must have an `aiDescription` explaining what the setting controls.
5. **No setting should have `disabledForAiAgent: true`** unless there is a documented technical reason.
6. **Standard settings** should be included where applicable:
   - `CatalogSetting.iconSetting()`
   - `CatalogSetting.aiDescription()`
   - `CatalogSetting.tooltipSetting()`
   - `CatalogSetting.mandatorySetting()`
   - `CatalogSetting.brickVisibleAndEditableSettings()`

### What to check:
- Any new file defining a `BrickCatalogItem` (typically `static final catalogItem = BrickCatalogItem(...)`)
- Verify all six requirements above are met
- Compare settings in the BrickCatalogItem against all settings constants/enums defined in the brick's settings class

### Review output:
- List missing settings, missing AI descriptions, or missing `enabledForAiAgent` flag.
- Provide a concrete suggestion for what to add.

---

## Rule 5: New Bricks Must Follow the MultiValue Principle

**Severity:** Error

Every new brick must expose its data through the MultiValue pattern defined in `BrickCatalogItem.values`.

### Requirements:

1. **`values` list** must be defined in the `BrickCatalogItem`.
2. **A `main` value** must always be present as the first entry.
3. **All accessible sub-values** must be declared as separate `BrickCatalogValue` entries with appropriate:
   - `key` — unique identifier (e.g., `'street'`, `'start'`, `'total'`)
   - `dataType` — correct `UniDataType`
   - `pathToValue` — correct path function
   - `isFilterable` — set to `true` if the value should be filterable
   - `isMainFilterValue` — set on the value that should be the default filter target
4. **`getValueNew()`** must be implemented in the brick class to handle all declared value keys.

### Good examples to follow:
- `AddressBrick` — exposes `main`, `street`, `number`, `postcode`, `city`, `country`
- `TimeSpanBrick` — exposes `main`, `start`, `end`, `break_time`, `total_duration`
- `RecordPickerBrick` — exposes `main`, `title`, `id`

### What to check:
- New brick classes that define a `BrickCatalogItem`
- Verify `values` list is present and follows the pattern
- Check that `getValueNew()` handles all declared keys
- Verify `main` value is always included

### Review output:
- Flag if `values` is missing or incomplete.
- Suggest which sub-values should be exposed based on the brick's data structure.

---

## Rule 6: Public Interface Documentation

**Severity:** Warning

All public interfaces must be documented with `///` doc comments. This applies to every new or modified public API surface.

### What must be documented:

1. **Every class** — what it represents and its purpose
2. **Every public method** — what it does, not how it does it
3. **Every public property/field** — what it holds
4. **Every enum and its values** — what each value means
5. **Factory constructors** — when to use them
6. **Typedefs and extensions** — what they add

### Documentation style:
- Use `///` (not `//` or `/* */`)
- Write in English
- First line: brief summary (one sentence)
- Optional: detailed description on subsequent lines after a blank `///` line
- Use `[ClassName]` or `[methodName]` for cross-references
- Document exceptions with "Throws [ExceptionType] if..."
- Document return values for non-obvious types

### Good example:
```dart
/// A BillingAccount is assigned to users in a workspace.
///
/// It manages the Stripe subscription and payment information
/// for a workspace's billing setup.
class BillingAccount extends YustDoc {
  /// The display name of the billing account holder.
  final String name;

  /// Creates a new billing account with default settings.
  ///
  /// Throws [UniException] if the workspace already has an account.
  factory BillingAccount.create(String workspaceId) => ...
}
```

### What to check:
- All new classes, methods, properties, and enums in the diff
- Modified classes where new public members were added
- Private members do NOT require documentation (but it is encouraged for complex ones)

### Review output:
- List each undocumented public member with file path and line number.
- Do NOT flag members that already existed and were not modified in this change.

---

## Review Output Format

Structure the review as follows:

### 1. Summary
A brief overall assessment (1-2 sentences).

### 2. Blockers (must be resolved before merge)
Items from rules with severity "Blocker". These require explicit approval.

### 3. Errors (must be fixed)
Items from rules with severity "Error". These are violations of coding standards.

### 4. Warnings (should be fixed)
Items from rules with severity "Warning". These improve code quality.

### 5. Suggestions (optional improvements)
Additional observations that are not rule violations but could improve the code.

For each finding, provide:
- **Rule:** Which rule is violated
- **File:** File path and line number
- **Issue:** What is wrong
- **Fix:** Concrete suggestion for how to fix it
