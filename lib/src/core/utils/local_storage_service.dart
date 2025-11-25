import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Keys
  static const String _themeModeKey = 'theme_mode';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _authTokenKey = 'auth_token';

  // Generic String methods
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  // Generic Int methods
  Future<bool> setInt(String key, int value) =>
      _prefs.setInt(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  // Generic Bool methods
  Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  // Theme Mode
  Future<bool> setThemeMode(String themeMode) =>
      setString(_themeModeKey, themeMode);

  String? getThemeMode() => getString(_themeModeKey);

  // Onboarding Completed
  Future<bool> setOnboardingCompleted(bool completed) =>
      setBool(_onboardingCompletedKey, completed);

  bool isOnboardingCompleted() => getBool(_onboardingCompletedKey) ?? false;

  // User ID
  Future<bool> setUserId(String userId) =>
      setString(_userIdKey, userId);

  String? getUserId() => getString(_userIdKey);

  // User Email
  Future<bool> setUserEmail(String email) =>
      setString(_userEmailKey, email);

  String? getUserEmail() => getString(_userEmailKey);

  // User Name
  Future<bool> setUserName(String name) =>
      setString(_userNameKey, name);

  String? getUserName() => getString(_userNameKey);

  // Auth Token
  Future<bool> setAuthToken(String token) =>
      setString(_authTokenKey, token);

  String? getAuthToken() => getString(_authTokenKey);

  // Check if user is logged in
  bool isUserLoggedIn() => getUserId() != null && getAuthToken() != null;

  // Clear specific user data
  Future<bool> clearUserData() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_authTokenKey);
    return true;
  }

  // Clear all data
  Future<bool> clearAll() => _prefs.clear();

  // Remove specific key
  Future<bool> remove(String key) => _prefs.remove(key);

  // Check if key exists
  bool containsKey(String key) => _prefs.containsKey(key);
}
