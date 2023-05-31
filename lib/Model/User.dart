import 'Basket.dart';

class User {
  final int id;
  final String? fullname;
  final String? username;
  final String? email;
  final String? token;
  User(
      this.id,
      this.fullname,
      this.username,
      this.email,
      this.token
      );

  User.fromJson(dynamic data):
        id = data['id'],
        fullname = data['fullname'],
        username = data['username'],
        email = data['email'],
        token = data['token'];
}