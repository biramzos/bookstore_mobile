import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Basket.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:translator/translator.dart';

class BasketHistoryPage extends StatefulWidget {
  final User data;
  const BasketHistoryPage({Key? key, required this.data}) : super(key: key);

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
    await BasketService.getUserBaskets(widget.data.token).then((value) => baskets = value.cast<Basket>());
    if(widget.data.baskets!.isEmpty){
      await BasketService.create(widget.data.token);
      await BasketService.getCurrentBasket(widget.data.token).then((value) => basket = value!.books);
    } else {
      await BasketService.getCurrentBasket(widget.data.token).then((value) => basket = value!.books);
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