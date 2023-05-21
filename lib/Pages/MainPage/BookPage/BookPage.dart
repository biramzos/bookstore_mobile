
import 'dart:collection';

import 'package:Bookstore/APIs/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Model/Book.dart';
import '../../../Model/User.dart';

// ignore_for_file: avoid_print

import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Basket.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';

class BookPage extends StatefulWidget {
  final Book book;
  final User user;
  final bool liked;
  const BookPage({super.key, required this.user, required this.book, required this.liked});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool? liked;
  Basket? basket;
  List<Basket>? baskets;
  bool checker = false;
  BasketService basketService = BasketService();

  @override
  void initState() {
    getData();
    setState(() {
      liked = widget.liked;
      // basket!.books.map((e) => {
      //   if(e.id == widget.book.id){
      //     checker = true
      //   } else {
      //     checker = false
      //   }
      // });
    });
    super.initState();
  }

  getData() async {
    await basketService.getUserBaskets(widget.user.token).then((value) => baskets = value.cast<Basket>());
    if(baskets!.isEmpty){
      await basketService.create(widget.user.token);
      await basketService.getCurrentBasket(widget.user.token).then((value) => basket = value!);
    } else {
      await basketService.getCurrentBasket(widget.user.token).then((value) => basket = value!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.greenAccent,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.greenAccent,
              expandedHeight: MediaQuery.of(context).size.height * 0.5 * 0.8,
              flexibleSpace: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        height: 300,
                        width: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(BookService.getPreviewLinkById(widget.book.id)),
                        )
                    ),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15,
                          right: 15
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      '${widget.book.name}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 21,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold
                                      ),
                                      softWrap: false,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${widget.book.author}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${widget.book.cost.toInt()} ₸',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black87
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              (liked! == true)
                                  ? IconButton(
                                icon: const Icon(
                                    Icons.favorite_outline_rounded,
                                    size: 50,
                                ),
                                color: Colors.red,
                                onPressed: (){
                                  setState(() {
                                    UserService.removeFavourites(widget.user.token, widget.book.id);
                                    liked = false;
                                  });
                                },
                              )
                                  : IconButton(
                                icon: const Icon(
                                    Icons.favorite_outline_rounded,
                                    size: 50,
                                ),
                                color: Colors.black,
                                onPressed: (){
                                  setState(() {
                                    UserService.addFavourites(widget.user.token, widget.book.id);
                                    liked = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                              "Description",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                              ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.book.description}',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          )
                          ,
                          // (checker)
                          //     ? TextButton(
                          //     onPressed: (){
                          //       setState(() {
                          //         basketService.removeBookToBasket(basket!.id, widget.book.id);
                          //         checker = false;
                          //       });
                          //     },
                          //     child: const Text("Remove from basket")
                          //   )
                          //     : TextButton(
                          //     onPressed: (){
                          //       setState(() {
                          //         basketService.addBookToBasket(basket!.id, widget.book.id);
                          //         checker = true;
                          //       });
                          //     },
                          //     child: const Text("Add to basket")
                          //   )
                        ],
                      ),
                    )
                  ]
              ),
            )
          ],
        ),
      )
    );
  }

}