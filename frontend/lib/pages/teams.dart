import 'package:flutter/material.dart';
import 'package:frontend/api/teams_repository.dart';
import 'package:frontend/api/users_repository.dart';
import 'package:frontend/widgets/invite_form.dart';
import 'package:frontend/widgets/member_list_widgets.dart';
import 'package:intl/intl.dart';

import '../Types/team.dart';
import '../Types/user.dart';
import '../widgets/modify_team_form.dart';
import '../widgets/new_team_form.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  State<TeamPage> createState() => _TeamPageState();
}

// Layout and functions of the team page
class _TeamPageState extends State<TeamPage> {
  Team team = Team("", "", "", false, [], []);
  bool isOwner = false;
  bool reset = true;
  User user = User("", "", "");

  @override
  // layout of the body of the team page
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
        // determining what the user sees depending on if they are the owner or just user
        floatingActionButton: Visibility(
          visible: isOwner || team.id == "",
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                // If they are the owner there is an invite form, if not they can make a team
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

  // processing user info of the team
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
      // Error handling for not being in a team
      return memberTeam;
    } on Exception {
      team.description = "You are not in a team";
    }
    return team;
  }

  getTeamInfo() {
    // Layout of the page when you are not in the team
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
            "Click on the plus button to create or join a team.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        )
      ];
    }
    // Layout of the team page when in a team, has team icon and lists, teamName, Description, Owner, and Members
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(team.name,
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      const Image(
        image: AssetImage('assets/images/teamnew.png'),
        height: 100,
        alignment: Alignment.topRight,
      ),
      Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Description: ${team.description}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 18, color: Colors.black)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Owner: ${team.owner.toString()}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 18, color: Colors.black)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Members: ${team.members.length}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 18, color: Colors.black)),
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
      // Display the owners venmmo with how much the user owes
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Owner Venmo: ${team.owner.venmo ?? "N/A"}",
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 18, color: Colors.black))),

      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(getDebtText(),
            style: const TextStyle(fontSize: 18, color: Colors.black)),
      ),
      // Edit team button is visible if you are the owner
      Divider(),
      Visibility(
          visible: isOwner,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ModifyTeamForm(team: team);
              })).then((value) => {resetPage()});
            },
            icon: const Icon(Icons.edit),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                side: BorderSide.none,
                shape: const StadiumBorder()),
            label:
                const Text('Edit Team', style: TextStyle(color: Colors.black)),
          )),
      // Payments are visible if you are the owner
      Visibility(
          visible: isOwner,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MemberListWidget(team: team);
              })).then((value) => {resetPage()});
            },
            icon: const Icon(Icons.payment),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                side: BorderSide.none,
                shape: const StadiumBorder()),
            label:
                const Text('Payments', style: TextStyle(color: Colors.black)),
          )),
      // Both owner and user can see the leave team button
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
                // Error handling for not being able to leave the team
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

  // this resets the entire team page
  resetPage() {
    if (mounted) {
      setState(() {
        reset = true;
      });
    }
    _getTeam();
  }

  // calculation for debit for the users
  calculateDebt() {
    return user.debt ?? 0;
  }

  getDebtText() {
    final debt = calculateDebt();
    if (debt == 0) {
      return "You do not owe money!";
    } else if (debt > 0) {
      return "You owe ${NumberFormat.simpleCurrency().format(debt)}";
    } else {
      return "You are owed ${NumberFormat.simpleCurrency().format(-debt)}";
    }
  }
}
