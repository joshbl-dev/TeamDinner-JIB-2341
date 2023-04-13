import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:frontend/api/users_repository.dart';

import '../Types/team.dart';
import '../Types/user.dart';

class InviteForm extends StatefulWidget {
  final Team team;

  const InviteForm({Key? key, required this.team}) : super(key: key);

  @override
  State<InviteForm> createState() => _InviteFormState();
}
// Functionality of creating invites
class _InviteFormState extends State<InviteForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late Team team;

  @override
  void initState() {
    super.initState();
    team = widget.team;
  }

  @override
  // Formatting and layout of the invitations page
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Invitations:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: List.generate(team.invitations.length, (index) {
                  return Row(
                    children: [
                      Text(team.invitations[index].toString()),
                      IconButton(
                        onPressed: () async {
                          var user = team.invitations[index];
                          try {
                            await TeamsRepository.rejectInvites(
                                team.id, user.id);
                            setState(() {
                              team.invitations.remove(user);
                            });
                            // Error Handling for failing to remove invite
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Failed to remove invite.")));
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  );
                }),
              ),
            ),
            // button to invite team members
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
                "Invite team members",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Text field for inviting new members using their email
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                      ),
                    ),
                  ),
                  // button to invite members
                  SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.deepPurple[300],
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var email = emailController.value.text;
                          try {
                            Team team = await TeamsRepository.invites(
                                this.team.id, email);
                            emailController.clear();

                            for (var element in this.team.invitations) {
                              team.invitations.remove(element.id);
                            }
                            if (team.invitations.isNotEmpty) {
                              User newMember = await UsersRepository.get(
                                  team.invitations[0]);
                              setState(() {
                                this.team.invitations.add(newMember);
                              });
                            }
                            // Invite sent confirmation
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Invite sent"),
                              ));
                            }
                            // Error handling for failing to invite a member
                          } on Exception {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to invite member"),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Invite",
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
