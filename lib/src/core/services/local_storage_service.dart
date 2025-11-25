import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _sharedPreferences;

  LocalStorageService(this._sharedPreferences);

  // User keys
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _authTokenKey = 'auth_token';

  // Getters
  String? get userId => _sharedPreferences.getString(_userIdKey);
  String? get userEmail => _sharedPreferences.getString(_userEmailKey);
  String? get userName => _sharedPreferences.getString(_userNameKey);
  String? get authToken => _sharedPreferences.getString(_authTokenKey);

  bool get isUserLoggedIn => userId != null && authToken != null;

  // Setters
  Future<bool> setUserId(String userId) =>
      _sharedPreferences.setString(_userIdKey, userId);

  Future<bool> setUserEmail(String email) =>
      _sharedPreferences.setString(_userEmailKey, email);

  Future<bool> setUserName(String name) =>
      _sharedPreferences.setString(_userNameKey, name);

  Future<bool> setAuthToken(String token) =>
      _sharedPreferences.setString(_authTokenKey, token);

  // Clear methods
  Future<bool> clearUser() async {
    await _sharedPreferences.remove(_userIdKey);
    await _sharedPreferences.remove(_userEmailKey);
    await _sharedPreferences.remove(_userNameKey);
    await _sharedPreferences.remove(_authTokenKey);
    return true;
  }

  Future<bool> clearAll() => _sharedPreferences.clear();

  // Generic methods
  Future<bool> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  Future<bool> setInt(String key, int value) =>
      _sharedPreferences.setInt(key, value);

  Future<bool> setBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  String? getString(String key) => _sharedPreferences.getString(key);

  int? getInt(String key) => _sharedPreferences.getInt(key);

  bool? getBool(String key) => _sharedPreferences.getBool(key);

  Future<bool> remove(String key) => _sharedPreferences.remove(key);
}
