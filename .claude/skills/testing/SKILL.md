---
name: testing
description: "Use when writing or running tests. Covers MockHelpers, BackendSessionController, OnChangeHelper, custom matchers, and test structure."
---

# Testing

Test infrastructure spans four packages: `uni_core` (helpers + matchers), `uni_functions` (OnChangeHelper), `uni_api` (ApiTestHelpers), `uni_jobs` (JobTestHelpers). Widget tests live in `packages_standalone`. Integration tests use a Page Object pattern.

## Running tests

| Command | Scope |
|---------|-------|
| `melos run test-ci` | All Dart packages, fail-fast, 2x timeout |
| `melos run test-flutter` | All Flutter packages |
| `melos ci` | Full CI chain: lint + test + checks |

Environment variables set for all tests: `TZ=UTC`, `ENCRYPTION_KEY=test-encryption-key-32chars-long`.

Use the `run_tests` MCP tool instead of `dart test` or `flutter test` directly. Use `analyze_files` MCP tool instead of `dart analyze`. Always prefer MCP server tools over shell equivalents.

## MockHelpers — test bootstrapper

`MockHelpers.initMocks()` creates a full mock environment: workspace, RecordSpecs, roles, seed records, solutions, API keys.

### Basic setUp (no event workers)

```dart
late BackendSessionController sessionController;
late StateSnap stateSnap;

setUp(() async {
  sessionController = await MockHelpers.initMocks();
  stateSnap = sessionController.stateSnap;
});
```

### With event workers

```dart
setUp(() async {
  final onChangeHelper = OnChangeHelper();
  sessionController = await MockHelpers.initMocks(
    onChange: onChangeHelper.createOnChange(),
  );
  stateSnap = sessionController.stateSnap;
});
```

### With feature flags

```dart
sessionController = await MockHelpers.initMocks(
  enabledFlags: [Flag.enableMyFeature],
);
```

### What initMocks() provides

- Workspace with roles (Manager, Employee, Apprentice)
- Two RecordSpecs (`rs1` primary, `rs2` secondary) with bricks and tiles
- Seed records (1 primary, 3 secondary with linked pickers)
- Solutions and builds (Dependency, Solution, Customization)
- Admin API key
- `stateSnap.db` is `YustDatabaseServiceMocked` (in-memory)

## OnChangeHelper — event worker wiring

`OnChangeHelper().createOnChange()` returns a callback that intercepts mock DB writes and routes them to the correct subscriber (RecordSubscriber, FlowSubscriber, etc.).

Without it, no event workers fire during tests.

**Location:** `packages/uni_functions/lib/test_helper/on_change_helper.dart`

**Import:** `import 'package:uni_functions/uni_functions_test_helper.dart';`

## Test file pattern (arrange-act-assert)

```dart
import 'package:test/test.dart';
import 'package:uni_core/uni_core.dart';
import 'package:uni_core/uni_test_helpers.dart';

void main() async {
  late BackendSessionController sessionController;
  late StateSnap stateSnap;

  setUp(() async {
    sessionController = await MockHelpers.initMocks();
    stateSnap = sessionController.stateSnap;
  });

  group('MyFeature', () {
    test('does something', () async {
      // Arrange
      final record = await MockRecordHelpers.getFirstPrimaryRecord(stateSnap);
      final brick = record.getBrick(stateSnap, TextFieldBrick.className);

      // Act
      await brick.setValue('hello');
      await record.saveAndCalc(stateSnap);

      // Assert — async matchers re-fetch from DB
      expect(brick, HasBrickValueInDb('hello'));
    });
  });
}
```

## Custom async matchers

All matchers extend `CustomAsyncMatcher` and re-fetch data from the mock DB before asserting. Use `expectLater` for async matchers.

### Brick matchers

```dart
expect(brick, HasBrickValueInDb('expected'));          // re-fetches record, checks getMainValue()
expect(brick, HasBrickSettingInDb('key', expectedVal)); // checks getSettingOrNull(key)
expect(brick, HasBrickTotal(42.0));                    // checks aggregate total
expect(brick, HasBrickValue('expected'));               // checks getMainValue() without DB re-fetch
```

### Record matchers

