import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:frontend/api/users_repository.dart';
import 'package:frontend/widgets/invite_form.dart';
import 'package:frontend/widgets/member_list_widgets.dart';

import '../Types/team.dart';
import '../Types/user.dart';
import '../widgets/modify_team_form.dart';
import '../widgets/new_team_form.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Team team = Team("", "", "", false, [], []);
  bool isOwner = false;
  bool reset = true;
  User user = User("", "", "");

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
    user = await UsersRepository.get(null);
    try {
      var memberTeam = await TeamsRepository.getMembersTeam(user.id);
      memberTeam.setOwner(await UsersRepository.get(memberTeam.owner));
      List<User> members = [];
      for (var member in memberTeam.members) {
        if (member["id"] == user.id) {
          user.setDebt(member["debt"]);
        }
        User memberUser = await UsersRepository.get(member["id"]);
        memberUser.setDebt(member["debt"]);
        members.add(memberUser);
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
        const Padding(
            padding: EdgeInsets.all(20.0),
            child: Image(
              image: AssetImage('assets/images/notinteam.png'),
              height: 250,
            )),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Welcome to the team page!",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        const Padding(
          padding:
              EdgeInsets.only(left: 40.0, right: 40.0, top: 8.0, bottom: 10.0),
          child: Text(
            "Click on the button plus button to create or join a team.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        )
      ];
    }
    return [
      const Image(
        image: AssetImage('assets/images/teamnew.png'),
        height: 100,
        alignment: Alignment.topRight,
      ),
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
        padding: const EdgeInsets.all(4.0),
        child: Text("Members: ${team.members.length}",
            style: const TextStyle(fontSize: 20, color: Colors.black)),
      ),
      // Padding(
      //     padding: const EdgeInsets.all(4.0),
      //     child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           for (var name in team.members)
      //             Text(name.toString(),
      //                 style: const TextStyle(fontSize: 14, color: Colors.black))
      //         ])),
      Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text("Owner Venmo: ${team.owner.venmo ?? "N/A"}",
              style: const TextStyle(fontSize: 20, color: Colors.black))),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(getDebtText(),
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
                return MemberListWidget(team: team);
              })).then((value) => {resetPage()});
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                side: BorderSide.none,
                shape: const StadiumBorder()),
            child:
                const Text('Payments', style: TextStyle(color: Colors.black)),
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

  calculateDebt() {
    return double.parse((user.debt ?? 0).toStringAsFixed(2));
  }

  getDebtText() {
    if (calculateDebt() == 0) {
      return "You do not owe money!";
    } else if (calculateDebt() > 0) {
      return "You owe \$${calculateDebt()}";
    } else {
      return "You are owed \$${calculateDebt() * -1}";
    }
  }
}
