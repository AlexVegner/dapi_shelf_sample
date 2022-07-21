import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Token {
  final String token;

  Token(
    this.token,
  );

  factory Token.create(String userId) {
    final jwt = JWT(
      {
        'id': userId,
      },
      jwtId: userId,
      issuer: 'https://github.com/daylog/daylog',
    );

    final token = jwt.sign(
      SecretKey('secret passphrase'),
      expiresIn: const Duration(hours: 1),
    );
    return Token(token);
  }

  String? uid() {
    final jwt = JWT.verify(token, SecretKey('secret passphrase'));
    print('Payload: ${jwt.payload}');
    return jwt.jwtId;
  }

  Token.fromJson(Map<String, dynamic> json) : token = json['token'];

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}
