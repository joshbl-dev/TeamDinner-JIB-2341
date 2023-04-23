import 'package:flutter/material.dart';
import 'package:frontend/api/polls_repository.dart';

import '../Types/Poll.dart';
import '../Types/poll_option.dart';
import '../Types/vote.dart';
import '../api/users_repository.dart';

class PollForm extends StatefulWidget {
  final Poll poll;
  final Vote? vote;

  const PollForm({Key? key, required this.poll, this.vote}) : super(key: key);

  @override
  State<PollForm> createState() => _PollFormState();
}

class _PollFormState extends State<PollForm> {
  late Poll poll;
  late List<bool> isSelected;
  late Vote? vote;

  @override
  void initState() {
    super.initState();
    poll = widget.poll;
    vote = widget.vote;
    if (vote != null && vote!.optionIds.isNotEmpty) {
      isSelected = poll.options
          .map((option) => vote!.optionIds.contains(option.id))
          .toList();
    } else {
      isSelected = List.filled(poll.options.length, false);
    }
  }

  @override
  // Functionality and format for voting in a poll
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          direction: Axis.vertical,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.red[700],
          selectedColor: Colors.white,
          fillColor: Colors.red[200],
          color: Colors.red[400],
          onPressed: (index) {
            setState(() {
              if (index != poll.options.length - 1) {
                isSelected[poll.options.length - 1] = false;
              }
              if (!poll.isMultipleChoice || index == poll.options.length - 1) {
                isSelected = List.filled(poll.options.length, false);
              }
              isSelected[index] = !isSelected[index];
            });
          },
          isSelected: isSelected,
          children: poll.options
              .map((option) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(option.toString()),
                  ))
              .toList(),
        ),
        // Button to submit your vote
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                List<String> optionIds = poll.options
                    .where((option) => isSelected[poll.options.indexOf(option)])
                    .map((option) => option.id)
                    .toList();
                var user = await UsersRepository.get(null);
                await PollsRepository.vote(poll.id, Vote(user.id, optionIds));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vote cast.')));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text('Submit Vote',
                  style: TextStyle(color: Colors.black)),
            ))
      ],
    );
  }

  // shows the user which option is currently selected by them
  Widget buildOption(PollOption option) {
    return ToggleButtons(
      isSelected: isSelected,
      children: [Text(option.toString())],
    );
  }
}
