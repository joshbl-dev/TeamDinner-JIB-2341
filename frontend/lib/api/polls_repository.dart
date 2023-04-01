import 'dart:convert';

import 'package:frontend/Types/poll_results.dart';
import 'package:frontend/Types/poll_stage.dart';
import 'package:http/http.dart' as http;

import '../Types/Poll.dart';
import '../Types/vote.dart';
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
      Poll poll = Poll.fromJson(json.decode(response.body));
      return poll;
    } else {
      throw Exception('Poll not found.');
    }
  }

  static Future<PollResults> getResults(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$repositoryName/results?id=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    if (response.statusCode == 200) {
      PollResults results = PollResults.fromJson(json.decode(response.body));
      return results;
    } else {
      throw Exception('Poll Results not found.');
    }
  }

  //create
  static Future<Poll> create(Poll poll) async {
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
        "options": poll.options.map((e) => e.option).toList()
      }),
    );
    if (response.statusCode == 201) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create poll.');
    }
  }

  static Future<Poll> vote(String pollId, Vote vote) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/vote"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{
        "pollId": pollId,
        "userId": vote.userId,
        "optionIds": vote.optionIds
      }),
    );
    if (response.statusCode == 201) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to vote on poll.');
    }
  }

  static Future<Poll> startPoll(String pollId) async {
    return changeStage(pollId, PollStage.IN_PROGRESS);
  }

  static Future<Poll> endPoll(String pollId) async {
    return changeStage(pollId, PollStage.FINISHED);
  }

  static Future<Poll> changeStage(String pollId, PollStage stage) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/stage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body:
          jsonEncode(<String, dynamic>{"pollId": pollId, "stage": stage.name}),
    );
    if (response.statusCode == 201) {
      return Poll.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to vote on poll.');
    }
  }

  static Future<void> split(double amount) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/split"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{"amount": amount}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to split payments.');
    }
  }
}
