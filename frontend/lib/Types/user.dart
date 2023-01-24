class User {
  String firstName;
  String lastName;

  User(this.firstName, this.lastName);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['firstName'],
      json['lastName'],
    );
  }
}
