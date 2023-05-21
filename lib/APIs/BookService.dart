
import 'package:dio/dio.dart';
import '../Model/Book.dart';

class BookService {
  // ignore: non_constant_identifier_names
  static final String URL = "http://localhost:8000/api/v1/books";

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