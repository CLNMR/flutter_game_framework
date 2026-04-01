import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

void main() {
  group('TrObject', () {
    test('stores text', () {
      final tr = TrObject('hello');
      expect(tr.text, 'hello');
    });

    test('stores args', () {
      final tr = TrObject('key', args: ['a', 'b']);
      expect(tr.args, ['a', 'b']);
    });

    test('stores namedArgs', () {
      final tr = TrObject('key', namedArgs: {'name': 'Alice'});
      expect(tr.namedArgs, {'name': 'Alice'});
    });

    test('stores gender', () {
      final tr = TrObject('key', gender: 'male');
      expect(tr.gender, 'male');
    });

    test('stores namedArgsTrObjects', () {
      final nested = TrObject('nested');
      final tr = TrObject('key', namedArgsTrObjects: {'role': nested});
      expect(tr.namedArgsTrObjects?['role']?.text, 'nested');
    });

    test('stores richTrObjects', () {
      final rich = RichTrObject(RichTrType.number, value: 42);
      final tr = TrObject('key', richTrObjects: [rich]);
      expect(tr.richTrObjects, hasLength(1));
      expect(tr.richTrObjects!.first.value, 42);
    });

    test('optional fields default to null', () {
      final tr = TrObject('key');
      expect(tr.args, isNull);
      expect(tr.namedArgs, isNull);
      expect(tr.gender, isNull);
      expect(tr.namedArgsTrObjects, isNull);
      expect(tr.richTrObjects, isNull);
    });
  });
}
