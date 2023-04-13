// Initializing the functionality of a vote
class Vote {
  String userId;
  List<String> optionIds;

  Vote(this.userId, this.optionIds);

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(json['userId'],
        json['optionIds'].map<String>((e) => e as String).toList());
  }
}
