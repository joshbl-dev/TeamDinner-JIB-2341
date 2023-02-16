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
}
