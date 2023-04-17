// Initialization of poll results
import 'dart:collection';

class PollResults {
  Map<String, int> results;

  PollResults(this.results);

  factory PollResults.fromJson(Map<String, dynamic> json) {
    return PollResults(HashMap.from(json["results"]));
  }
}
