// ignore_for_file: invalid_return_type_for_catch_error, argument_type_not_assignable_to_error_handler, non_constant_identifier_names
import 'dart:ffi';
import 'dart:io';
import 'package:Bookstore/Model/Payment.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:dio/dio.dart';

import '../Model/Book.dart';

class PaymentService {

  final String URL = "http://localhost:8000/api/v1/payment";

  Future<Payment> login(username, password) async{
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
    return Payment.fromJson(response.data);
  }

}