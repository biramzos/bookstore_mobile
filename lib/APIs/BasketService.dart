
import 'package:Bookstore/Model/Basket.dart';
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

}