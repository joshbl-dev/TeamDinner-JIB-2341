import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/token.dart';
import '../Types/user.dart';

class TeamsRepository {
  static const String baseUrl = "https://team-dinner-jib-2341.vercel.app";
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "teams";

  //all
  static Future<User> all(Token accessToken, String id) async {
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
      throw Exception('Team not found.');
    }
  }

  //members
  static Future<User> members(Token accessToken, String id) async {
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
      throw Exception('Members not found.');
    }
  }

  //members add
  static Future<User> addMembers(String teamId, String userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/members/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'teamId': teamId,
        'userId': userId
      }),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login.');
    }
  }
}
