import 'package:frontend/Types/vote.dart';

import 'poll_option.dart';
import 'poll_stage.dart';

// Initializing all the elements of the poll
class Poll {
  String id;
  String topic;
  String description;
  DateTime time;
  String location;
  bool isMultipleChoice;
  List<PollOption> options;
  List<Vote>? votes = [];
  PollStage? stage;

  Poll(this.id, this.topic, this.description, this.time, this.location,
      this.isMultipleChoice, this.options,
      [this.votes, this.stage]);

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
        json['id'] as String,
        json['topic'] as String,
        json['description'] as String,
        DateTime.parse(json['time'] as String),
        json['location'] as String,
        json['isMultichoice'] as bool,
        json["options"].map<PollOption>((e) => PollOption.fromJson(e)).toList(),
        json["votes"].map<Vote>((e) => Vote.fromJson(e)).toList(),
        PollStage.values
            .firstWhere((e) => e.toString() == 'PollStage.${json["stage"]}'));
  }
}
