import 'package:Bookstore/Model/Message.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MessageService{
  static final String URL = "${dotenv.env["URL"]}/api/v1/messages";

  static Future<List<User>> getUsersWithChat(token) async{
    var response = await Dio().get(
        '$URL/',
        options: Options(
          headers: {
            "Authorization":"Bearer $token"
          }
        )
    );
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }

  static Future<List<Message>> getMessagesToUser(userId, token) async{
    var response = await Dio().get(
        '$URL/$userId',
        options: Options(
            headers: {
              "Authorization":"Bearer $token"
            }
        )
    );
    return (response.data as List).map((e) => Message.fromJson(e)).toList();
  }
}