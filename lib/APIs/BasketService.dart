
import 'package:Bookstore/Model/Basket.dart';
import 'package:Bookstore/Model/Bill.dart';
import 'package:Bookstore/Model/Book.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BasketService {
  // ignore: non_constant_identifier_names
  static final String URL = "${dotenv.env["URL"]}/api/v1/baskets";

  static Future<List<Basket>> getBaskets() async{
    var response = await Dio().get(
        '$URL/'
    );
    return (response.data as List).map((e) => Basket.fromJson(e)).toList();
  }

  static Future<Basket?> getCurrentBasket(token) async{
    var response = await Dio().get(
        '$URL/current/basket',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
    return Basket.fromJson(response.data);
  }

  static Future<Bill?> generateBill(int basketId, String paymentId, String status, String token) async{
    dynamic data = {
      'paymentId': paymentId,
      'status': status
    };
    var response = await Dio().post(
        '$URL/$basketId/payed',
        data: data,
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
    return Bill.fromJson(response.data);
  }

  static Future<void> create(token) async{
    var response = await Dio().post(
        '$URL/create',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
  }

  static Future<List<Basket?>> getUserBaskets(token) async{
    var response = await Dio().get(
        '$URL/user',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
    return (response.data as List).map((e) => Basket.fromJson(e)).toList();
  }

  static Future<void> addBookToBasket(basketId, bookId, token) async{
    var response = await Dio().get(
        '$URL/$basketId/add/$bookId',
        options: Options(
          headers: {
            "Authorization":"Bearer $token"
          }
        )
    );
  }

  static Future<void> removeBookToBasket(basketId, bookId, token) async{
    var response = await Dio().get(
        '$URL/$basketId/remove/$bookId',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
  }

  static Future<Basket?> payBasket(basketId, token) async{
    var response = await Dio().get(
        '$URL/$basketId/pay',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
  }

  static Future<List<Bill>?> getAllBillsOfUser(token) async{
    var response = await Dio().get(
        '$URL/get-bills',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
    return (response.data as List).map((e) => Bill.fromJson(e)).toList();
  }

  static Future<List<Book>?> getAllBooksInBills(billId, token) async{
    var response = await Dio().get(
        '$URL/bills/$billId/books',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
    return (response.data as List).map((e) => Book.fromJson(e)).toList();
  }

}