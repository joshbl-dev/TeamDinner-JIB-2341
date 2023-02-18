class User {
  String? id;
  String firstName;
  String lastName;

  User(this.firstName, this.lastName, [this.id]);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['firstName'], json['lastName'], json['id']);
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }
}
