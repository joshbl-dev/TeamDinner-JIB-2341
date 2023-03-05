import 'package:flutter/material.dart';
import 'package:frontend/Types/vote.dart';
import 'package:frontend/pages/poll_page.dart';
import 'package:intl/intl.dart';

import '../Types/Poll.dart';
import '../Types/team.dart';
import '../api/polls_repository.dart';
import '../api/teams_repository.dart';
import '../api/users_repository.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  Poll poll = Poll("", "", "", DateTime.now(), "", false, []);
  bool isOwner = false;
  Vote vote = Vote("", []);
  bool reset = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: _getPoll(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: getPollInfo(),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Future<Poll> _getPoll() async {
    if (!reset) {
      return poll;
    }
    var user = await UsersRepository.get(null);
    try {
      Team memberTeam = await TeamsRepository.getMembersTeam(user.id);
      Poll poll = await PollsRepository.get(memberTeam.id);
      isOwner = memberTeam.owner != user.id;
      if (poll.votes != null) {
        vote = poll.votes!.firstWhere((vote) => vote.userId == user.id,
            orElse: () => Vote("", []));
      }
      if (mounted) {
        setState(() {
          this.poll = poll;
          reset = false;
        });
      }
      return poll;
    } on Exception {
      poll.description = "No active poll";
    }
    return poll;
  }

  List<Widget> getPollInfo() {
    List<Widget> widgets = [];
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(poll.topic,
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(poll.description,
          style: const TextStyle(fontSize: 20, color: Colors.black)),
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Poll ends at ${DateFormat.jm().format(poll.time)}",
          style: const TextStyle(fontSize: 20, color: Colors.black)),
    ));
    widgets.add(PollPage(poll: poll, vote: vote));
    return widgets;
  }

  resetPage() {
    if (mounted) {
      setState(() {
        reset = true;
      });
    }
    _getPoll();
  }
}
