import 'end_of_game.dart';
import 'log_entry.dart';
import 'start_of_game.dart';
import 'unknown_log_entry.dart';

/// The different types of log entries we are allowing.
class LogEntryType {
  /// Creates a [LogEntryType] with the given [name] and [fromJson] factory.
  const LogEntryType(this.name, this.fromJson);

  /// The registered log entry types.
  static List<LogEntryType> values = [startOfGame, endOfGame];

  /// Log the start of the game.
  static const startOfGame =
      LogEntryType('startOfGame', LogStartOfGame.fromJson);

  /// Log the end of the game.
  static const endOfGame = LogEntryType('endOfGame', LogEndOfGame.fromJson);

  /// Log an unknown log entry.
  static const unknown = LogEntryType('unknown', UnknownLogEntry.fromJson);

  /// The name of the log entry type.
  final String name;

  /// The factory to create a [LogEntry] from JSON.
  // ignore: prefer-correct-callback-field-name
  final LogEntry Function(Map<String, dynamic>) fromJson;
}
