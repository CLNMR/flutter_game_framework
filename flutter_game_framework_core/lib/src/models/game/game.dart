import 'package:yust/yust.dart';

import '../../util/custom_types.dart';
import '../../util/env_variables.dart';
import '../game_id.dart';
import '../game_state.dart';
import '../logging/log_entry.dart';
import '../player.dart';

part 'game_pre_game_handling.dart';

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
  })  : gameId = gameId ?? GameId.generate(),
        players = players ?? [],
        playOrder = playOrder ?? List.generate(playerNum, (index) => index),
        flags = flags ?? {};
  // logEntries = existingLogEntries ?? {};

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
  // @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<String, dynamic> flags;

  /// All of the log entries for the game.
  /// Maps the round number (outer map) and the turn number (inner map) with it.
  // final Map<RoundNumber, List<LogEntry>> logEntries;

  /// The players other than the user's player, starting at their index.
  List<Player> getOtherPlayers(YustUser? user) => List.generate(
        players.length - 1,
        (index) => (getPlayerIndex(getPlayer(user)) + index + 1) % playerNum,
      )
          .map(
            (e) => players[e],
          )
          .toList();

  /// Returns the player associated with the given user.
  Player getPlayer(YustUser? user) =>
      players.firstWhere((player) => player.id == user?.id);

  /// Returns the index of the given player in the list of players.
  int getPlayerIndex(Player player) =>
      players.indexWhere((other) => other.id == player.id);

  /// Copies the game.
  Game copy();

  /// Whether the user is a mere spectator of the given game.
  bool isUserSpectator(YustUser? user) =>
      !players.map((e) => e.id).contains(user?.id);

  /// Whether the user has created the game and should thus be able to start it.
  bool isUserOwner(YustUser? user) => createdBy == user?.id;

  Future<void> save();

  /// Initializes the game with the given data.
  Game init();

  void start();
}
