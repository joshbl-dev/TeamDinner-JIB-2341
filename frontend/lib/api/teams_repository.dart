import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/team.dart';
import '../Types/user.dart';
import '../util.dart';

class TeamsRepository {
  static const String baseUrl = "https://team-dinner-jib-2341.vercel.app";
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "teams";

  static Future<User> get(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$repositoryName?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Team not found.');
    }
  }

  //create
  static Future<Team> create(String name, String description) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(
          <String, String>{'name': name, "description": description}),
    );
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create team.');
    }
  }

  //update
  static Future<Team> update(String? name, String? description) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(
          <String, String?>{'name': name, "description": description}),
    );
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create team.');
    }
  }

  //delete
  static Future<bool> delete(String? id) async {
    final response = await http.delete(
        Uri.parse("$baseUrl/$repositoryName${id != null ? "?id=$id" : ""}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
        });
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete team.');
    }
  }

  //members
  static Future<Team> getMembersTeam(String? id) async {
    final response = await http.get(
      Uri.parse(
          "$baseUrl/$repositoryName/members${id != null ? "?id=$id" : ""}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    if (response.statusCode == 200) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception("Member's Team not found.");
    }
  }

  //members remove
  static Future<Team> removeMembers(String teamId, String userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/members/remove"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, String>{'teamId': teamId, 'userId': userId}),
    );
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to remove member.');
    }
  }

  static Future<Team> invites(String teamID, String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, String>{'teamId': teamID, 'email': email}),
    );
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
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
      body: jsonEncode(<String, String>{'teamId': teamId, 'userId': userId}),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to accept invite.');
    }
  }

  static Future<Team> rejectInvites(String teamId, String userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites/reject"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, String>{'teamId': teamId, 'userId': userId}),
    );
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to reject invite.');
    }
  }
}
