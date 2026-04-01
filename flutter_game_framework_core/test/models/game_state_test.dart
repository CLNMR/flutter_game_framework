import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

void main() {
  group('GameState', () {
    test('has all expected values', () {
      expect(GameState.values, hasLength(4));
      expect(GameState.values, contains(GameState.waitingForPlayers));
      expect(GameState.values, contains(GameState.running));
      expect(GameState.values, contains(GameState.finished));
      expect(GameState.values, contains(GameState.abandoned));
    });

    test('each value has an icon code point', () {
      for (final state in GameState.values) {
        expect(state.iconCodePoint, isA<int>());
        expect(state.iconCodePoint, greaterThan(0));
      }
    });

    test('toJson returns enum name', () {
      expect(GameState.waitingForPlayers.toJson(), 'waitingForPlayers');
      expect(GameState.running.toJson(), 'running');
      expect(GameState.finished.toJson(), 'finished');
      expect(GameState.abandoned.toJson(), 'abandoned');
    });
  });
}
