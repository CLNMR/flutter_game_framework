import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

import '../test_helpers.dart';

void main() {
  late TestGame game;

  setUp(() {
    game = TestGame(playerNum: 3);
  });

  group('tryAddPlayer', () {
    test('adds player to empty game', () async {
      const player = Player(id: 'p1', displayName: 'Alice');
      await game.tryAddPlayer(player);
      expect(game.players, hasLength(1));
      expect(game.players.first.id, 'p1');
    });

    test('does not add duplicate player', () async {
      const player = Player(id: 'p1', displayName: 'Alice');
      await game.tryAddPlayer(player);
      await game.tryAddPlayer(player);
      expect(game.players, hasLength(1));
    });

    test('does not add player when game is full', () async {
      for (var i = 0; i < 3; i++) {
        await game.tryAddPlayer(Player(id: 'p$i', displayName: 'P$i'));
      }
      await game.tryAddPlayer(
        const Player(id: 'p4', displayName: 'Extra'),
      );
      expect(game.players, hasLength(3));
    });

    test('calls save when shouldSave is true', () async {
      await game.tryAddPlayer(
        const Player(id: 'p1', displayName: 'Alice'),
      );
      expect(game.saveCallCount, 1);
    });

    test('does not call save when shouldSave is false', () async {
      await game.tryAddPlayer(
        const Player(id: 'p1', displayName: 'Alice'),
        shouldSave: false,
      );
      expect(game.saveCallCount, 0);
    });
  });

  group('tryAddUser', () {
    test('converts user to player and adds', () async {
      final user = createTestUser(id: 'u1', firstName: 'Alice');
      await game.tryAddUser(user);
      expect(game.players, hasLength(1));
      expect(game.players.first.id, 'u1');
      expect(game.players.first.displayName, 'Alice');
    });
  });

  group('removePlayer', () {
    setUp(() async {
      game.createdBy = 'p0';
      for (var i = 0; i < 3; i++) {
        await game.tryAddPlayer(
          Player(id: 'p$i', displayName: 'P$i'),
          shouldSave: false,
        );
      }
    });

    test('removes player at valid index', () async {
      await game.removePlayer(1);
      expect(game.players, hasLength(2));
      expect(game.players.map((e) => e.id), isNot(contains('p1')));
    });

    test('does not remove game owner', () async {
      await game.removePlayer(0); // p0 is the owner
      expect(game.players, hasLength(3));
    });

    test('ignores invalid negative index', () async {
      await game.removePlayer(-1);
      expect(game.players, hasLength(3));
    });

    test('ignores out-of-bounds index', () async {
      await game.removePlayer(10);
      expect(game.players, hasLength(3));
    });
  });

  group('arePlayersComplete', () {
    test('returns false when not enough players', () {
      expect(game.arePlayersComplete, isFalse);
    });

    test('returns true when all players joined', () async {
      for (var i = 0; i < 3; i++) {
        await game.tryAddPlayer(
          Player(id: 'p$i', displayName: 'P$i'),
          shouldSave: false,
        );
      }
      expect(game.arePlayersComplete, isTrue);
    });
  });

  group('startGame', () {
    setUp(() async {
      for (var i = 0; i < 3; i++) {
        await game.tryAddPlayer(
          Player(id: 'p$i', displayName: 'P$i'),
          shouldSave: false,
        );
      }
    });

    test('does not start if players incomplete', () async {
      final incompleteGame = TestGame(playerNum: 5);
      await incompleteGame.tryAddPlayer(
        const Player(id: 'p0', displayName: 'P0'),
        shouldSave: false,
      );
      await incompleteGame.startGame();
      expect(incompleteGame.gameState, GameState.waitingForPlayers);
    });

    test('transitions to running state', () async {
      await game.startGame();
      expect(game.gameState, GameState.running);
    });

    test('shuffles players when shufflePlayers is true', () async {
      // Run multiple times to verify shuffle occurs at least once
      final originalOrder = game.players.map((e) => e.id).toList();
      var shuffled = false;
      for (var attempt = 0; attempt < 20; attempt++) {
        final testGame = TestGame(
          playerNum: 3,
          players: [
            const Player(id: 'p0', displayName: 'P0'),
            const Player(id: 'p1', displayName: 'P1'),
            const Player(id: 'p2', displayName: 'P2'),
          ],
        );
        await testGame.startGame();
        final newOrder = testGame.players.map((e) => e.id).toList();
        if (newOrder.toString() != originalOrder.toString()) {
          shuffled = true;
          break;
        }
      }
      expect(
        shuffled,
        isTrue,
        reason: 'Players should be shuffled at least once in 20 attempts',
      );
    });

    test('does not shuffle when shufflePlayers is false', () async {
      game.shufflePlayers = false;
      final orderBefore = game.players.map((e) => e.id).toList();
      await game.startGame();
      final orderAfter = game.players.map((e) => e.id).toList();
      expect(orderAfter, orderBefore);
    });
  });
}
