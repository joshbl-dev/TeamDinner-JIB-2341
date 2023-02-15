import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/token.dart';
import '../Types/user.dart';

class UsersRepository {
  static const String baseUrl = "https://team-dinner-jib-2341.vercel.app";
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "users";

  static Future<Token> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 201) {
      return Token.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login.');
    }
  }

  static Future<User> signup(User user, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': email,
        'password': password
      }),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login.');
    }
  }

  //teams/create
  static Future<User> create(User user, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/teams/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "teamName": "string",
        "description": "string",
        "owner": "string"
      }),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login.');
    }
  }

  static Future<User> get(Token accessToken, String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$repositoryName?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${accessToken.token}"
      },

    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('User not found.');
    }
  }
}
