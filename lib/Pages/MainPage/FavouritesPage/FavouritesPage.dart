// ignore_for_file: avoid_print

import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';

class FavouritesPage extends StatefulWidget {
  final User user;
  const FavouritesPage({super.key, required this.user});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Book>? books;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var response = await UserService.getFavourites(widget.user.token);
    setState(() {
      books = response;
    });
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(books == null) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              'assets/images/loader.gif',
              width: 200,
              height: 200,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: books!.length,
          itemBuilder: (BuildContext context, int index) {
            return BookContainer(
              book: books![index],
              user: widget.user,
            );},
        ),
      ),
    );
  }
}