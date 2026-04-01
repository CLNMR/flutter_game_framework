import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

void main() {
  group('RichTrObject', () {
    test('creates with correct type and value', () {
      final obj = RichTrObject(RichTrType.number, value: 42);
      expect(obj.value, 42);
      expect(obj.trType, RichTrType.number);
    });

    test('key is trType name without suffix', () {
      final obj = RichTrObject(RichTrType.player, value: 0);
      expect(obj.key, 'player');
    });

    test('key includes keySuffix', () {
      final obj = RichTrObject(
        RichTrType.number,
        value: 5,
        keySuffix: 'Tricks',
      );
      expect(obj.key, 'numberTricks');
    });

    test('accepts player index value', () {
      final obj = RichTrObject(RichTrType.player, value: 2);
      expect(obj.value, 2);
    });

    test('accepts player list value', () {
      final obj = RichTrObject(RichTrType.playerList, value: [0, 1, 2]);
      expect(obj.value, [0, 1, 2]);
    });

    test('accepts numberWithOperator', () {
      final obj = RichTrObject(RichTrType.numberWithOperator, value: -3);
      expect(obj.value, -3);
    });

    test('accepts none type with string', () {
      final obj = RichTrObject(RichTrType.none, value: 'text');
      expect(obj.value, 'text');
      expect(obj.key, 'none');
    });
  });

  group('RichTrType', () {
    test('values contains all base types', () {
      expect(RichTrType.values, contains(RichTrType.none));
      expect(RichTrType.values, contains(RichTrType.player));
      expect(RichTrType.values, contains(RichTrType.playerList));
      expect(RichTrType.values, contains(RichTrType.number));
      expect(RichTrType.values, contains(RichTrType.numberWithOperator));
    });

    test('each type has unique name', () {
      final names = RichTrType.values.map((e) => e.name).toSet();
      expect(names.length, RichTrType.values.length);
    });

    test('types have correct value types', () {
      expect(RichTrType.none.valueType, String);
      expect(RichTrType.player.valueType, int);
      expect(RichTrType.number.valueType, int);
      expect(RichTrType.numberWithOperator.valueType, int);
    });

    test('additional types can be registered', () {
      final initialLength = RichTrType.values.length;
      const custom = RichTrType('custom', String);
      RichTrType.values.add(custom);
      expect(RichTrType.values.length, initialLength + 1);
      // Clean up
      RichTrType.values.remove(custom);
    });
  });
}
