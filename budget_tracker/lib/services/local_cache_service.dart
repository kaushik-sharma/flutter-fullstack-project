import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  static void setString(String key, String value) {
    _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }
}
