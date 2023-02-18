import 'package:frontend/Types/user.dart';

class Team {
  String id;
  String teamName;
  String description;
  User owner;
  List<User> members;
  List<User> invitations;

  Team(this.id, this.teamName, this.description, this.owner, this.members, this.invitations);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        json['id'],
        json['teamName'],
        json['description'],
        json['owner'],
        json['members'],
        json['invitations'],
    );
  }
}
