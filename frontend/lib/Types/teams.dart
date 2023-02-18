import 'package:frontend/Types/user.dart';

class Teams {
  String id;
  String teamName;
  String description;
  User owner;
  List<User> members;
  List<User> invitations;

  Teams(this.id, this.teamName, this.description, this.owner, this.members, this.invitations);

  factory Teams.fromJson(Map<String, dynamic> json) {
    return Teams(
        json['id'],
        json['teamName'],
        json['description'],
        json['owner'],
        json['members'],
        json['invitations'],
    );
  }
}
