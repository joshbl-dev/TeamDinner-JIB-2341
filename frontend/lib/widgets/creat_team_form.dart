import 'package:flutter/material.dart';

import '../Types/user.dart';
import '../api/users_repository.dart';

class CreateTeamForm extends StatefulWidget {
  const CreateTeamForm({super.key});

  @override
  CreateTeamFormState createState() {
    return CreateTeamFormState();
  }
}

class CreateTeamFormState extends State<CreateTeamForm> {
  final formKey = GlobalKey<FormState>();
  final teamNameController = TextEditingController();

  @override
  void dispose() {
    teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: "Team Name",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add ),
            color: const Color(0xFF0069FE),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
        ],
      ),
    );
  }
}