```dart
expect(record, HasRecordInDb(isNotNull));
expect(record, RecordHasBrickInDb(
  stateSnap,
  TextFieldBrick.className,
  HasBrickValueInDb('value'),   // nested matcher
));
```

### Response matchers (for API tests)

```dart
await expectLater(response, isOk);                     // status 200
await expectLater(response, isCreated);                // status 201
await expectLater(response, isBadRequest);             // status 400
await expectLater(response, isNotFound);               // status 404
await expectLater(response, HasResponseStatus(409));
await expectLater(response, HasResponseBodyListLength(3));
await expectLater(response, HasResponseBodyKey('name', 'value'));
```

### Collection matchers

```dart
expect(bricks, EveryBrick(HasBrickValueInDb(isNotNull)));
expect(records, EveryRecordInDb(RecordHasBrickInDb(...)));
```

### JSON matchers

```dart
expect(map, HasJSONKeyValue('key', 'value'));           // synchronous
```

### Other matchers

```dart
expect(user, HasNotificationInDb(isNotNull));
expect(workspace, HasWorkspaceInDb(isNotNull));
expect(user, HasUserInDb(isNotNull));
```

## ApiTestHelpers — HTTP route tests

**Import:** `import '../util/api_test_helpers.dart';` (within `uni_api/test/`)

```dart
late ApiTestHelpers apiTestHelpers;

setUp(() async {
  final onChangeHelper = OnChangeHelper();
  sessionController = await MockHelpers.initMocks(
    onChange: onChangeHelper.createOnChange(),
  );
  stateSnap = sessionController.stateSnap;
  apiTestHelpers = ApiTestHelpers(stateSnap);
});
```

### Request methods

```dart
// Record CRUD
final response = await apiTestHelpers.sendRecordsRequest('GET');
final response = await apiTestHelpers.sendRecordRequest('GET', recordId: id);
final response = await apiTestHelpers.sendRecordRequest('PUT',
  recordId: id,
  body: {'TextFieldBrick': 'value'},
);

// Generic API
final response = await apiTestHelpers.sendRequest('GET', '/custom/path');

// With JWT auth
final response = await apiTestHelpers.sendRequestWithJWT('GET', '/path', user: testUser);

// Workflow triggers
final response = await apiTestHelpers.sendFlowTriggerRequest(...);
```

## JobTestHelpers — job execution tests

**Import:** `import 'package:uni_jobs/test_helper/job_test_helpers.dart';` (within `uni_jobs/test/`)

### Double-wrap pattern for job + event workers

```dart
setUp(() async {
  final onChangeHelper = OnChangeHelper();
  sessionController = await MockHelpers.initMocks(
    onChange: JobTestHelpers.wrapOnChange(onChangeHelper.createOnChange()),
  );
  stateSnap = sessionController.stateSnap;
});
```

### Creating and executing test jobs

```dart
final job = await JobTestHelpers.createAndExecTestJob(stateSnap, params: {'key': 'value'});
expect(job.status, JobStatus.completed);
```

### Verifying with mocktail

```dart
verify(() => JobTestHelpers.mockedEventWorker.runJob(
  any(that: isA<JobQueueEntry>()
    .having((j) => j.jobType, 'jobType', JobType.test)
    .having((j) => j.params, 'params', {'key': 'value'})),
)).called(1);
```

## Widget tests (packages_standalone)

Widget tests live in `packages_standalone/uni_table/test/`.

```dart
testWidgets('updates text on submit', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: MyWidget(...))));
  await tester.tap(find.byType(TextField));
  await tester.pump();
  await tester.enterText(find.byType(TextField), 'new value');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump(const Duration(milliseconds: 100));
  expect(value, equals('new value'));
});
```

## Integration tests (Page Object pattern)

Location: `packages/univelop/integration_test/`

Page objects extend `BasicPage` and return the next page object from navigation actions:

```dart
final homePage = HomePage(tester);
final designPage = await homePage.openDesignModus();
await designPage.enterText(find.byType(TextField).first, 'name');
await designPage.finishWork();
expect(find.text('name'), findsOneWidget);
```

Run via: `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/all_tests.dart`

## Key imports

```dart
import 'package:uni_core/uni_test_helpers.dart';       // MockHelpers, matchers
import 'package:uni_functions/uni_functions_test_helper.dart'; // OnChangeHelper
```
