import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // Key to store the token
  static const String _tokenKey = "user_token";
  static const String _notificationKey = "user_notification";

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

  // Method to store the Notification
  Future<void> storeAllowNotification(bool isNotificationAllowed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, isNotificationAllowed);
  }

  // Method to load the Notification Settings
  Future<bool?> loadAllowNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationKey);
  }
}
