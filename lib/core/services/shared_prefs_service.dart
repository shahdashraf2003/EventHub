import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyCurrentUserEmail = 'current_user_email';
  static const String _keyCurrentUserName = 'current_user_name';
  static const String _keyCurrentUserId = 'current_user_id';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get hasSeenOnboarding => _prefs.getBool(_keyHasSeenOnboarding) ?? false;
  static Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_keyHasSeenOnboarding, value);
  }

  static bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;
  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  static String? get currentUserEmail => _prefs.getString(_keyCurrentUserEmail);
  static Future<void> setCurrentUserEmail(String email) async {
    await _prefs.setString(_keyCurrentUserEmail, email);
  }

  static String? get currentUserName => _prefs.getString(_keyCurrentUserName);
  static Future<void> setCurrentUserName(String name) async {
    await _prefs.setString(_keyCurrentUserName, name);
  }

  static int? get currentUserId => _prefs.getInt(_keyCurrentUserId);
  static Future<void> setCurrentUserId(int id) async {
    await _prefs.setInt(_keyCurrentUserId, id);
  }
}
