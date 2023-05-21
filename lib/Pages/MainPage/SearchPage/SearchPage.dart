import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../APIs/BookService.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';

class SearchPage extends StatefulWidget {
  final User data;
  const SearchPage({super.key, required this.data});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  BookService bookService = BookService();
  UserService userService = UserService();
  List<Book> books = [];
  List<Book> founded = [];
  String searchTerm = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var response = await BookService.getBooks();
    setState(() {
      books.addAll(response);
      _search("");
    });
  }

  _search(String searchTerm) {
    founded = [];
    if(searchTerm.isEmpty){
      setState(() {
        founded.addAll(books);
      });
    } else {
      for(var i = 0; i < books.length; i++){
        setState(() {
          if (books[i].name!.toLowerCase().contains(searchTerm.toLowerCase())) {
            founded.add(books[i]);
          } else if (books[i].author!.toLowerCase().contains(searchTerm.toLowerCase())) {
            founded.add(books[i]);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(books.isEmpty){
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
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Search...",
                ),
                onChanged: (value){
                  _search(value);
                },
                autocorrect: false,
              ),
            ),
            ListView.builder(
                itemCount: founded.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return BookContainer(
                    book: founded[index],
                    user: widget.data,
                  );}
            ),
          ],
        ),
      ),
    );
  }
}