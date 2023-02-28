import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:frontend/api/users_repository.dart';
import 'package:frontend/widgets/invite_form.dart';
import 'package:frontend/widgets/poll_form.dart';

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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: getTeamInfo(),
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
          visible: isOwner || team.id == "",
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                if (isOwner) {
                  return InviteForm(
                    team: team,
                  );
                } else {
                  return const NewTeamForm();
                }
              })).then((value) => resetPage());
            },
            backgroundColor: Colors.deepPurple[300],
            child: const Icon(Icons.add),
          ),
        ));
  }

  Future<Team> _getTeam() async {
    if (!reset) {
      return team;
    }
    var user = await UsersRepository.get(null);
    try {
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
      if (mounted) {
        setState(() {
          team = memberTeam;
          reset = false;
        });
      }
      return memberTeam;
    } on Exception {
      team.description = "You are not in a team";
    }
    return team;
  }

  getTeamInfo() {
    if (team.name == "") {
      return [
        const Text("You are not in a team",
            style: TextStyle(fontSize: 30, color: Colors.black))
      ];
    }
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Team: ${team.name}",
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Description: ${team.description}",
            style: const TextStyle(fontSize: 20, color: Colors.black)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Owner: ${team.owner.toString()}",
            style: const TextStyle(fontSize: 20, color: Colors.black)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Members: ${team.members.toString()}",
            style: const TextStyle(fontSize: 20, color: Colors.black)),
      ),
      Visibility(
          visible: isOwner,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ModifyTeamForm(team: team);
              })).then((value) => {resetPage()});
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                side: BorderSide.none,
                shape: const StadiumBorder()),
            child:
                const Text('Edit Team', style: TextStyle(color: Colors.black)),
          )),
      Visibility(
          visible: isOwner,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PollForm();
              })).then((value) => {resetPage()});
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                side: BorderSide.none,
                shape: const StadiumBorder()),
            child:
            const Text('Create Poll', style: TextStyle(color: Colors.black)),
          )),
      Visibility(
        visible: !isOwner && team.id != "",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RawMaterialButton(
            onPressed: () async {
              try {
                await TeamsRepository.removeMember(team.id, null);
                if (mounted) {
                  setState(() {
                    team = Team("", "", "", "", [], []);
                    reset = true;
                  });
                }
              } on Exception {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Could not leave team"),
                ));
              }
            },
            fillColor: Colors.red,
            padding: const EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            child: const Text("Leave Team",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      )
    ];
  }

  resetPage() {
    if (mounted) {
      setState(() {
        reset = true;
      });
    }
    _getTeam();
  }
}
