import 'package:yust/yust.dart';

import '../util/tr_object.dart';
import 'game/game.dart';

/// An event of the game.
abstract class GameEventHandler {
  /// Whether this event is currently active.
  /// If an event is active, its effects are currently needed to be considered.
  bool isActive(Game game) => false;

  /// Handle start-of-round effects triggered by the event.
  Future<void> onStartOfRound(Game game) async {}

  /// Handle end-of-round effects triggered by the event.
  void onEndOfRound(Game game) {}

  /// Handle the start of the turn.
  Future<void> onStartOfTurn(Game game) async {}

  /// Handle the end of the turn.
  void onEndOfTurn(Game game) {}

  /// Retrieve the status message displayed during the special phase of the
  /// card or event.
  TrObject? getSpecialStatusMessage(Game game, YustUser? user) => null;

  /// Retrieve the status message that is displayed whenever this card or event
  /// is active, and the user is prompted to select a move.
  TrObject? getStatusWhileActive(Game game, YustUser? user) => null;
}
