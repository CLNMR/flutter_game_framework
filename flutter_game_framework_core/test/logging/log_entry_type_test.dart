import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

void main() {
  group('LogEntryType', () {
    test('startOfGame has correct name', () {
      expect(LogEntryType.startOfGame.name, 'startOfGame');
    });

    test('endOfGame has correct name', () {
      expect(LogEntryType.endOfGame.name, 'endOfGame');
    });

    test('unknown has correct name', () {
      expect(LogEntryType.unknown.name, 'unknown');
    });

    test('values contains startOfGame and endOfGame', () {
      expect(
        LogEntryType.values.map((e) => e.name),
        containsAll(['startOfGame', 'endOfGame']),
      );
    });

    test('additional types can be registered', () {
      final initialLength = LogEntryType.values.length;
      final custom = LogEntryType('custom', (json) => LogStartOfGame());
      LogEntryType.values.add(custom);
      expect(LogEntryType.values.length, initialLength + 1);
      expect(LogEntryType.values.last.name, 'custom');
      // Clean up
      LogEntryType.values.remove(custom);
    });

    test('fromJson factories produce correct types', () {
      final startEntry = LogEntryType.startOfGame.fromJson({});
      expect(startEntry, isA<LogStartOfGame>());

      final endEntry = LogEntryType.endOfGame.fromJson({});
      expect(endEntry, isA<LogEndOfGame>());
    });
  });
}
