import 'package:json_annotation/json_annotation.dart';

import '../../util/tr_object.dart';
import '../game/game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'unknown_log_entry.g.dart';

@JsonSerializable()

/// The default log entry for an unknown log entry.
class UnknownLogEntry extends LogEntry {
  /// Creates a [UnknownLogEntry].
  UnknownLogEntry({
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.unknown,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [UnknownLogEntry] from a JSON.
  factory UnknownLogEntry.fromJson(Map<String, dynamic> json) =>
      _$UnknownLogEntryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UnknownLogEntryToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) =>
      TrObject(localizedKey); // TODO: Throw exception?
}
