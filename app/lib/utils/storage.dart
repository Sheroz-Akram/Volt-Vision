import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // Key to store the token
  static const String _tokenKey = "user_token";

  // Method to store the token
  Future<void> storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Method to load the token
  Future<String?> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove the Token from Shared Preferences
  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
