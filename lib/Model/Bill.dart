import 'package:Bookstore/Model/Basket.dart';
import 'package:Bookstore/Model/User.dart';

class Bill {
  final int? id;
  final Basket? basket;
  final String? paymentId;
  final User? customer;
  final String? status;
  final String? time;
  Bill(
      this.id,
      this.basket,
      this.paymentId,
      this.customer,
      this.status,
      this.time
      );

  Bill.fromJson(dynamic data):
        id = data['id'],
        basket = Basket.fromJson(data['basket']),
        paymentId = data['paymentId'],
        customer = User.fromJson(data['customer']),
        status = data['status'],
        time = data['time'];
}