---
name: brick-pattern
description: "Use when creating or modifying Brick components. Covers Brick<V>, BrickCatalogItem, BrickUi, design mode, settings, and registration."
---

# Brick Pattern

Bricks are the field-type system. Domain logic lives in `uni_core` (`Brick<V>` subclass), UI lives in `univelop` (`BrickUi<B, V>` subclass). Both are registered in catalogs.

## Files to create

| File | Package | Purpose |
|------|---------|---------|
| `packages/uni_core/lib/src/{feature}/bricks/{name}_brick.dart` | uni_core | Domain class + settings constants + catalogItem |
| `packages/univelop/lib/{feature}/brick_uis/{name}_brick_ui.dart` | univelop | UI class |

## Files to modify

| File | Change |
|------|--------|
| `packages/uni_core/lib/src/bricks/util/brick_catalog.dart` | Add `{Name}Brick.catalogItem` to the `items` list |
| `packages/uni_core/lib/uni_core.dart` | Add `export 'src/{feature}/bricks/{name}_brick.dart';` |
| `packages/univelop/lib/bricks/util/brick_ui_catalog.dart` | Add `else if (brick is {Name}Brick)` branch in `createBrickUi()` |
| `packages/uni_core/lib/src/basic/util/docs_references.dart` | Add `DocsReference` enum entry |

## Domain class pattern

```dart
import 'package:uni_core/uni_core.dart';

// Settings constants — co-located in the same file
class MyBrickSettings {
  static const someSetting = 'someSetting';
}

class MyBrick extends Brick<String> {
  MyBrick({
    required super.stateSnap,
    required super.record,
    required super.brickSpecId,
  });

  static const className = 'MyBrick';

  static final catalogItem = BrickCatalogItem(
    className: MyBrick.className,
    label: LocaleKeys.myBrick,
    group: BrickCatalogGroup.input,
    iconCodePoint: 0xe649,
    createBrick: (stateSnap, record, brickSpecId) => MyBrick(
      stateSnap: stateSnap,
      record: record,
      brickSpecId: brickSpecId,
    ),
    exampleValue: 'example',
    values: [
      BrickCatalogValue(
        key: 'main',
        dataType: UniDataType.string,
        pathToValue: (brickId) => 'brickValues.$brickId',
        defaultValue: '',
      ),
    ],
    settings: [
      const CatalogSetting.iconSetting(),
      const CatalogSetting.tooltipSetting(),
      const CatalogSetting.mandatorySetting(),
      ...CatalogSetting.brickVisibleAndEditableSettings(),
    ],
  );

  // Required: return typed value for a given key
  @override
  T? getValueNew<T>(String valueKey, {bool forJson = false}) =>
      record.brickValues[brickSpecId] as T?;
}
```

### Multi-value brick (e.g. DateRange)

For bricks with sub-values, store a nested map and switch on `valueKey`:

```dart
@override
T? getValueNew<T>(String valueKey, {bool forJson = false}) {
  final data = _valueFromJson(record.brickValues[brickSpecId]);
  if (data == null) return null;
  switch (valueKey) {
    case 'main':  return (forJson ? data.toJson() : data) as T?;
    case 'start': return data.start as T?;
    case 'end':   return data.end as T?;
  }
  return null;
}
```

Declare multiple `BrickCatalogValue` entries in `values:` for each sub-key.

### Key overridable methods

| Method | When to override |
|--------|-----------------|
| `getValueNew<T>(valueKey, {forJson})` | Always (required) |
| `onInitBrick()` | Apply default settings on brick spec change |
| `onInitRecord()` | Set initial value on fresh record |
| `onSaveRecord()` | Run logic before record save |
| `getString({format})` | Custom display string for list views |
| `setValue(V? value)` | Custom write logic (usually not needed) |
| `valueToJson(V? value)` | Convert to JSON-safe form before storage |
| `importValue(technicalKeyOrName, value)` | Custom API/Excel import handling |
| `isValueValid(V? value)` | Custom mandatory validation |
| `triggerAction({withAdminRights})` | For button-type bricks |

### Reading values and settings

```dart
brick.getMainValue()                          // typed V? via getValueNew('main')
brick.getValueNew<DateTime>('start')          // sub-key access
brick.getString()                             // human-readable display
brick.getSetting<int>('noOfLines', 1)         // with default
brick.getSettingOrNull<String>('initialText') // nullable
brick.setSetting('key', value)                // write setting
```

### Feature flag gating

```dart
// In catalogItem:
isHidden: (stateSnap) => !stateSnap.isFlagEnabled(Flag.myFlag),
```

### Pool validator (limit per RecordSpec)

```dart
brickPoolValidator: (stateSnap, recordSpec) {
  final brickSpecs = recordSpec.getBrickSpecsByClass(className);
  if (brickSpecs.isNotEmpty) return LocaleKeys.brickCanOnlyBeUsedOnce.tr();
  return null;
},
```

### Mixins

- `ListBrickMixin<V>` — for `Brick<List<V>>`, adds `addValues()` and `removeValues()`
- `ExpressionBrickMixin` — for computed bricks, override `calcExpression(ExpressionHandler)`

## UI class pattern

```dart
class MyBrickUi extends BrickUi<MyBrick, String> {
  MyBrickUi(MyBrick brick, WidgetRef ref) : super(brick, ref);

  @override
  Widget buildWidget({
    Key? key,
    required BuildContext context,
    void Function(String? value)? onChanged,
    required BrickWidgetOptions options,
  }) {
    final value = brick.getMainValue();
    return YustTextField(
      key: key,
      label: options.hideLabel ? null : brick.getLabel(designMode: options.designMode),
      value: value ?? '',
      onEditingComplete: (value) =>
          brick.callFunctionIfValueChanged(value, brick, onChanged),
      enabled: onChanged != null,
      prefixIcon: buildPrefixIcon(context),
      readOnly: options.readOnly,
    );
  }

  @override
  String? description() => LocaleKeys.myBrickDescription.tr();

  @override
  DocsReference docsRef() => DocsReference.myBrick;
}
```

### Key UI methods

| Method | Required | Purpose |
|--------|----------|---------|
| `buildWidget(...)` | Yes | Main record-detail tile |
| `buildListWidget(...)` | No | List row chip (default: getString as text) |
| `buildFilterWidget(...)` | No | Filter dialog widget |
| `buildEditWidgets(...)` | No | Settings panel in design mode |
| `description()` | Yes | One-line description for brick pool |
| `docsRef()` | Yes | DocsReference enum entry |
| `getColumnDefinition(width)` | No | UniColumn for table view |

### BrickWidgetOptions flags

```dart
options.designMode   // true in drag-and-drop editor
options.readOnly     // true if brickSpec.isEditable() returns false
options.hideLabel    // true in filter/quick-add mode
options.isFilter     // true inside filter dialog
options.quickAddMode // true in quick-add preview
options.brickIsTouched // drives validation display
```

### Design mode

`BrickContainer` wraps every brick in `AbsorbPointer(absorbing: isDesignMode)` to block interaction. A `GestureDetector` at the outer level handles tap for drag-and-drop selection. Bricks can check `options.designMode` to adjust rendering.

## After creating a brick

1. Add translation keys to `en.jsonc` and `de.jsonc`, run `melos run generate_translations`.
2. Register in `BrickCatalog.items` and `BrickUiCatalog.createBrickUi()`.
3. Export from `uni_core.dart`.
4. Add `DocsReference` enum entry.
5. Use the `analyze_files` MCP tool to check for errors, `dart_format` to format, and `dart_fix` to apply fixes. Use `run_tests` MCP tool instead of `dart test`/`flutter test`.
