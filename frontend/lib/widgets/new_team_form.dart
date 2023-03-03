import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:frontend/api/users_repository.dart';

import '../Types/team.dart';
import '../Types/user.dart';

class NewTeamForm extends StatefulWidget {
  const NewTeamForm({Key? key}) : super(key: key);

  @override
  State<NewTeamForm> createState() => _NewTeamFormState();
}

class _NewTeamFormState extends State<NewTeamForm> {
  final formKey = GlobalKey<FormState>();
  final teamNameController = TextEditingController();
  final descriptionController = TextEditingController();
  late List<Team> teams = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
  }

  asyncInit() async {
    List<Team> teams = await TeamsRepository.getInvitesForUser(null);
    setState(() {
      this.teams = teams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const Text(
              "Pending Invitations",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: List.generate(teams.length, (index) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                          teams[index].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          Team team = teams[index];
                          try {
                            User user = await UsersRepository.get(null);
                            await TeamsRepository.acceptInvites(
                                team.id, user.id);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Failed to accept invite.")));
                          }
                        },
                        iconSize: 30,
                        color: Colors.lightGreen,
                        icon: const Icon(Icons.check_circle_outline),
                      ),
                      IconButton(
                        onPressed: () async {
                          Team team = teams[index];
                          try {
                            User user = await UsersRepository.get(null);
                            await TeamsRepository.rejectInvites(
                                team.id, user.id);
                            setState(() {
                              teams.removeWhere(
                                  (element) => element.id == team.id);
                            });
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Failed to remove invite.")));
                          }
                        },
                        iconSize: 30,
                        color: Colors.black45,
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                "Create a Team",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: teamNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a team name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Team Name",
                        prefixIcon: Icon(Icons.abc, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Description",
                        prefixIcon: Icon(Icons.abc, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.deepPurple[300],
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var teamName = teamNameController.value.text;
                          var description = descriptionController.value.text;
                          try {
                            await TeamsRepository.create(teamName, description);
                            teamNameController.clear();
                            descriptionController.clear();
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to create team"),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
