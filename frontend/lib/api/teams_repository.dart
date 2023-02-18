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
      throw Exception('Team not found.');

    }
  }

   
  //create
  static Future<User> create(String name, String description, String owner) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'teamName': name,
        "description": description,
        "owner": owner
      }),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create team.');
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

  static Future<User> invites(String teamID, String userID) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'teamID': teamID,
        'userID': userID
      }),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to invite user.');
    }
  }

  //invites accept
  static Future<User> acceptInvites(String teamId, String userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites/accept"),
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
      throw Exception('Failed to accept invite.');
    }
  }

  static Future<User> rejectInvites(String teamId, String userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites/reject"),
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
      throw Exception('Failed to reject invite.');
    }
  }
}