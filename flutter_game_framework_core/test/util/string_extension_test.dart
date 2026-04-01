import 'package:flutter_game_framework_core/src/util/string_extension.dart';
import 'package:test/test.dart';

void main() {
  group('capitalize', () {
    test('capitalizes first letter', () {
      expect('hello'.capitalize(), 'Hello');
    });

    test('keeps already capitalized', () {
      expect('Hello'.capitalize(), 'Hello');
    });

    test('works with single character', () {
      expect('a'.capitalize(), 'A');
    });

    test('keeps rest unchanged', () {
      expect('hELLO'.capitalize(), 'HELLO');
    });
  });

  group('randomNumbers', () {
    test('returns string of correct length', () {
      final result = ''.randomNumbers(6);
      expect(result.length, 6);
    });

    test('contains only digits', () {
      final result = ''.randomNumbers(9);
      expect(result, matches(RegExp(r'^\d+$')));
    });

    test('pads with leading zeros if needed', () {
      // With length 9, the number is always 9 characters
      final result = ''.randomNumbers(9);
      expect(result.length, 9);
    });

    test('different lengths work', () {
      for (final len in [1, 3, 5, 9]) {
        final result = ''.randomNumbers(len);
        expect(result.length, len, reason: 'Length $len failed');
      }
    });
  });
}
