import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../APIs/BookService.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:translator/translator.dart';

class SearchPage extends StatefulWidget {
  final User data;
  const SearchPage({Key? key, required this.data}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  BookService bookService = BookService();
  UserService userService = UserService();
  List<Book> books = [];
  List<Book> founded = [];
  String searchTerm = "";
  List<String> options = [
    'Study',
    'Classic',
    'Horror'
  ];
  Set<String> selectedItems = {};

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
              child: Row(
                children: [
                  Container(
                    width: 360,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "${"search".tr()}...",
                      ),
                      onChanged: (value){
                        _search(value);
                      },
                      autocorrect: false,
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        print(List.from(selectedItems));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Modal Window'),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final item = options[index];
                                    bool isSelected = selectedItems.contains(item);
                                    return CheckboxListTile(
                                      title: Text(item),
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isSelected = value!;
                                        });
                                        if (isSelected) {
                                          selectedItems.add(item);
                                        } else {
                                          selectedItems.remove(item);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text("close".tr()),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.settings_suggest)
                  )
                ]
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