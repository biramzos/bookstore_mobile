import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommentService{
  static final String URL = "${dotenv.env["URL"]}/api/v1/messages";

  // static Future<List<Comment>> getUsersWithChat(token) async{
  //   var response = await Dio().get(
  //       '$URL/',
  //       options: Options(
  //           headers: {
  //             "Authorization":"Bearer $token"
  //           }
  //       )
  //   );
  //   return (response.data as List).map((e) => User.fromJson(e)).toList();
  // }

}