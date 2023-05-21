// ignore_for_file: avoid_print

import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Basket.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';

class BasketHistoryPage extends StatefulWidget {
  final User data;
  const BasketHistoryPage({super.key, required this.data});

  @override
  State<BasketHistoryPage> createState() => _BasketHistoryPageState();
}

class _BasketHistoryPageState extends State<BasketHistoryPage> {
  BookService bookService = BookService();
  BasketService basketService = BasketService();
  UserService userService = UserService();
  List<Book> basket = [];
  List<Basket> baskets = [];

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  getData() async {
    await basketService.getUserBaskets(widget.data.token).then((value) => baskets = value.cast<Basket>());
    if(widget.data.baskets!.isEmpty){
      await basketService.create(widget.data.token);
      await basketService.getCurrentBasket(widget.data.token).then((value) => basket = value!.books);
    } else {
      await basketService.getCurrentBasket(widget.data.token).then((value) => basket = value!.books);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: baskets.length,
          itemBuilder: (BuildContext context, int index) {
            return BookContainer(
              book: basket[index],
              user: widget.data,
            );},
        ),
      ),
    );
  }
}