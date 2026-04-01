import 'package:json_annotation/json_annotation.dart';

import '../../util/rich_tr_object.dart';
import '../../util/tr_object.dart';
import '../game/game.dart';
import 'log_entry.dart';

part 'start_of_game.g.dart';

@JsonSerializable()
/// An entry to a card that the solo player chooses.
// ignore: prefer-match-file-name
class LogStartOfGame extends LogEntry {
  /// Creates a [LogStartOfGame].
  LogStartOfGame({int? indentLevel})
    : super(entryType: .startOfGame, indentLevel: indentLevel ?? 0);

  /// Creates a [LogStartOfGame] from a JSON.
  factory LogStartOfGame.fromJson(Map<String, dynamic> json) =>
      _$LogStartOfGameFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$LogStartOfGameToJson(this)..['entryType'] = entryType.name;

  @override
  TrObject getDescription(Game game) => .new(
    localizedKey,
    richTrObjects: [
      RichTrObject(
        .playerList,
        value: List.generate(game.playerNum, (index) => index),
      ),
    ],
    namedArgs: {'gameId': game.gameId.toString()},
  );
}
