import 'package:frontend/Types/user.dart';

class Team {
  String id;
  String teamName;
  String description;
  dynamic owner;
  List<dynamic> members;
  List<dynamic> invitations;

  Team(this.id, this.teamName, this.description, this.owner, this.members,
      this.invitations);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      json['id'],
      json['name'],
      json['description'],
      json['owner'],
      json['members'],
      json['invitations'],
    );
  }

  setOwner(User owner) {
    this.owner = owner;
  }

  setMembers(List<User> members) {
    this.members = members;
  }

  setInvitations(List<User> invitations) {
    this.invitations = invitations;
  }
}
