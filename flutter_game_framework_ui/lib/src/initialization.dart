import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';
import 'package:yust_ui/yust_ui.dart';

// LATER: Add offline check for players (write timestamp every 2m, show offline after 3m)

GoRoute? _gameScreenRoute;
GoRoute get gameScreenRoute {
  assert(_gameScreenRoute != null, 'GameScreenRouting not initialized!');
  return _gameScreenRoute!;
}

YustDocSetup<Game>? _gameSetup;
YustDocSetup<Game> get gameSetup {
  assert(_gameSetup != null, 'GameSetup not initialized!');
  return _gameSetup!;
}

Game Function()? _createNewGame;
Game Function() get createNewGame {
  assert(_createNewGame != null, 'CreateNewGame not initialized!');
  return _createNewGame!;
}

List<InlineSpan> Function(BuildContext context, TrObject trObject)? getSpans;

Future<void> initialize({
  // required AppConfig config,
  required GoRoute gameScreenRoute,
  required YustDocSetup<Game> gameSetup,
  required Game Function() createNewGame,
  String? emulatorAddress,
  List<LogEntryType>? additionalLogTypes,
  List<RichTrType>? additionalRichTrTypes,
  List<InlineSpan> Function(BuildContext context, TrObject trObject)?
  spanBuilder,
}) async {
  LogEntryType.values.insertAll(0, additionalLogTypes ?? []);
  RichTrType.values.addAll(additionalRichTrTypes ?? []);
  _gameScreenRoute = gameScreenRoute;
  _gameSetup = gameSetup;
  _createNewGame = createNewGame;
  getSpans = spanBuilder;
  WidgetsFlutterBinding.ensureInitialized();
  await _initAppConfig(emulatorAddress: emulatorAddress);

  await Yust(forUI: true).initialize(
    firebaseOptions: AppConfig.config.getFirebaseOptions(),
    projectId: AppConfig.config.projectId,
    emulatorAddress: emulatorAddress,
  );

  YustUi.initialize(
    storageUrl: AppConfig.config.storageBucket,
    imagePlaceholderPath: 'assets/image-placeholder.png',
  );
}

Future<void> _initAppConfig({String? emulatorAddress}) async {
  final env = emulatorAddress != null
      ? OwnEnvironment.emulator
      : const String.fromEnvironment('environment', defaultValue: 'dev') ==
            'prod'
      ? OwnEnvironment.production
      : OwnEnvironment.development;
  final platform = kIsWeb
      ? OwnPlatform.web
      : Platform.isAndroid
      ? OwnPlatform.android
      : OwnPlatform.ios;
  try {
    final jsonString = await rootBundle.loadString(
      'assets/secrets/firebase_keys.json',
    );
    final jsonData = Map<String, dynamic>.from(
      jsonDecode(jsonString),
    ).map((key, value) => MapEntry(key, value.toString()));
    AppConfig.initialize(
      env: env,
      platform: platform,
      emulatorDomain: emulatorAddress,
      firebaseSettings: jsonData,
    );
  } catch (e) {
    // ignore: avoid_print
    print('Error: $e');
  }
}
