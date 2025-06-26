import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _firstOpenKey = 'has_opened';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> setFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstOpenKey, true);
  }

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_firstOpenKey) ?? false);
  }

  static Future<void> setLoginSession(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }
}
