// Initializing all possible stages of the poll
enum PollStage {
  NOT_STARTED,
  IN_PROGRESS,
  FINISHED,
}

extension PollStageExtension on PollStage {
  String get name {
    switch (this) {
      case PollStage.NOT_STARTED:
        return "NOT_STARTED";
      case PollStage.IN_PROGRESS:
        return "IN_PROGRESS";
      case PollStage.FINISHED:
        return "FINISHED";
    }
  }
}
