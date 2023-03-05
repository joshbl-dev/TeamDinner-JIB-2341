import 'PollOption.dart';

class Poll {
  String id;
  String topic;
  String description;
  DateTime time;
  String location;
  bool isMultipleChoice;
  List<PollOption> options;

  Poll(this.id, this.topic, this.description, this.time, this.location,
      this.isMultipleChoice, this.options);

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
        json['id'] as String,
        json['topic'] as String,
        json['description'] as String,
        DateTime.parse(json['time'] as String),
        json['location'] as String,
        json['isMultichoice'] as bool,
        json["options"]
            .map<PollOption>((e) => PollOption.fromJson(e))
            .toList());
  }
}
