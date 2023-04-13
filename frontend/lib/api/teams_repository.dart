import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/team.dart';
import '../Types/user.dart';
import '../util.dart';

/* Repository for teams; stores descriptions and behaviors of the teams object */
class TeamsRepository {
  static const String baseUrl = "https://team-dinner-jib-2341.vercel.app";
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "teams";
  /* Waiting for team user information */
  static Future<User> get(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$repositoryName?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    /* Error handling for no existing team */
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Team not found.');
    }
  }

  /* create a team with name and description */
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
    /* Error handling for not being able to create team */
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create team.');
    }
  }

  /* update the team name and description */
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
    /* Error handling for failing to create a team */
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create team.');
    }
  }

  /* delete the current team */
  static Future<bool> delete(String? id) async {
    final response = await http.delete(
        Uri.parse("$baseUrl/$repositoryName${id != null ? "?id=$id" : ""}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
        });
    /* Error handling for failing to delete team */
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete team.');
    }
  }

  /* Handling team member data */
  static Future<Team> getMembersTeam(String? id) async {
    final response = await http.get(
      Uri.parse(
          "$baseUrl/$repositoryName/members${id != null ? "?id=$id" : ""}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    /* Error handling for not finding team member */
    if (response.statusCode == 200) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception("Member's Team not found.");
    }
  }

  /* removing team member with teamId and userId */
  static Future<Team> removeMember(String teamId, String? userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/members/remove"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, String?>{'teamId': teamId, 'userId': userId}),
    );
    /* Error handling failed to remove member */
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to remove member.');
    }
  }
  /* invite users to the team with teamId and email */
  static Future<Team> invites(String teamID, String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, String>{'teamId': teamID, 'email': email}),
    );
    /* Error handling failed to invite user */
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to invite user.');
    }
  }

  /* accept team invite, process teamId and userId */
  static Future<Team> acceptInvites(String teamId, String userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites/accept"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, String>{'teamId': teamId, 'userId': userId}),
    );
    /* Error handling failed to accept invite */
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to accept invite.');
    }
  }
  /* reject pending invites, processing teamId and userId */
  static Future<Team> rejectInvites(String teamId, String userId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/invites/reject"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, String>{'teamId': teamId, 'userId': userId}),
    );
    /* Error handling failed to reject invite */
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to reject invite.');
    }
  }
  /* Get current invites for user with userId */
  static Future<List<Team>> getInvitesForUser(String? userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$repositoryName/invites/member"
          "${userId != null ? "?id=$userId" : ""}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    /* Error handling failed to get invites for user */
    if (response.statusCode == 200) {
      List<Team> teams = [];
      for (var element in json.decode(response.body)) {
        teams.add(Team.fromJson(element));
      }
      return teams;
    } else {
      throw Exception('Failed to get invites for User.');
    }
  }
  /* Handles payment with teamId, userId, and amount */
  static Future<Team> pay(String teamId, String userId, double amount) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/pay"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{
        'teamId': teamId,
        'userId': userId,
        'amount': amount
      }),
    );
    /* Error handling cannot reduce debt */
    if (response.statusCode == 201) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to reduce debt.');
    }
  }
}
