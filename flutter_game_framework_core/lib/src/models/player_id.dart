import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:yust/yust.dart';

part 'player_id.g.dart';

@JsonSerializable()
@immutable

/// The ID of a player.
class PlayerId {
  /// Creates a [PlayerId].
  const PlayerId({
    required this.id,
    required this.displayName,
  });

  /// Creates a [PlayerId] from a [YustUser].
  factory PlayerId.fromUser(YustUser user) => PlayerId(
        id: user.id,
        displayName: user.firstName,
      );

  /// Creates a [PlayerId] from JSON data.
  factory PlayerId.fromJson(Map<String, dynamic> json) =>
      _$PlayerIdFromJson(json);

  /// An empty [PlayerId].
  static const empty = PlayerId(id: 'EMPTY', displayName: 'EMPTY');

  /// Converts the [PlayerId] to JSON data.
  Map<String, dynamic> toJson() => _$PlayerIdToJson(this);

  /// The name to display.
  final String displayName;

  /// The id of the player.
  final String id;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayerId && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
