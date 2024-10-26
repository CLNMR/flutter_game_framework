import 'end_of_game.dart';
import 'log_entry.dart';
import 'start_of_game.dart';
import 'unknown_log_entry.dart';

/// The different types of log entries we are allowing.
class LogEntryType {
  static List<LogEntryType> values = [startOfGame, endOfGame];

  /// Log the start of the game.
  static const startOfGame =
      LogEntryType('startOfGame', LogStartOfGame.fromJson);

  /// Log the end of the game.
  static const endOfGame = LogEntryType('endOfGame', LogEndOfGame.fromJson);

  /// Log an unknown log entry.
  static const unknown = LogEntryType('unknown', UnknownLogEntry.fromJson);

  const LogEntryType(this.name, this.fromJson);

  /// The name of the log entry type.
  final String name;

  /// The constructor of the logEntry from a json.
  final LogEntry Function(Map<String, dynamic>) fromJson;
}
