import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';

import '../Types/team.dart';

class ModifyTeamForm extends StatefulWidget {
  final Team team;

  const ModifyTeamForm({Key? key, required this.team}) : super(key: key);

  @override
  State<ModifyTeamForm> createState() => _ModifyTeamFormState();
}

class _ModifyTeamFormState extends State<ModifyTeamForm> {
  final formKey = GlobalKey<FormState>();
  final teamNameController = TextEditingController();
  final descriptionController = TextEditingController();
  late Team team;

  @override
  void initState() {
    super.initState();
    team = widget.team;
    teamNameController.text = team.name;
    descriptionController.text = team.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Visibility(
                visible: team.members.length > 1,
                child: Column(children: [
                  const Text(
                    "Members:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: List.generate(team.members.length, (index) {
                        if (team.members[index].id == team.owner.id) {
                          return const SizedBox();
                        }
                        return Row(
                          children: [
                            Text(team.members[index].toString()),
                            IconButton(
                              onPressed: () async {
                                var user = team.members[index];
                                try {
                                  await TeamsRepository.removeMember(
                                      team.id, user.id);
                                  setState(() {
                                    team.members.remove(user);
                                  });
                                } on Exception {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Failed to remove member.")));
                                }
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ])),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Modify you team",
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
                            await TeamsRepository.update(teamName, description);
                            teamNameController.clear();
                            descriptionController.clear();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Team updated"),
                                ),
                              );
                            }
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to update team"),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RawMaterialButton(
                        fillColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              await TeamsRepository.delete(null);
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            } on Exception {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to delete team"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
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
