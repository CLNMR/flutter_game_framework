import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

import '../test_helpers.dart';

void main() {
  group('Player', () {
    test('creates with id and displayName', () {
      const player = Player(id: 'p1', displayName: 'Alice');
      expect(player.id, 'p1');
      expect(player.displayName, 'Alice');
    });

    test('is const constructible', () {
      const p1 = Player(id: 'p1', displayName: 'Alice');
      const p2 = Player(id: 'p1', displayName: 'Alice');
      expect(identical(p1, p2), isTrue);
    });

    test('empty constant has EMPTY values', () {
      expect(Player.empty.id, 'EMPTY');
      expect(Player.empty.displayName, 'EMPTY');
    });

    test('fromUser creates player from YustUser', () {
      final user = createTestUser(id: 'u1', firstName: 'Bob');
      final player = Player.fromUser(user);
      expect(player.id, 'u1');
      expect(player.displayName, 'Bob');
    });

    test('JSON round-trip preserves fields', () {
      const original = Player(id: 'p1', displayName: 'Charlie');
      final json = original.toJson();
      final restored = Player.fromJson(json);
      expect(restored.id, 'p1');
      expect(restored.displayName, 'Charlie');
    });

    test('toJson includes id and displayName', () {
      const player = Player(id: 'p1', displayName: 'Alice');
      final json = player.toJson();
      expect(json['id'], 'p1');
      expect(json['displayName'], 'Alice');
    });
  });
}
