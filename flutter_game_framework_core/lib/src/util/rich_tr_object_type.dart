import 'custom_types.dart';

/// The special translation type for a TrObject.
class RichTrType {
  /// Creates a [RichTrType] with the given [name] and [valueType].
  const RichTrType(this.name, this.valueType);

  /// The registered rich translation types.
  static List<RichTrType> values = [
    none,
    player,
    playerList,
    number,
    numberWithOperator,
  ];

  /// The default style.
  static const none = RichTrType('none', String);

  /// The special translation type for a player.
  static const player = RichTrType('player', PlayerIndex);

  /// The special translation type for a list of players.
  static const playerList = RichTrType('playerList', List<PlayerIndex>);

  /// The special translation type for a number.
  static const number = RichTrType('number', int);

  /// The special translation type for a number with a + or - operator.
  static const numberWithOperator = RichTrType('numberWithOperator', int);

  /// The name of this rich translation type.
  final String name;

  /// The type of the value associated with this.
  final Type valueType;
}
