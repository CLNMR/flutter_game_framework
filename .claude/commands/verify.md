---
description: Launch the app, connect, navigate, and test a feature interactively.
---

# Verify

Test a feature in the running Flutter app by launching it, connecting via MCP, and navigating to the relevant screen.

## Process

### 1. Understand what to test

If a feature or screen was specified, proceed. Otherwise ask:

```
What feature or screen should I test?
```

### 2. Prepare navigation

Before touching the app, gather the information needed to navigate:

1. **Find the screen files** for the feature (check `packages/univelop/lib/<feature>/screens/`).
2. **Read the route** in `packages/univelop/lib/routing/managers/app_routes.dart` to understand the navigation path.
3. **Look up translated text** in `packages/uni_core/assets/translations/en.jsonc` for all buttons, labels, tabs, and menu items you need to tap to reach the feature. The app may be in German — also check `de.jsonc`.
4. **Find ValueKeys** in the screen and widget files. Elements with `ValueKey('name')` can be tapped reliably by key.
5. **Write down** the step-by-step navigation path with exact text/keys at each step.

### 3. Launch and connect

Check if the app is already running:

```
mcp__dart-mcp-server__list_running_apps
```

**If not running:**
1. `mcp__dart-mcp-server__list_devices` — pick chrome or an available device.
2. `mcp__dart-mcp-server__launch_app` with root `packages/univelop` and the chosen device.
3. Wait for the app to start.

**Connect both MCPs:**
- `mcp__dart-mcp-server__connect_dart_tooling_daemon` with the DTD URI.
- `mcp__marionette__connect` with the VM service URI.

### 4. Navigate

1. `mcp__marionette__take_screenshots` to see the current state.
2. `mcp__marionette__get_interactive_elements` to see what's tappable.
3. Tap through the navigation path using the translated text or ValueKeys from step 2.
4. At each screen transition, take a screenshot and get interactive elements again to orient yourself.
5. If an element isn't found, check if the text is in the other locale (en/de) and try that.
6. Use `mcp__marionette__scroll_to` if the target element is off-screen.

### 5. Test the feature

Once on the right screen:

1. Interact with the feature — tap buttons, enter text, scroll.
2. Take screenshots to capture each state.
3. Check `mcp__dart-mcp-server__get_runtime_errors` for errors.
4. Check `mcp__marionette__get_logs` for warnings or unexpected output.

### 6. Report

Present the findings:

```
Verification of [feature]:

Navigation: [path taken through the app]

Screenshots: [inline screenshots from each step]

Results:
- [What worked]
- [Issues found, if any]
- [Runtime errors, if any]
```

### Tips

- The app uses GoRouter. Main workspace route: `/ws/:workspaceId`. Most features are sub-routes.
- Home screen has `ValueKey('adminMenuButton')` and `ValueKey('userMenuButton')` for the menu.
- After code changes, use `mcp__marionette__hot_reload` instead of relaunching.
- If the app needs auth, use the dev credentials to sign in: Email: `123@123.de`, Password: `Qwertz1234!!`
- Some features need specific data (records, workflows) that may not exist in the test environment.
