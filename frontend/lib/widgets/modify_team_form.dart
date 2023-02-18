import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';

class ModifyTeamForm extends StatefulWidget {
  const ModifyTeamForm({Key? key}) : super(key: key);

  @override
  State<ModifyTeamForm> createState() => _ModifyTeamFormState();
}

class _ModifyTeamFormState extends State<ModifyTeamForm> {
  final formKey = GlobalKey<FormState>();
  final teamNameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const Padding(
              padding: EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(16.0),
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
