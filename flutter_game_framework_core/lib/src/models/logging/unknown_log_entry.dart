import 'package:json_annotation/json_annotation.dart';

import '../../util/tr_object.dart';
import '../game/game.dart';
import 'log_entry.dart';

part 'unknown_log_entry.g.dart';

@JsonSerializable()
/// The default log entry for an unknown log entry.
class UnknownLogEntry extends LogEntry {
  /// Creates a [UnknownLogEntry].
  UnknownLogEntry({int? indentLevel})
    : super(entryType: .unknown, indentLevel: indentLevel ?? 0);

  /// Creates a [UnknownLogEntry] from a JSON.
  factory UnknownLogEntry.fromJson(Map<String, dynamic> json) =>
      _$UnknownLogEntryFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$UnknownLogEntryToJson(this)..['entryType'] = entryType.name;

  @override
  TrObject getDescription(Game game) => .new(localizedKey);
}
