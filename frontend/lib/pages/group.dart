import 'package:flutter/material.dart';
import 'package:frontend/Types/user.dart';
import 'package:frontend/api/teams_repository.dart';

import '../Types/teams.dart';
import '../widgets/new_team_form.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
         future: _getTeam(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var team = snapshot.data as Team;
              return Center(
                child: Text(team.teamName)
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
      ),
      // plus button on bottom right corner of page
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const NewTeamForm()),
          // );
        },
        backgroundColor: Colors.deepPurple[300],
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<User> _getTeam() async {
    return await TeamsRepository.get("60f9b0f1e4b0b8b2b8d0b0d1");
  }
}
