// ignore_for_file: avoid_print
import 'package:translator/translator.dart';
import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Basket.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';
import 'package:easy_localization/easy_localization.dart';


class BasketPage extends StatefulWidget {
  final User data;
  const BasketPage({Key? key, required this.data}) : super(key: key);

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  BookService bookService = BookService();
  BasketService basketService = BasketService();
  UserService userService = UserService();
  List<Book>? basket;
  List<Basket>? baskets;

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  getData() async {
    await BasketService.getUserBaskets(widget.data.token)
        .then(
            (value) => (setState((){
              baskets = value.cast<Basket>();
            })));
    await BasketService.getCurrentBasket(widget.data.token)
        .then(
            (value) => (setState((){
              basket = value!.books;
            })));
  }

  @override
  Widget build(BuildContext context) {
    if(basket == null){
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
    else if(basket!.isEmpty){
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            getData();
          },
          child: Container(
            color: Colors.white,
            child: const Center(
                child: Text(
                  "There is no books!",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30
                  ),
                )
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: Center(
          child: ListView.builder(
            itemCount: basket!.length,
            itemBuilder: (BuildContext context, int index) {
              return BookContainer(
                  book: basket![index],
                  user: widget.data,
              );},
          ),
        ),
      ),
    );
  }
}