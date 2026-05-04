import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  /// save instance of shared preferences
  static final PreferencesManager _instance = PreferencesManager._internal();

  ///private constructor
  PreferencesManager._internal();

  ///factory constructor for singleton instance
  factory PreferencesManager() {
    return _instance;
  }

  late final SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///get methods
  String? getString(String key) {
    return _preferences.getString(key);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  Object? getMap(String key) {
    return _preferences.get(key);
  }

  ///set methods
  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  /// remove methods
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// clear methods
  Future<bool> clear() async {
    return await _preferences.clear();
  }
}
