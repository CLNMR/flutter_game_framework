import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_game_framework_core/src/models/logging/unknown_log_entry.dart';
import 'package:test/test.dart';

void main() {
  group('LogStartOfGame serialization', () {
    test('toJson includes entryType', () {
      final entry = LogStartOfGame();
      final json = entry.toJson();
      expect(json['entryType'], 'startOfGame');
    });

    test('toJson includes indentLevel', () {
      final entry = LogStartOfGame(indentLevel: 2);
      final json = entry.toJson();
      expect(json['indentLevel'], 2);
    });

    test('fromJson round-trip preserves data', () {
      final original = LogStartOfGame(indentLevel: 1);
      final json = original.toJson();
      final restored = LogStartOfGame.fromJson(json);
      expect(restored.indentLevel, 1);
      expect(restored.entryType.name, 'startOfGame');
    });
  });

  group('LogEndOfGame serialization', () {
    test('toJson includes entryType', () {
      final entry = LogEndOfGame();
      final json = entry.toJson();
      expect(json['entryType'], 'endOfGame');
    });

    test('fromJson round-trip preserves data', () {
      final original = LogEndOfGame(indentLevel: 0);
      final json = original.toJson();
      final restored = LogEndOfGame.fromJson(json);
      expect(restored.entryType.name, 'endOfGame');
    });
  });

  group('UnknownLogEntry serialization', () {
    test('toJson includes entryType', () {
      final entry = UnknownLogEntry();
      final json = entry.toJson();
      expect(json['entryType'], 'unknown');
    });

    test('fromJson round-trip preserves data', () {
      final original = UnknownLogEntry(indentLevel: 5);
      final json = original.toJson();
      final restored = UnknownLogEntry.fromJson(json);
      expect(restored.indentLevel, 5);
    });
  });

  group('Polymorphic deserialization', () {
    test('LogEntry.fromJson dispatches to correct subclass', () {
      final startJson = LogStartOfGame().toJson();
      final endJson = LogEndOfGame().toJson();

      expect(LogEntry.fromJson(startJson), isA<LogStartOfGame>());
      expect(LogEntry.fromJson(endJson), isA<LogEndOfGame>());
    });
  });
}
