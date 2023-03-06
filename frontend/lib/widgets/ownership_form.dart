import 'package:flutter/material.dart';

import 'package:frontend/api/teams_repository.dart';
import '../api/users_repository.dart';
import '../homepage.dart';
import '../util.dart';
import '../Types/team.dart';
import '../Types/user.dart';

class OwnershipForm extends StatefulWidget {
  final Team team;

  const OwnershipForm({Key? key, required this.team}) : super(key: key);

  @override
  State<OwnershipForm> createState() => OwnershipFormState();
}

class OwnershipFormState extends State<OwnershipForm> {
  final formKey = GlobalKey<FormState>();
  late Team team;

  @override
  void initState() {
    super.initState();
    team = widget.team;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notification:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: IconButton(
                  color: Colors.deepPurple[300],
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                team.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                team.description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}