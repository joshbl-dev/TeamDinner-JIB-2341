import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/Poll.dart';
import '../util.dart';

class PollsRepository {
  static const String baseUrl = "https://team-dinner-jib-2341.vercel.app";
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "polls";

  static Future<Poll> get(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$repositoryName?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    if (response.statusCode == 200) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Poll not found.');
    }
  }

  //create
  static Future<Poll> create(Poll poll) async {
    print("Creating poll: ${poll.options}");
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{
        'topic': poll.topic,
        "description": poll.description,
        "time": poll.time.toIso8601String(),
        "location": poll.location,
        "isMultichoice": poll.isMultipleChoice,
        "options": poll.options
      }),
    );
    if (response.statusCode == 201) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create poll.');
    }
  }
}
