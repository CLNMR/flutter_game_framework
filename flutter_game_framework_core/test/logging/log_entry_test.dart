import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_game_framework_core/src/models/logging/unknown_log_entry.dart';
import 'package:test/test.dart';

void main() {
  group('LogEntry.fromJson', () {
    test('deserializes startOfGame entry', () {
      final json = {'entryType': 'startOfGame', 'indentLevel': 0};
      final entry = LogEntry.fromJson(json);
      expect(entry, isA<LogStartOfGame>());
      expect(entry.entryType.name, 'startOfGame');
    });

    test('deserializes endOfGame entry', () {
      final json = {'entryType': 'endOfGame', 'indentLevel': 1};
      final entry = LogEntry.fromJson(json);
      expect(entry, isA<LogEndOfGame>());
    });

    test('unknown entryType falls back to UnknownLogEntry', () {
      final json = {'entryType': 'nonExistent', 'indentLevel': 0};
      final entry = LogEntry.fromJson(json);
      expect(entry, isA<UnknownLogEntry>());
    });

    test('missing entryType falls back to UnknownLogEntry', () {
      final json = <String, dynamic>{'indentLevel': 0};
      final entry = LogEntry.fromJson(json);
      expect(entry, isA<UnknownLogEntry>());
    });
  });

  group('LogEntry localizedKey', () {
    test('startOfGame has correct key', () {
      final entry = LogStartOfGame();
      expect(entry.localizedKey, 'LOG:startOfGame');
    });

    test('endOfGame has correct key', () {
      final entry = LogEndOfGame();
      expect(entry.localizedKey, 'LOG:endOfGame');
    });

    test('unknown has correct key', () {
      final entry = UnknownLogEntry();
      expect(entry.localizedKey, 'LOG:unknown');
    });
  });

  group('LogEntry indentLevel', () {
    test('defaults to 0', () {
      final entry = LogStartOfGame();
      expect(entry.indentLevel, 0);
    });

    test('can be set via constructor', () {
      final entry = LogStartOfGame(indentLevel: 3);
      expect(entry.indentLevel, 3);
    });
  });
}
