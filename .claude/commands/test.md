---
description: Runs melos ci. Reports failures. Suggests missing coverage.
---

# Test

Run the full CI suite and optionally test in the running app.

## Process

### 1. Run CI

```bash
melos run ci
```

Use a timeout of up to 10 minutes.

### 2. Report results

**If all checks pass:** Confirm success with a brief summary.

**If there are failures:** List each failure with:
- Package name
- Test/lint/analysis that failed
- Error message
- File path and line number

Group by type: errors first, then warnings.

### 3. Suggest fixes

For each failure, suggest a concrete fix:
- Lint errors: the code change needed
- Test failures: expected vs actual
- Analysis errors: the issue and resolution

### 4. Check coverage

Find files modified on this branch:

```bash
git diff master...HEAD --name-only --diff-filter=AM
```

For new or modified files:
- Check if corresponding test files exist
- Flag new public methods or classes without tests
- Suggest what tests to add

### 5. App testing (if UI changes detected)

If modified files include screens, widgets, brick UIs, or tile UIs, offer to test in the running app:

1. **Prepare:** Look up relevant translated strings from `packages/uni_core/assets/translations/en.jsonc` and `ValueKey`s from the changed widget files. Note the exact text and keys needed for navigation.
2. **Launch:** Use `mcp__dart-mcp-server__list_devices`, then `mcp__dart-mcp-server__launch_app` (root: `packages/univelop`). If already running, connect to the existing instance.
3. **Connect:** Use `mcp__dart-mcp-server__connect_dart_tooling_daemon` with the DTD URI and `mcp__marionette__connect` with the VM service URI.
4. **Navigate:** Use `mcp__marionette__get_interactive_elements` to see available elements. Tap through the app using translated text or ValueKeys to reach the changed screens.
5. **Verify:** Take screenshots with `mcp__marionette__take_screenshots`. Check for runtime errors with `mcp__dart-mcp-server__get_runtime_errors`.
6. **Report:** Include screenshots and any issues found in the test report.

Do not fix issues automatically unless asked.
