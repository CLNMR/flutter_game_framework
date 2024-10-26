import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

part 'player.g.dart';

@JsonSerializable()

/// A player of the game.
class Player {
  /// Creates a [Player].
  Player({
    required this.id,
    required this.displayName,
  });

  /// Creates a [Player] from a [YustUser].
  factory Player.fromUser(YustUser user) => Player(
        id: user.id,
        displayName: user.firstName,
      );

  /// Creates a [Player] from a JSON map.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Converts the [Player] to a JSON map.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  /// The id of the player.
  final String id;

  /// The name of the player.
  final String displayName;

  /// An empty [Player].
  static final empty = Player(
    id: 'EMPTY',
    displayName: 'EMPTY',
  );
}
