---
name: translation
description: "Use when adding or editing user-facing strings. Covers .jsonc source files, LocaleKeys, .tr(), .trObj(), .plural(), and generation."
---

# Translation

Source strings live in `.jsonc` files. A build script generates `locale_keys.g.dart` and `translations.g.dart`. At runtime, `.tr()` resolves keys via `UniTranslator`.

## Source files

```
packages/uni_core/assets/translations/en.jsonc
packages/uni_core/assets/translations/de.jsonc
```

Both files are flat JSON with comment lines at the top. The generator sorts all keys alphabetically on each run.

## .jsonc syntax

### Simple string

```jsonc
"abortCondition": "Abort condition",
```

### Named arguments — `{argName}` placeholders

```jsonc
"abortingBecauseStartedWorkflowCrashed": "The started workflow \"{flowSpecLabel}\" failed with the following error: {error}",
```

### Positional arguments — `{}` placeholders

```jsonc
"limitReachedForRecords": "Limit reached for records ({})",
```

### Plural form — nested object with `one` and `other`

```jsonc
"accessLimitedConditionPlural": {
    "one": "Access limited ({} condition)",
    "other": "Access limited ({} conditions)"
},
```

Supported plural sub-keys: `zero`, `one`, `two`, `few`, `many`, `other`, `male`, `female`.

### Link syntax — `@:otherKey` embeds another key's translation

```jsonc
"aiAgentStepDescription": "The step @:aiAgentStep allows to send a request to an AiAgent.",
```

Case modifiers: `@.upper:key`, `@.lower:key`, `@.capitalize:key`.

## Generated files

| File | Contains |
|------|----------|
| `packages/uni_core/lib/src/basic/generated/locale_keys.g.dart` | `abstract class LocaleKeys` with `static const String` per key |
| `packages/uni_core/lib/src/basic/generated/translations.g.dart` | `class Translations` with `static const Map<String, dynamic>` per locale |

```dart
// locale_keys.g.dart
abstract class LocaleKeys {
  static const abortCondition = 'abortCondition';
  static const accessLimitedConditionPlural = 'accessLimitedConditionPlural';
  // ...
}
```

## Usage patterns

### `.tr()` — immediate translation

Returns the translated string for the current locale.

```dart
// Simple
LocaleKeys.abortCondition.tr()

// With named arguments
LocaleKeys.flowLogErrorRetrievingEmails.tr(
  namedArgs: {'email': email},
)

// With locale override
LocaleKeys.approvalRequest.tr(
  localeOverride: UniTranslator.defaultLocale,
  namedArgs: {'recordTitle': record.title},
)

// With positional arguments
someKey.tr(args: ['value1', 'value2'])
```

### `.trObj()` — deferred translation

Returns a `UniTranslation` object. Translation happens later when `.tr()` is called on the object. Use when key + args need to be stored or passed before rendering.

```dart
// In exceptions — preferred over UniTranslation() constructor
throw UniException(
  'Cannot delete referenced roles.',
  uniTranslation: LocaleKeys.exceptionCannotDeleteReferencedRole.trObj(
    namedArgs: {'roleReferences': roleReferences.join('\n')},
  ),
);
```

Direct `UniTranslation()` construction is used in backend code where `.trObj()` is unavailable or `const` is required:

```dart
uniTranslation: const UniTranslation(LocaleKeys.saveStripeSubscriptionItemError),
```

Prefer `.trObj()` over `UniTranslation()` per CLAUDE.md.

### `.plural()` — pluralisation

Requires a `value` argument (the count). Selects `one` or `other` sub-key.

```dart
// Standard usage
LocaleKeys.flowLogRecordsFoundPlural.plural(value: numberRecords)

// Embedded in named args
LocaleKeys.flowLogImportedRowsColumns.tr(namedArgs: {
  'rows': LocaleKeys.rowPlural.plural(value: numberRows),
  'columns': LocaleKeys.columnPlural.plural(value: numberColumns),
})

// Inline
'$startString - $endString ($daysCount ${LocaleKeys.day.plural(value: daysCount)})'
```

Without `value`, defaults to `value: 2` (returns the `other` form).

## UniTranslator utilities

For data that must be stored or matched in all supported languages:

```dart
// All translations as list: ['Yes', 'Ja']
UniTranslator.getTranslations(LocaleKeys.yes)

// Lowercased for matching: ['yes', 'ja']
UniTranslator.getTranslationsLowerCase(LocaleKeys.yes)

// Locale-to-string map: {'de': 'Ja', 'en': 'Yes'}
UniTranslator.getTranslationsMap(LocaleKeys.toDos)

// Check if any locale matches
UniTranslator.keyContainsTranslation(key, translation)
```

## Locale state

```dart
UniTranslator.locale             // current active locale
UniTranslator.defaultLocale      // workspace default
UniTranslator.supportedLocales   // workspace-configured list
```

## Adding new strings

1. Add the key to both `en.jsonc` and `de.jsonc` (same key name, translated values).
2. Run `melos run generate_translations`.
3. Use `LocaleKeys.yourKey.tr()` in code.

The generator validates that every key exists in all locale files. Missing keys cause a build error.

Keys must be added to both files before generation. The generator sorts alphabetically, so insertion order does not matter.

After generation, use the `analyze_files` MCP tool to verify no errors were introduced. Always prefer MCP server tools over shell equivalents.
