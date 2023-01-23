import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/token.dart';

class AccountsRepository {
  static Future<Token> login(String email, password) async {
    final response = await http.post(
      Uri.parse("http://localhost:3001/users/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return Token.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login.');
    }
  }
}


