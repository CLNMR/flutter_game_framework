import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

import '../test_helpers.dart';

void main() {
  group('Game construction', () {
    test('creates with default values', () {
      final game = TestGame();
      expect(game.online, isTrue);
      expect(game.public, isTrue);
      expect(game.password, isEmpty);
      expect(game.playerNum, 4);
      expect(game.shufflePlayers, isTrue);
      expect(game.allowSpectators, isFalse);
      expect(game.gameState, GameState.waitingForPlayers);
      expect(game.players, isEmpty);
      expect(game.flags, isEmpty);
    });

    test('generates a GameId', () {
      final game = TestGame();
      expect(game.gameId.value, hasLength(9));
    });

    test('creates with custom values', () {
      final game = TestGame(
        online: false,
        public: false,
        password: 'secret',
        playerNum: 2,
        shufflePlayers: false,
        allowSpectators: true,
      );
      expect(game.online, isFalse);
      expect(game.public, isFalse);
      expect(game.password, 'secret');
      expect(game.playerNum, 2);
      expect(game.shufflePlayers, isFalse);
      expect(game.allowSpectators, isTrue);
    });

    test('playOrder defaults to sequential indices', () {
      final game = TestGame(playerNum: 3);
      expect(game.playOrder, [0, 1, 2]);
    });
  });

  group('Game player queries', () {
    late TestGame game;
    late List<Player> players;

    setUp(() {
      players = [
        const Player(id: 'u1', displayName: 'Alice'),
        const Player(id: 'u2', displayName: 'Bob'),
        const Player(id: 'u3', displayName: 'Charlie'),
      ];
      game = TestGame(playerNum: 3, players: players);
    });

    test('getPlayer finds player by user id', () {
      final user = createTestUser(id: 'u2');
      final player = game.getPlayer(user);
      expect(player.displayName, 'Bob');
    });

    test('getPlayerIndex returns correct index', () {
      final index = game.getPlayerIndex(players[1]);
      expect(index, 1);
    });

    test('getOtherPlayers returns all except user', () {
      final user = createTestUser(id: 'u1');
      final others = game.getOtherPlayers(user);
      expect(others, hasLength(2));
      expect(others.map((e) => e.id), isNot(contains('u1')));
    });

    test('getOtherPlayers wraps around starting at user index', () {
      final user = createTestUser(id: 'u2');
      final others = game.getOtherPlayers(user);
      // Starting after index 1 (Bob): Charlie, then Alice
      expect(others[0].displayName, 'Charlie');
      expect(others[1].displayName, 'Alice');
    });

    test('isUserSpectator returns true for non-player', () {
      final spectator = createTestUser(id: 'spectator');
      expect(game.isUserSpectator(spectator), isTrue);
    });

    test('isUserSpectator returns false for player', () {
      final user = createTestUser(id: 'u1');
      expect(game.isUserSpectator(user), isFalse);
    });

    test('isUserOwner returns true for creator', () {
      game.createdBy = 'u1';
      final user = createTestUser(id: 'u1');
      expect(game.isUserOwner(user), isTrue);
    });

    test('isUserOwner returns false for non-creator', () {
      game.createdBy = 'u1';
      final user = createTestUser(id: 'u2');
      expect(game.isUserOwner(user), isFalse);
    });
  });

  group('Game copy', () {
    test('copy creates independent instance', () {
      final game = TestGame(
        playerNum: 2,
        players: [const Player(id: 'p1', displayName: 'A')],
      );
      final copy = game.copy() as TestGame;
      copy.players.add(const Player(id: 'p2', displayName: 'B'));
      expect(game.players, hasLength(1));
      expect(copy.players, hasLength(2));
    });
  });
}
