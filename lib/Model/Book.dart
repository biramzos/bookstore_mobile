import 'package:Bookstore/Model/File.dart';

class Book {
  final int id;
  final String? name;
  final String? author;
  final String? description;
  final File? file;
  final double cost;
  Book(
      this.id,
      this.name,
      this.author,
      this.description,
      this.cost,
      this.file
      );

  factory Book.fromJson(Map<String, dynamic> data){
    return Book(
        data['id'],
        data['name'],
        data['author'],
        data['description'],
        data['cost'],
        File.fromJson(data['file'])
    );
  }
}