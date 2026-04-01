import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:yust/yust.dart';

/// A concrete [Game] subclass for testing.
// ignore: prefer-match-file-name
class TestGame extends Game {
  TestGame({
    super.gameId,
    super.online,
    super.public,
    super.password,
    super.shufflePlayers,
    super.playerNum,
    super.allowSpectators,
    super.players,
    super.gameState,
    super.playOrder,
    super.flags,
  });

  int saveCallCount = 0;
  bool startCalled = false;

  @override
  Game copy() => TestGame(
        gameId: gameId,
        online: online,
        public: public,
        password: password,
        shufflePlayers: shufflePlayers,
        playerNum: playerNum,
        allowSpectators: allowSpectators,
        players: List.of(players),
        gameState: gameState,
        playOrder: List.of(playOrder),
      );

  @override
  Game init() => this;

  @override
  void start() {
    startCalled = true;
  }

  @override
  Future<void> save({
    bool merge = true,
    bool? trackModification,
    bool skipOnSave = false,
    bool? removeNullValues,
    bool doNotCreate = false,
  }) async {
    saveCallCount++;
  }

  @override
  Map<String, dynamic> toJson() => {};
}

/// Creates a [YustUser] for testing.
YustUser createTestUser({
  String id = 'user1',
  String firstName = 'Alice',
  String email = 'alice@test.com',
}) =>
    YustUser(email: email, firstName: firstName, lastName: 'Test')..id = id;
