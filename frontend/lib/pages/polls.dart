import 'package:flutter/material.dart';
import 'package:frontend/Types/poll_option.dart';
import 'package:frontend/Types/poll_results.dart';
import 'package:frontend/Types/poll_stage.dart';
import 'package:frontend/Types/vote.dart';
import 'package:intl/intl.dart';

import '../Types/Poll.dart';
import '../Types/team.dart';
import '../api/polls_repository.dart';
import '../api/teams_repository.dart';
import '../api/users_repository.dart';
import '../widgets/create_poll_form.dart';
import '../widgets/poll_form.dart';
import '../widgets/split_bill_form.dart';

// Poll handling and functionality page
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
  PollResults? results;

  // Establish layout of the page
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

  // Getting poll information for processing
  Future<Poll> _getPoll() async {
    if (!reset) {
      return poll;
    }
    var user = await UsersRepository.get(null);
    try {
      Team memberTeam = await TeamsRepository.getMembersTeam(user.id);
      isOwner = memberTeam.owner == user.id;
      Poll poll = await PollsRepository.get(memberTeam.id);

      if (poll.votes != null) {
        vote = poll.votes!.firstWhere((vote) => vote.userId == user.id,
            orElse: () => Vote("", []));
      }
      PollResults? res;
      if (poll.stage == PollStage.FINISHED) {
        res = await PollsRepository.getResults(poll.id);
      }
      if (mounted) {
        setState(() {
          this.poll = poll;
          reset = false;
          results = res;
        });
      }

      return poll;
      // Error handling for no active poll
    } on Exception {
      setState(() {
        poll.description = "No active poll";
        reset = false;
      });
    }
    return poll;
  }

  // List of all the poll information topic, description, and stage processing
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
    switch (poll.stage) {
      case PollStage.NOT_STARTED:
        widgets.add(const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Poll has not started yet",
              style: TextStyle(fontSize: 20, color: Colors.black)),
        ));
        break;
      case PollStage.IN_PROGRESS:
        widgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Poll ends at ${DateFormat.jm().format(poll.time)}",
              style: const TextStyle(fontSize: 20, color: Colors.black)),
        ));
        widgets.add(PollForm(poll: poll, vote: vote));
        break;
      case PollStage.FINISHED:
        widgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Poll ended at ${DateFormat.jm().format(poll.time)}",
              style: const TextStyle(fontSize: 20, color: Colors.black)),
        ));
        break;
      case null:
        break;
    }

    if (results != null) {
      widgets.add(const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Results",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ));
      results!.results.forEach((key, value) {
        if (poll.options.any((element) => key == element.id)) {
          String name = poll.options
              .firstWhere((element) => key == element.id,
                  orElse: () => PollOption("", ""))
              .option;
          widgets.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$name: $value",
                style: const TextStyle(fontSize: 20, color: Colors.black)),
          ));
        }
      });
    }

    if (isOwner && poll.stage != null && poll.stage != PollStage.FINISHED) {
      String text =
          poll.stage == PollStage.NOT_STARTED ? "Start Poll" : "End Poll";
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                poll.stage == PollStage.NOT_STARTED ? Colors.green : Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () async {
            if (poll.stage == PollStage.NOT_STARTED) {
              await PollsRepository.startPoll(poll.id);
            } else {
              await PollsRepository.endPoll(poll.id);
            }
            resetPage();
          },
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ),
      ));
    } else if (isOwner &&
        (poll.stage == PollStage.FINISHED || poll.stage == null)) {
      widgets.add(ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              side: BorderSide.none,
              shape: const StadiumBorder()),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const CreatePollForm();
            })).then((value) => {resetPage()});
          },
          icon: const Icon(Icons.poll),
          label: const Text('Create Poll',
              style: TextStyle(color: Colors.black))));
      if (poll.stage == PollStage.FINISHED) {
        widgets.add(ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                side: BorderSide.none,
                shape: const StadiumBorder()),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SplitBillForm();
              })).then((value) => {resetPage()});
            },
            icon: const Icon(Icons.monetization_on),
            label: const Text('Split Bill',
                style: TextStyle(color: Colors.black))));
      }
    }
    return widgets;
  }

  // Used to reset the poll page when finished
  resetPage() {
    if (mounted) {
      setState(() {
        reset = true;
      });
    }
    _getPoll();
  }
}
