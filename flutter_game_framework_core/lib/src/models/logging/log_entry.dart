import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../util/tr_object.dart';
import '../game/game.dart';
import 'log_entry_type.dart';

part 'log_entry.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)

/// An entry to log what has happened in the game.
abstract class LogEntry {
  /// Creates a [LogEntry].
  LogEntry({
    required this.entryType,
    required this.indentLevel,
    // this.coords = const [],
  });

  /// Creates a [LogEntry] from JSON data.
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    final entryType = LogEntryType.values
        .firstWhereOrNull((entryType) => entryType.name == json['entryType']);
    return (entryType ?? LogEntryType.unknown).fromJson(json);
  }

  @JsonKey(toJson: _logEntryTypeToJson)

  /// The entryType for this log entry
  final LogEntryType entryType;

  /// The indentation level of the log event.
  int indentLevel;

  /// Converts the [LogEntry] to JSON data.
  Map<String, dynamic> toJson();

  /// The log entry key.
  String get localizedKey => 'LOG:${entryType.name}';

  /// The description of the log entry, to be reimplemented.
  TrObject getDescription(Game game);

  /// Shows the event display, to be reimplemented.
  Future<void> showEventDisplay(
    Game game,
    Function(
      TrObject title,
      TrObject message,
    ) displayEvent,
    Function() incrementLogDisplayCount,
  ) async {
    incrementLogDisplayCount();
  }

  static String _logEntryTypeToJson(LogEntryType instance) => instance.name;
}
