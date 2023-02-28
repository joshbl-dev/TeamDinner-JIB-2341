import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import '../api/polls.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'messages',
      ),
    );
  }
}
