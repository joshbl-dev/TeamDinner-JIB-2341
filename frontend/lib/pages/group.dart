import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:frontend/api/users_repository.dart';

import '../Types/team.dart';
import '../Types/user.dart';
import '../widgets/modify_team_form.dart';
import '../widgets/new_team_form.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Team team = Team("", "", "", "", [], []);
  bool isOwner = false;
  bool reset = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _getTeam(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var team = snapshot.data as Team;
                  return Center(
                    child: Column(
                      children: [
                        Text("Team ${team.teamName}"),
                        Text("Description: ${team.description}"),
                        Text("Owner: ${team.owner.toString()}"),
                        Text("Members: ${team.members.toString()}"),
                        Visibility(
                            visible: isOwner,
                            child: Text(
                                "Invitations: ${team.invitations.toString()}")),
                        Visibility(
                            visible: isOwner,
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.deepPurple,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ModifyTeamForm();
                                    })).then((value) => {resetPage()});
                                  },
                                  color: Colors.white,
                                  icon: const Icon(Icons.edit)),
                            ))
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: team.id == "",
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const NewTeamForm();
              })).then((value) => resetPage());
            },
            backgroundColor: Colors.deepPurple[300],
            child: const Icon(Icons.add),
          ),
        ));
  }

  Future<Team> _getTeam() async {
    if (team.id != "" && !reset) {
      return team;
    }
    print("here");
    var user = await UsersRepository.get(null);
    var memberTeam = await TeamsRepository.getMembersTeam(user.id);
    memberTeam.setOwner(await UsersRepository.get(memberTeam.owner));
    List<User> members = [];
    for (var member in memberTeam.members) {
      members.add(await UsersRepository.get(member));
    }
    memberTeam.setMembers(members);
    if (user.id == memberTeam.owner.id) {
      isOwner = true;
      List<User> invitations = [];
      for (var invitation in memberTeam.invitations) {
        invitations.add(await UsersRepository.get(invitation));
      }
      memberTeam.setInvitations(invitations);
    }
    setState(() {
      team = memberTeam;
      reset = false;
    });
    return memberTeam;
  }

  resetPage() {
    setState(() {
      reset = true;
    });
    team.id = "";
    _getTeam();
  }
}
