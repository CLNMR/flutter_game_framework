import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

void main() {
  group('GameId', () {
    test('stores value', () {
      const id = GameId('123456789');
      expect(id.value, '123456789');
    });

    test('generate creates 9-digit string', () {
      final id = GameId.generate();
      expect(id.value.length, 9);
      expect(id.value, matches(RegExp(r'^\d{9}$')));
    });

    test('generate creates unique IDs', () {
      final ids = List.generate(20, (_) => GameId.generate().value);
      // With 9 digits, collisions should be extremely rare
      expect(ids.toSet().length, ids.length);
    });

    test('toString formats as NNN - NNN - NNN', () {
      const id = GameId('123456789');
      expect(id.toString(), '123 - 456 - 789');
    });

    test('JSON round-trip preserves value', () {
      const original = GameId('987654321');
      final json = original.toJson();
      final restored = GameId.fromJson(json);
      expect(restored.value, original.value);
    });

    test('toJson includes value field', () {
      const id = GameId('111222333');
      final json = id.toJson();
      expect(json['value'], '111222333');
    });
  });
}
