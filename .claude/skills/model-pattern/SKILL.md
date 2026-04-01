---
name: model-pattern
description: "Use when creating or modifying database models. Covers YustDoc, @JsonSerializable(), @GenerateService(), and service consumption."
---

# Model Pattern

Database models extend `YustDoc`, use `@JsonSerializable()` and `@GenerateService()`, and declare a static `setup()` factory. Code generation produces `.g.dart` (JSON) and `.service.dart` (typed DB access).

## Files to create

```
packages/uni_core/lib/src/{feature}/models/{name}.dart          # the model
# Generated (do not write):
# packages/uni_core/lib/src/{feature}/models/{name}.g.dart
# packages/uni_core/lib/src/{feature}/models/{name}.service.dart
```

## Files to modify

```
packages/uni_core/lib/uni_core.dart   # add exports:
  export 'src/{feature}/models/{name}.dart';
  export 'src/{feature}/models/{name}.service.dart';
```

Run `melos run generate_parts` after changes. Then use the `analyze_files` MCP tool to check for errors and `dart_fix` to apply fixes. Always prefer MCP server tools (`run_tests`, `analyze_files`, `dart_format`, `pub`) over shell equivalents.

## Complete model pattern

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../../basic/annotations/generate_service.dart';
import '../../state_management/util/state_snap.dart';

part 'my_model.g.dart';

@JsonSerializable()
@GenerateService()
class MyModel extends YustDoc {
  MyModel({
    super.id,
    super.createdAt,
    super.createdBy,
    super.modifiedAt,
    super.modifiedBy,
    super.userId,
    super.envId,
    this.name = '',
    this.status = MyStatus.active,
    this.metadata,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  static YustDocSetup<MyModel> setup(StateSnap stateSnap) =>
      YustDocSetup<MyModel>(
        envId: stateSnap.workspaceId,
        userId: stateSnap.userId,
        trackModification: stateSnap.trackModification,
        collectionName: 'myModels',
        fromJson: MyModel.fromJson,
        newDoc: MyModel.new,
        forEnvironment: true,     // stored under workspaces/{envId}/
        hasOwner: true,           // auto-sets userId on save
        hasAuthor: true,          // auto-sets createdBy/modifiedBy
      );

  String name;
  MyStatus status;
  Map<String, dynamic>? metadata;

  @override
  Map<String, dynamic> toJson() => _$MyModelToJson(this);
}

enum MyStatus { active, archived }
```

### YustDocSetup options

| Option | Purpose |
|--------|---------|
| `forEnvironment: true` | Collection under `workspaces/{envId}/` |
| `isEnvironment: true` | Model IS the environment root (Workspace only) |
| `hasOwner: true` | Auto-sets `userId` on save |
| `hasAuthor: true` | Auto-sets `createdBy`/`modifiedBy` |
| `collectionName` | Firestore collection path |

### YustDoc base fields

All models inherit: `id`, `createdAt`, `createdBy`, `modifiedAt`, `modifiedBy`, `userId`, `envId`, `expiresAt`, `updateMask`.

## @JsonSerializable() options

Options are set globally in `packages/uni_core/build.yaml`:

```yaml
json_serializable:
  options:
    any_map: true            # fromJson accepts Map (not Map<String,dynamic>)
    explicit_to_json: true   # nested objects call .toJson() explicitly
```

The annotation on the class carries no arguments in the standard case. Rare per-class overrides:

```dart
@JsonSerializable(constructor: '_')              // private constructor
@JsonSerializable(fieldRename: FieldRename.snake) // snake_case JSON keys
```

## @GenerateService() parameters

| Parameter | Default | Effect |
|-----------|---------|--------|
| `setupFromStateSnap` | `true` | Methods take `StateSnap` as first arg |
| `updateMask` | `false` | `save()` gets `useUpdateMask` param, only writes changed fields |
| `fromYust` | `false` | For models defined in yust package |
| `setupFromSolutionId` | `false` | Methods take `String solutionId` (subcollection) |
| `setupFromIntegrationId` | `false` | Methods take `String integrationId` (subcollection) |
| `setupFromUserId` | `false` | Methods take `String userId` |
| `ignoresWorkspaceLock` | `false` | Skip workspace-lock guard in save/delete |

## updateMask pattern

When `@GenerateService(updateMask: true)`, use private backing fields with setters:

```dart
@JsonSerializable()
@GenerateService(updateMask: true)
class MyModel extends YustDoc {
  String _name;

  String get name => _name;
  set name(String value) {
    if (value != _name) updateMask.add('name');
    _name = value;
  }
  // ...
}
```

Generated `save()` then only writes fields in `updateMask`:

```dart
await model.save(stateSnap);                        // partial write (default)
await model.save(stateSnap, useUpdateMask: false);  // full rewrite
```

## Subcollection pattern

For models nested under a parent document:

```dart
@GenerateService(setupFromSolutionId: true)
class SolutionBuild extends YustDoc {
  static YustDocSetup<SolutionBuild> setup(
    StateSnap stateSnap,
    String solutionId,
  ) => YustDocSetup<SolutionBuild>(
    collectionName: 'solutions/$solutionId/solutionBuilds',
    // ...
  );
}
```

Service methods then require the parent ID:

```dart
SolutionBuildService.getListStream(stateSnap, solutionId, filters: [...])
```

## Nested value-object models

Models embedded inside other documents use only `@JsonSerializable()` with no `@GenerateService()`, no `YustDoc`, no `setup()`:

```dart
part 'user_mentioning.g.dart';

@JsonSerializable()
class UserMentioning {
  UserMentioning({
    required this.userId,
    required this.firstName,
    required this.lastName,
  });

  factory UserMentioning.fromJson(Map<String, dynamic> json) =>
      _$UserMentioningFromJson(json);

  final String userId;
  String firstName;
  String lastName;

  Map<String, dynamic> toJson() => _$UserMentioningToJson(this);
}
```

Export only the `.dart` file (no `.service.dart`).

## Service consumption

### Init + save (create)

```dart
final model = MyModelService.init(stateSnap)
  ..name = 'Hello'
  ..status = MyStatus.active;
await model.save(stateSnap);
```

### Init from existing data

```dart
final model = MyModelService.init(
  stateSnap,
  MyModel(name: 'Hello', status: MyStatus.active),
);
await model.save(stateSnap);
```

### One-shot fetch

```dart
final item = await MyModelService.getFromDB(stateSnap, id);
final list = await MyModelService.getList(stateSnap);
final list = await MyModelService.getList(stateSnap, filters: [
  YustFilter(field: 'status', comparator: YustFilterComparator.equal, value: 'active'),
]);
```

### Stream-based (Riverpod provider)

```dart
@Riverpod(keepAlive: true)
Stream<MyModel?> myModel(Ref ref) {
  final id = ref.watch(someIdProvider);
  return MyModelService.getStream(ref.lightStateSnap, id);
}
```

### Delete

```dart
await model.delete(stateSnap);
await MyModelService.deleteById(stateSnap, id);
await MyModelService.deleteAll(stateSnap, filters: [...]);
```

### Accessing stateSnap

```dart
ref.stateSnap          // one-shot, no rebuild
ref.watchStateSnap()   // reactive, triggers rebuild
```
