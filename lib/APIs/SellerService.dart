import 'package:Bookstore/Model/Book.dart';
import 'package:Bookstore/Model/Seller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SellerService{
  static String URL = "${dotenv.env["URL"]}/api/v1/organizations";

  static Future<Seller?> getSellerByBook(bookId, token) async{
    var response = await Dio().get(
        '$URL/books/$bookId',
    );
    return Seller.fromJson(response.data);
  }

  static Future<Seller?> getSellerById(sellerId, token) async{
    var response = await Dio().get(
        '$URL/$sellerId',
    );
    return Seller.fromJson(response.data);
  }

  static Future<List<Book>?> getSellerBooksById(sellerId, token) async{
    var response = await Dio().get(
        '$URL/$sellerId/books',
    );
    return (response.data as List).map((e) => Book.fromJson(e)).toList();
  }
}