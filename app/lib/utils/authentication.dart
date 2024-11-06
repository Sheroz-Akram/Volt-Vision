import 'dart:convert';
import 'package:app/classes/network.dart';
import 'package:http/http.dart' as http;

class Authentication extends Network {
  // Login method
  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response;
  }

  // Signup method
  Future<http.Response> signup(
      String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return response;
  }

  // Signup method
  Future<http.Response> resetPassword(String email) async {
    final url = Uri.parse('$baseUrl/users/passwordResetRequest');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    return response;
  }
}
