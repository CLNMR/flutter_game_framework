import 'package:json_annotation/json_annotation.dart';

import '../util/string_extension.dart';

part 'game_id.g.dart';

@JsonSerializable()

/// The ID of a game.
class GameId {
  /// Creates a [GameId].
  GameId(this.value);

  /// Generates a [GameId] from a string.
  factory GameId.generate() => GameId(''.randomNumbers(9));

  /// Creates a [GameId] from JSON data.
  factory GameId.fromJson(Map<String, dynamic> json) => _$GameIdFromJson(json);

  /// Converts the [GameId] to JSON data.
  Map<String, dynamic> toJson() => _$GameIdToJson(this);

  /// The value of the ID.
  final String value;

  @override
  String toString() => '${value.substring(0, 3)} - ${value.substring(3, 6)} - '
      '${value.substring(6, 9)}';
}
