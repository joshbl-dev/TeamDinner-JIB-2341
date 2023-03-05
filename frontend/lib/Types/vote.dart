class Vote {
  String userId;
  List<String> optionIds;

  Vote(this.userId, this.optionIds);

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(json['userId'], json['optionIds']);
  }
}
