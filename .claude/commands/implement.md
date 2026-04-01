---
description: Executes plan phase by phase with TDD. Pauses for manual review when needed.
---

# Implement

Execute an approved implementation plan phase by phase using TDD.

## Getting Started

If a plan path was provided, read it fully. Otherwise ask for one.

Read all files mentioned in the plan. Create a task list to track progress.

## Execution

Work through one phase at a time following TDD (Red-Green-Refactor):

### Step 1: Write Tests (Red)
1. Write the tests defined in the plan for this phase.
2. Run the tests to confirm they fail — this validates the tests are actually testing something.
3. If tests pass before implementation, the tests are wrong or the feature already exists. Investigate and adjust.

### Step 2: Implement (Green)
4. Implement the changes to make the failing tests pass.
5. Run tests again to confirm they pass.
6. Fix any issues before continuing.

### Step 3: Refactor
7. Clean up the implementation while keeping all tests green.
8. Run automated verification (linting, analysis).

### Step 4: Verify and Pause
9. Check off completed items in the plan file using Edit.
10. Test in the running app (see App Testing below).
11. Pause for manual verification:

```
Phase [N] Complete — Ready for Manual Verification

TDD cycle:
- Tests written: [count] new tests
- Tests confirmed failing before implementation: yes/no
- All tests passing after implementation: yes/no

Automated checks passed:
- [List what passed]

App testing:
- [What was verified in the app, with screenshots]
- [Issues found, if any]

Please perform the manual verification steps:
- [List manual items from the plan]

Let me know when done so I can proceed to Phase [N+1].
```

If instructed to run multiple phases consecutively, only pause after the last one.

## App Testing

After automated checks pass for a phase, test the changes in the running app. This catches UI issues that static analysis misses.

### Preparation

Before interacting with the app, look up the actual UI text for buttons, labels, and navigation items you need to tap:

1. Read `packages/uni_core/assets/translations/en.jsonc` (or `de.jsonc`) to find the translated strings for relevant `LocaleKeys`.
2. Read the screen files involved in the change to find `ValueKey` strings on interactive widgets.
3. Note down the exact text and keys you will need to navigate and verify.

### Launch and connect

1. List devices with `mcp__dart-mcp-server__list_devices`.
2. Launch the app with `mcp__dart-mcp-server__launch_app` (root: `packages/univelop`, device: pick chrome or an available device).
3. Connect to the app with `mcp__dart-mcp-server__connect_dart_tooling_daemon` using the returned DTD URI.
4. Also connect marionette with `mcp__marionette__connect` using the VM service URI.

If the app is already running (`mcp__dart-mcp-server__list_running_apps` returns results), skip launching and connect to the existing instance. After code changes, use `mcp__marionette__hot_reload` to apply them.

### Navigate and verify

1. Use `mcp__marionette__get_interactive_elements` to see what's on screen.
2. Navigate to the relevant screen by tapping elements using the translated text or ValueKeys you looked up.
3. Interact with the feature you implemented.
4. Use `mcp__marionette__take_screenshots` to capture the result.
5. Check `mcp__dart-mcp-server__get_runtime_errors` for errors.

### If you cannot reach the feature

Some features require authentication, specific data, or deep navigation that may not be reachable. In that case, note what you attempted and what blocked you. The manual verification pause still applies.

## When things don't match

Plans describe intent, but the codebase may have changed. If something doesn't match:

```
Issue in Phase [N]:
Expected: [what the plan says]
Found: [actual situation]
Why this matters: [explanation]

How should I proceed?
```

## Resuming

If the plan has existing checkmarks, pick up from the first unchecked item. Trust completed work unless something seems off.

## Finalizing

After all phases pass verification, run `melos run ci` as a final check. If everything passes, move the plan from `knowledge/local/plans/` to `knowledge/shared/plans/`.
