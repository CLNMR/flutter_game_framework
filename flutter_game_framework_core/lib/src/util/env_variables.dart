import 'package:yust/yust.dart';

import '../models/player.dart';

/// Whether to use authentication or not
bool get noAuth => const bool.fromEnvironment('noAuth', defaultValue: false);

/// Whether the given user is the player, or no authentication is needed.
bool isAuthenticatedPlayer(YustUser? user, Player player) =>
    noAuth || player.id == user?.id;
