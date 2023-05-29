import 'package:dio/dio.dart';
import '../Model/Book.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BookService {
  // ignore: non_constant_identifier_names
  static final String URL = "${dotenv.env["URL"]}/api/v1/books";

  static Future<List<Book>> getBooks() async{
    var response = await Dio().get(
        '$URL/'
    );
    return (response.data as List).map((e) => Book.fromJson(e)).toList();
  }

  static String getPreviewLinkById(int bookId) {
    return '$URL/$bookId/preview';
  }
}