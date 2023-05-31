import 'package:Bookstore/Model/User.dart';

class Seller{
  final int? id;
  final String? name;
  final User? seller;

  Seller(
      this.id,
      this.name,
      this.seller
      );

  Seller.fromJson(dynamic data):
        id = data['id'],
        name = data['name'],
        seller = User.fromJson(data['user']);
}