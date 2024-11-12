import 'dart:convert';

import 'package:app/utils/authentication.dart';
import 'package:app/utils/storage.dart';
import 'package:app/utils/validation.dart';
import 'package:http/http.dart';

class User {
  final validator = Validation();
  final authentication = Authentication();
  final storage = Storage();

  /// Login a New User
  Future<String?> login(String email, String password) async {
    // Validate the User Email and Password
    String? emailError = validator.validateEmail(email);
    String? passwordError = validator.validatePassword(password);
    if (emailError != null) {
      return emailError;
    }
    if (passwordError != null) {
      return passwordError;
    }

    // Perform Sign Up Request
    Response response = await authentication.login(email, password);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        await storage.storeToken(responseData['token']);
        return null;
      }
      return responseData['message'];
    } else {
      return "Invalid Request/Network Error";
    }
  }

  /// Login a New User
  Future<String?> signup(String name, String email, String password) async {
    // Validate the User Email and Password
    String? nameError = validator.validateName(name);
    String? emailError = validator.validateEmail(email);
    String? passwordError = validator.validatePassword(password);
    if (nameError != null) {
      return nameError;
    }
    if (emailError != null) {
      return emailError;
    }
    if (passwordError != null) {
      return passwordError;
    }

    // Perform Sign Up Request
    Response response = await authentication.signup(name, email, password);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return null;
      }
      return responseData['message'];
    } else {
      return "Invalid Request/Network Error";
    }
  }

  /// Request to Reset Password
  Future<String?> resetPassword(String email) async {
    // Validate the User Email and Password
    String? emailError = validator.validateEmail(email);

    if (emailError != null) {
      return emailError;
    }

    // Perform Sign Up Request
    Response response = await authentication.resetPassword(email);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return null;
      }
      return responseData['message'];
    } else {
      return "Invalid Request/Network Error";
    }
  }

  // Logout the Current User
  void logout() async {
    await storage.removeToken();
  }
}
