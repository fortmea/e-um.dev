import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController extends GetxController {
  static StorageController get to => Get.find();

  late SharedPreferences _prefs;
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    _loadAllPreferences();
  }

  void _loadAllPreferences() {
    for (String key in _prefs.getKeys()) {
      data[key] = _prefs.get(key);
    }
  }
  T? getValue<T>(String key) {
    return data[key] as T?;
  }

  Future<void> setValue<T>(String key, T value) async {
    data[key] = value; // Atualiza o mapa observável
    if (value is String) await _prefs.setString(key, value);
    if (value is int) await _prefs.setInt(key, value);
    if (value is double) await _prefs.setDouble(key, value);
    if (value is bool) await _prefs.setBool(key, value);
    if (value is List<String>) await _prefs.setStringList(key, value);
  }

  Future<void> removeValue(String key) async {
    data.remove(key);
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    data.clear();
    await _prefs.clear();
  }
}
