import 'package:yust/yust.dart';

import '../../util/custom_types.dart';
import '../../util/env_variables.dart';
import '../../util/other_functions.dart';
import '../../util/tr_object.dart';
import '../game_id.dart';
import '../game_state.dart';
import '../logging/log_entry.dart';
import '../player.dart';

/// A game of TrickingBees.
abstract class Game extends YustDoc {
  /// Creates a [Game].
  Game({
    super.id,
    super.createdAt,
    super.createdBy,
    super.modifiedAt,
    super.modifiedBy,
    super.userId,
    super.envId,
    GameId? gameId,
    // Static game properties:
    this.online = true,
    this.public = true,
    this.password = '',
    this.shufflePlayers = true,
    this.playerNum = 4,
    this.allowSpectators = false,
    List<Player>? players,
    // Dynamic game properties:
    this.gameState = GameState.waitingForPlayers,
    List<int>? playOrder,
    Map<String, dynamic>? flags,
    Map<RoundNumber, List<LogEntry>>? existingLogEntries,
  }) : gameId = gameId ?? GameId.generate(),
       players = players ?? [],
       playOrder = playOrder ?? List.generate(playerNum, (index) => index),
       flags = flags ?? {};

  /// The ID of the game in the format NNN-NNN-NNN.
  final GameId gameId;

  /// Whether the game is online or offline.
  bool online;

  /// Whether the game is public or private.
  bool public;

  /// The password needed to enter the game.
  String password;

  /// The number of players this game is played with.
  int playerNum;

  /// Whether the players are shuffled upon the start of the game.
  bool shufflePlayers;

  /// Whether spectators are allowed.
  bool allowSpectators;

  /// The state of the game.
  GameState gameState;

  /// The list of players in the game.
  List<Player> players;

  /// The current play order, where the entries are player indices.
  List<PlayerIndex> playOrder;

  /// Stores all flags for the current cards and event.
  final Map<String, dynamic> flags;

  /// The players other than the user's player, starting at their index.
  List<Player> getOtherPlayers(YustUser? user) => List.generate(
    players.length - 1,
    (index) => (getPlayerIndex(getPlayer(user)) + index + 1) % playerNum,
  ).map((e) => players[e]).toList();

  /// Returns the player associated with the given user.
  Player getPlayer(YustUser? user) =>
      players.firstWhere((player) => player.id == user?.id);

  /// Returns the index of the given player in the list of players.
  int getPlayerIndex(Player player) =>
      players.indexWhere((other) => other.id == player.id);

  /// Shortened unique player name prefixes for display in log entries.
  List<String> get shortenedPlayerNames =>
      getUniqueStartSubstrings(players.map((e) => e.displayName));

  /// Returns the current round number. Override in subclass.
  int get currentRound => 0;

  /// Returns status messages to display to the user.
  /// Override in subclass to provide game-specific status.
  List<TrObject> getStatusMessages(YustUser? user) => [];

  /// Whether the user has something to do (e.g. it's their turn).
  /// Override in subclass.
  bool hasStuffToDo(YustUser? user) => false;

  /// Copies the game.
  Game copy();

  /// Whether the user is a mere spectator of the given game.
  bool isUserSpectator(YustUser? user) =>
      !players.map((e) => e.id).contains(user?.id);

  /// Whether the user has created the game and should thus be able to start it.
  bool isUserOwner(YustUser? user) => createdBy == user?.id;

  /// Saves the game to the database.
  Future<void> save({
    bool merge = true,
    bool? trackModification,
    bool skipOnSave = false,
    bool? removeNullValues,
    bool doNotCreate = false,
  });

  /// Initializes the game with the given data.
  Game init();

  /// Starts the game.
  void start();

  // -- Pre-game handling (player registration and game start) --

  /// Adds the given user to the game, if they are not already present.
  Future<void> tryAddUser(YustUser user, {bool shouldSave = true}) =>
      tryAddPlayer(Player.fromUser(user), shouldSave: shouldSave);

  /// Adds the given player to the game, if they are not already present.
  Future<void> tryAddPlayer(Player player, {bool shouldSave = true}) async {
    if (players.map((e) => e.id).contains(player.id) || arePlayersComplete) {
      return;
    }
    players.add(player);
    if (shouldSave) await save();
  }

  /// Removes the player at the given index from the game.
  Future<void> removePlayer(int playerIndex) async {
    if (playerIndex < 0 || playerIndex >= players.length) return;
    if (players[playerIndex].id == createdBy) {
      // Cannot remove the owner of the game.
      return;
    }
    players.removeAt(playerIndex);
    await save();
  }

  /// Returns true if all players have joined the game.
  bool get arePlayersComplete => players.length == playerNum;

  /// Saves the game to the database for the first time, and opens it up for
  /// other players to join.
  Future<void> startLobby(YustUser user) async {
    createdBy = user.id;
    envId = noAuth ? 'test' : 'prod';
    await tryAddUser(user, shouldSave: false);
    final game = init();
    await game.save();
    if (!online) {
      for (var i = 1; i < playerNum; i++) {
        // ignore: prefer-number-format
        await game.tryAddPlayer(Player(id: 'bot$i', displayName: 'Bot $i'));
      }
      await game.startGame();
    }
  }

  /// Starts the main game, if all players have joined.
  Future<void> startGame() async {
    if (!arePlayersComplete) return;
    if (shufflePlayers) {
      players.shuffle();
    }
    gameState = .running;
    await customStartLogic();
  }

  /// Custom starting logic for the game. Override in subclass.
  // ignore: no-empty-block
  Future<void> customStartLogic() async {}
}
