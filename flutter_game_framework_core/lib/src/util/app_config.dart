// TODO: Make these values configurable.

/// Different environments the app can run in.
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
  AppConfig({
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
  static bool isDev() =>
      AppConfig.config.environment == OwnEnvironment.development;

  /// Returns whether the app is running in emulator mode.
  static bool isEmu() =>
      AppConfig.config.environment == OwnEnvironment.emulator;

  /// Returns whether the app is running in production mode.
  static bool isProd() =>
      AppConfig.config.environment == OwnEnvironment.production;

  /// Returns whether the app is running in testing mode.
  static bool isTest() =>
      AppConfig.config.environment == OwnEnvironment.testing;

  /// Initializes the app configuration.
  static Future<void> initialize({
    required OwnEnvironment env,
    required OwnPlatform platform,
    String? emulatorDomain,
    required Map<String, String> firebaseSettings,
  }) async {
    final isProd = env == OwnEnvironment.production;
    final isEmu = env == OwnEnvironment.emulator;
    try {
      AppConfig.config = AppConfig(
        environment: env,
        platform: platform,
        basicUrl: isProd ? '...' : '...',
        apiUrl: isEmu
            ? 'http://$emulatorDomain:8080/trickingbees-dev/us-central1/api/v1/'
            : isProd
                ? '...'
                : '...',
        apiKeyFirebase:
            isProd || isEmu ? firebaseSettings['apiKeyFirebase']! : '...',
        appIdAndroid: isProd ? firebaseSettings['appIdAndroid']! : '...',
        appIdIos: isProd ? firebaseSettings['appIdIos']! : '...',
        appIdWeb: isProd ? firebaseSettings['appIdWeb']! : '...',
        authDomain: isEmu
            ? 'localhost:9099'
            : isProd
                ? firebaseSettings['authDomain']!
                : '...',
        measurementId: isProd ? firebaseSettings['measurementId']! : '...',
        messagingSenderId:
            isProd ? firebaseSettings['messagingSenderId']! : '...',
        projectId: isProd ? firebaseSettings['projectId']! : '...',
        storageBucket: isProd ? firebaseSettings['storageBucket']! : '...',
      );
    } catch (e, s) {
      print('Error reading or decoding JSON file: $e');
      print(s);
    }
  }

  /// Returns the Firebase options for the current platform.
  Map<String, String> getFirebaseOptions() {
    String appId;
    switch (platform) {
      case OwnPlatform.ios:
        appId = appIdIos;
        break;
      case OwnPlatform.android:
        appId = appIdAndroid;
        break;
      default:
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
