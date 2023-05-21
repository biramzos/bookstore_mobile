// ignore_for_file: avoid_print

import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';

class HomePage extends StatefulWidget {
  final User data;
  const HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserService userService = UserService();
  List<Book> books = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var response = await BookService.getBooks();
    setState(() {
      books.addAll(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            return BookContainer(
                book: books[index],
                user: widget.data,
            );},
        ),
      ),
    );
  }
}