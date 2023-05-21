import 'Basket.dart';

class User {
  final int id;
  final String? fullname;
  final String? username;
  final String? email;
  final String? token;
  late final List<Basket>? baskets;
  User(
      this.id,
      this.fullname,
      this.username,
      this.email,
      this.token,
      this.baskets
      );

  User.fromJson(dynamic data):
        id = data['id'],
        fullname = data['fullname'],
        username = data['username'],
        email = data['email'],
        token = data['token'],
        baskets = (data['baskets'] as List).map((e) => Basket.fromJson(e)).toList();

  Map toJson() => {
    "id": id,
    "fullname": fullname,
    "username": username,
    "email": email,
    "token": token,
    "baskets":baskets
  };
}