import 'package:shared_preferences/shared_preferences.dart';

/// A class to wrap the SharedPreferences functions
class SharedPreferencesHelper {
  /// Save a StringList
  static Future<void> saveStringList(String key, List<String> list) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(key, list);
  }

  /// Load a StringList
  static Future<List<String>> loadStringList(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(key) ?? [];
  }
}
