// ignore_for_file: avoid_print

import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:translator/translator.dart';

import '../ChatsPage/ChatsPage.dart';

class FavouritesPage extends StatefulWidget {
  final User user;
  const FavouritesPage({Key? key, required this.user}) : super(key: key);

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
    else if(books!.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "basket".tr(),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white
            ),
          ),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(user: widget.user)));
                },
                icon: const Icon(Icons.chat, color: Colors.white)
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await getData();
          },
          child: Container(
            color: Colors.white,
            child: Center(
              child: Text(
                "there_is_no_books".tr(),
                style: const TextStyle(
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
      appBar: AppBar(
        title: Text(
          "basket".tr(),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(user: widget.user)));
              },
              icon: const Icon(Icons.chat, color: Colors.white)
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getData();
        },
        child: Center(
          child: ListView.builder(
            itemCount: books!.length,
            itemBuilder: (BuildContext context, int index) {
              return BookContainer(
                book: books![index],
                user: widget.user,
              );},
          ),
        ),
      ),
    );
  }
}