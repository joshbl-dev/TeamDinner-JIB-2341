class Auth {
  String id;
  String email;
  String password;

  Auth(this.id, this.email, this.password);

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      json['id'],
      json['email'],
      json['password'],
    );
  }
}