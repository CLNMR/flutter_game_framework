/// Different environments the app can run in.
// ignore: prefer-match-file-name
enum OwnEnvironment {
  /// This is set while the app is running in production mode.
  production,

  /// This is set while the app is running in development mode.
  development,

  /// This is set while the app is running in emulator mode.
  emulator,

  /// This is set while unit tests are executed,
  /// make sure to check for it e.g. in side-effect network calls.
  testing,
}

/// Different platforms the app can run on.
enum OwnPlatform {
  /// This is set while the app is running on Android.
  android,

  /// This is set while the app is running on iOS.
  ios,

  /// This is set while the app is running on web.
  web,

  /// This is set while the app is running in the Google Cloud.
  googleCloud,

  /// This is set while the app is running on a local server.
  localServer,
}

/// The configuration of the app.
class AppConfig {
  /// Creates an [AppConfig].
  const AppConfig({
    required this.environment,
    required this.platform,
    required this.basicUrl,
    required this.apiUrl,
    required this.apiKeyFirebase,
    required this.appIdAndroid,
    required this.appIdIos,
    required this.appIdWeb,
    required this.authDomain,
    required this.measurementId,
    required this.messagingSenderId,
    required this.projectId,
    required this.storageBucket,
  });

  /// The environment the app is running in.
  final OwnEnvironment environment;

  /// The platform the app is running on.
  final OwnPlatform platform;

  /// The basic URL of the app.
  final String basicUrl;

  /// The API URL of the app.
  final String apiUrl;

  /// The API key of the Firebase project.
  final String apiKeyFirebase;

  /// The Firebase auth domain.
  final String authDomain;

  /// The Firebase project ID.
  final String projectId;

  /// The Firebase storage bucket.
  final String storageBucket;

  /// The Firebase messaging sender ID.
  final String messagingSenderId;

  /// The Firebase app ID for Android.
  final String appIdAndroid;

  /// The Firebase app ID for iOS.
  final String appIdIos;

  /// The Firebase app ID for web.
  final String appIdWeb;

  /// The Firebase measurement ID.
  final String measurementId;

  /// The configuration of the app.
  static late AppConfig config;

  /// Returns whether the app is running in development mode.
  static bool isDev() => AppConfig.config.environment == .development;

  /// Returns whether the app is running in emulator mode.
  static bool isEmu() => AppConfig.config.environment == .emulator;

  /// Returns whether the app is running in production mode.
  static bool isProd() => AppConfig.config.environment == .production;

  /// Returns whether the app is running in testing mode.
  static bool isTest() => AppConfig.config.environment == .testing;

  /// Initializes the app configuration.
  ///
  /// All Firebase settings are read from [firebaseSettings]. For emulator mode,
  /// [emulatorDomain] overrides the auth domain. Games can provide [basicUrl]
  /// and [apiUrl] for their own API endpoints.
  static void initialize({
    required OwnEnvironment env,
    required OwnPlatform platform,
    required Map<String, String> firebaseSettings,
    String? emulatorDomain,
    String? basicUrl,
    String? apiUrl,
  }) {
    final isEmu = env == .emulator;
    try {
      AppConfig.config = AppConfig(
        environment: env,
        platform: platform,
        basicUrl: basicUrl ?? firebaseSettings['basicUrl'] ?? '',
        apiUrl: apiUrl ?? firebaseSettings['apiUrl'] ?? '',
        apiKeyFirebase: firebaseSettings['apiKeyFirebase'] ?? '',
        appIdAndroid: firebaseSettings['appIdAndroid'] ?? '',
        appIdIos: firebaseSettings['appIdIos'] ?? '',
        appIdWeb: firebaseSettings['appIdWeb'] ?? '',
        authDomain: isEmu
            ? '${emulatorDomain ?? 'localhost'}:9099'
            : (firebaseSettings['authDomain'] ?? ''),
        measurementId: firebaseSettings['measurementId'] ?? '',
        messagingSenderId: firebaseSettings['messagingSenderId'] ?? '',
        projectId: firebaseSettings['projectId'] ?? '',
        storageBucket: firebaseSettings['storageBucket'] ?? '',
      );
    } catch (e, s) {
      // ignore: avoid_print
      print('Error reading or decoding JSON file: $e\n$s');
    }
  }

  /// Returns the Firebase options for the current platform.
  Map<String, String> getFirebaseOptions() {
    final String appId;
    switch (platform) {
      case .ios:
        appId = appIdIos;

      case .android:
        appId = appIdAndroid;

      case .web:
      case .googleCloud:
      case .localServer:
        appId = appIdWeb;
    }
    return {
      'apiKey': apiKeyFirebase,
      'appId': appId,
      'authDomain': authDomain,
      'measurementId': measurementId,
      'messagingSenderId': messagingSenderId,
      'projectId': projectId,
      'storageBucket': storageBucket,
    };
  }
}
