// ignore_for_file: invalid_return_type_for_catch_error, argument_type_not_assignable_to_error_handler, non_constant_identifier_names
import 'dart:ffi';
import 'dart:io';
import 'package:Bookstore/Model/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Model/Basket.dart';
import '../Model/Book.dart';

class UserService {

  static String URL = "${dotenv.env["URL"]}/api/v1/auth";

  static Future<User?> login(username, password) async{
    var response = await Dio().post(
        '$URL/login',
        data: <String, String>{
          'username': username,
          'password': password
        },
        options: Options(
            headers: {
              "Content-Type":"application/json",
              "Access-Control-Allow-Origin": "*"
            }
        )
    );
    return User.fromJson(response.data);
  }

  static Future<void> forgetPassword(username) async{
    var response = await Dio().get(
        '$URL/forget/password?username=$username',
        options: Options(
            headers: {
              "Content-Type":"application/json",
              "Access-Control-Allow-Origin": "*"
            }
        )
    );
  }

  static Future<User?> authenticate(token) async{
    var response = await Dio().post(
        '$URL/token/login',
        options: Options(
            headers: {
              "Content-Type":"application/json",
              "Access-Control-Allow-Origin": "*",
              "Authorization":"Bearer $token"
            }
        )
    );
    return User.fromJson(response.data);
  }



  static Future<User?> register(firstname, lastname, email, username, password, image) async{
    MultipartFile file;
    if (image != null) {
      file = await MultipartFile.fromFile(image.path);
    } else {
      ByteData byteData = await rootBundle.load('assets/images/empty.jpeg');
      Uint8List uint8List = byteData.buffer.asUint8List();
      file = MultipartFile.fromBytes(
        uint8List,
        filename: 'image.png'
      );
    }
    FormData formData = FormData.fromMap({
        'firstname': firstname,
        'secondname': lastname,
        'username': username,
        'password': password,
        'email': email,
        'image': file
    });
    var response = await Dio().post(
        '$URL/register',
        data: formData,
        options: Options(
            headers: {
              "Access-Control-Allow-Origin": "*"
            }
        )
    );
    return User.fromJson(response.data);
  }

  static String? linkToImage(int id) {
    return '$URL/user/image/$id';
  }

  static Future<List<Book>> getFavourites(token) async{
    var response = await Dio().get(
        '$URL/favourites',
        options: Options(
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Authorization":"Bearer $token"
            }
        )
    );
    return (response.data as List).map((e) => Book.fromJson(e)).toList();
  }

  static Future<void> addFavourites(token, bookId) async{
    var response = await Dio().get(
        '$URL/favourites/add/$bookId',
        options: Options(
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Authorization":"Bearer $token"
            }
        )
    );
  }

  static Future<void> removeFavourites(token, bookId) async{
    var response = await Dio().get(
        '$URL/favourites/remove/$bookId',
        options: Options(
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Authorization":"Bearer $token"
            }
        )
    );
  }

  static Future<dynamic> checkFavourites(token, bookId) async{
    var response = await Dio().get(
        '$URL/favourites/check/$bookId',
        options: Options(
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Authorization":"Bearer $token"
            }
        )
    );
    return response.data as bool?;
  }

  static Future<Basket?> getLastUserBasket(token) async{
    var response = await Dio().get(
        '$URL/baskets/last',
      options: Options(
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Authorization":"Bearer $token"
          }
      )
    );
    return Basket.fromJson(response.data);
  }

}