class Poll {
  String topic;
  String description;
  DateTime time;
  String location;
  bool isMultipleChoice;
  List<String> options;

  Poll(this.topic, this.description, this.time, this.location,
      this.isMultipleChoice, this.options);

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      json['topic'] as String,
      json['description'] as String,
      DateTime.parse(json['time'] as String),
      json['location'] as String,
      json['isMultipleChoice'] as bool,
      List<String>.from(json['options'] as List<dynamic>),
    );
  }
}
