import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Network {
  // HOST of our Server
  final String baseUrl =
      "https://4051-2a09-bac5-5044-1028-00-19c-162.ngrok-free.app";

  // Simple POST Request to Server
  Future<Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    return response;
  }

  // Simple Get Request
  Future<Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return response;
  }
}
