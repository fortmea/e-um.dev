import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveBool(String key, bool value) {
    _prefs.setBool(key, value);
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  void saveString(String key, String value) {
    _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  void removeData(String key) {
    _prefs.remove(key);
  }

  void clearAll() {
    _prefs.clear();
  }

  SharedPrefsHelper() {
    // init();
  }
}
