import 'package:flutter/material.dart';
import 'package:frontend/widgets/new_team_form.dart';

class CreateNewTeamPage extends StatelessWidget {
  const CreateNewTeamPage({Key? key}) : super(key: key);

  @override
  // Formatting of creating a new team
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: IconButton(
                  color: const Color(0xFF0069FE),
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
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Create New Team",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Call new team form to load all functions of creating a new team
            const NewTeamForm(),
          ],
        ),
      ),
    );
  }
}
