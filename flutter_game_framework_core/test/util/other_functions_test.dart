import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

void main() {
  group('getUniqueStartSubstrings', () {
    test('returns unique prefixes for distinct names', () {
      expect(
        getUniqueStartSubstrings(['Hello', 'Hestia', 'Alan']),
        ['Hel', 'Hes', 'A'],
      );
    });

    test('returns single characters when all unique', () {
      expect(
        getUniqueStartSubstrings(['Alice', 'Bob', 'Charlie']),
        ['A', 'B', 'C'],
      );
    });

    test('handles single item', () {
      expect(
        getUniqueStartSubstrings(['Alice']),
        ['A'],
      );
    });

    test('handles empty list', () {
      expect(getUniqueStartSubstrings([]), isEmpty);
    });

    test('handles names with shared long prefixes', () {
      final result = getUniqueStartSubstrings(['testing', 'tester']);
      expect(result, hasLength(2));
      expect(result.toSet().length, 2);
    });

    test('skips shorter name when it is a prefix of another', () {
      // "test" is a prefix of "testing", so no unique prefix for "test"
      // within 4 characters. Only "testing" gets a result ("testi").
      final result = getUniqueStartSubstrings(['test', 'testing']);
      expect(result, hasLength(1));
      expect(result.first, 'testi');
    });

    test('is case insensitive for matching', () {
      final result = getUniqueStartSubstrings(['alice', 'ALAN']);
      // Both start with 'a'/'A' (case insensitive), so need longer prefixes
      expect(result, hasLength(2));
      // Each result should be a unique prefix of its source
      expect(result[0].toLowerCase(), isNot(result[1].toLowerCase()));
    });
  });
}
