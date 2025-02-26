// ignore_for_file: avoid_print

import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Backup/HexColor.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:Bookstore/Pages/MainPage/ChatsPage/ChatsPage.dart';
import 'package:flutter/material.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  final User data;
  const HomePage({Key? key, required this.data}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Book>? books;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await BookService.getBooks().then((value) => setState((){
      books = value;
    })).onError((error, stackTrace) => null);
  }

  @override
  Widget build(BuildContext context) {
    const IconData book = IconData(0xf02d, fontFamily: "MyFlutterApp", fontPackage: null);
    if(books == null){
      return Scaffold(
        backgroundColor: HexColor.fromHex("#F5F7F6"),
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
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Container(
          alignment: Alignment.center,
          child: const Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Icon(
                book,
                size: 30,
                color: Colors.white,
              ),
              Text(
                'QazaqBooks',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(user: widget.data)));
              },
              icon: const Icon(Icons.chat, color: Colors.white)
          )
        ],
      ),
      backgroundColor: HexColor.fromHex("#F5F7F6"),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '${"welcome_to_app".tr()} ${widget.data.fullname}!',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Text(
                'collection'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5 * 0.3,
              width: MediaQuery.of(context).size.width * 0.98,
              child: PageView.builder(
                    itemCount: books!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return BookContainer(
                          book: books![index],
                          user: widget.data,
                      );},
                  ),
            ),
            const Divider()
          ],
        ),
      ),

      // body: Center(
      //   child: ListView.builder(
      //     itemCount: books!.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return BookContainer(
      //           book: books![index],
      //           user: widget.data,
      //       );},
      //   ),
      // ),
    );
  }
}