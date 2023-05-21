import 'dart:ffi';
import 'Book.dart';

class Basket {
  final int id;
  final String? date;
  final List<Book> books;
  final String? status;
  Basket(
      this.id,
      this.date,
      this.books,
      this.status,
      );

  factory Basket.fromJson(Map<String, dynamic> data){
    return Basket(
        data['id'],
        data['date'],
        (data['books'] as List).map((e) => Book.fromJson(e)).toList(),
        data['status']
    );
  }

  Map toJson() => {
    "id": id,
    "date": date,
    "books": books,
    "status": status
  };
}