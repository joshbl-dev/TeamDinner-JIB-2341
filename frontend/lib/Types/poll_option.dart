// Initializing the options within the poll
class PollOption {
  String id;
  String option;

  PollOption(this.id, this.option);

  factory PollOption.fromJson(json) {
    return PollOption(json['id'], json['option']);
  }

  @override
  String toString() {
    return option;
  }
}
