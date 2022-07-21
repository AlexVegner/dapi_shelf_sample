class User {
  final String? id;
  final String login;
  final String password;

  User({
    this.id,
    required this.login,
    required this.password,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        login = json['login'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'password': password,
      };
  Map<String, dynamic> toJsonWithoutPassword() => {
        'id': id,
        'login': login,
      };
}
