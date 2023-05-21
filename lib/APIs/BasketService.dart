
import 'package:Bookstore/Model/Basket.dart';
import 'package:dio/dio.dart';

class BasketService {
  // ignore: non_constant_identifier_names
  final String URL = "http://localhost:8000/api/v1/baskets";

  Future<List<Basket>> getBaskets() async{
    var response = await Dio().get(
        '$URL/'
    );
    return (response.data as List).map((e) => Basket.fromJson(e)).toList();
  }

  Future<Basket?> getCurrentBasket(token) async{
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

  Future<void> create(token) async{
    var response = await Dio().post(
        '$URL/create',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
  }

  Future<List<Basket?>> getUserBaskets(token) async{
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

  Future<void> addBookToBasket(basketId, bookId) async{
    var response = await Dio().get(
        '$URL/$basketId/add/$basketId'
    );
  }

  Future<void> removeBookToBasket(basketId, bookId) async{
    var response = await Dio().get(
        '$URL/$basketId/remove/$basketId'
    );
  }

  Future<Basket?> payBasket(basketId) async{
    var response = await Dio().get(
        '$URL/$basketId/pay'
    );
  }

}