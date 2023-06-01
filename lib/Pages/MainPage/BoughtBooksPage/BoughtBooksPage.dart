import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/Components/BoughtBookContainer.dart';
import 'package:Bookstore/Model/Bill.dart';
import 'package:Bookstore/Model/Book.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BoughtBooksPage extends StatefulWidget {
  final Bill bill;
  final User user;
  const BoughtBooksPage({Key? key, required this.bill, required this.user}) : super(key: key);

  @override
  State<BoughtBooksPage> createState() => _BoughtBooksPageState();
}

class _BoughtBooksPageState extends State<BoughtBooksPage> {

  List<Book>? books;

  getBooks() async{
    await BasketService.getAllBooksInBills(widget.bill.id, widget.user.token).then(
            (value) => setState((){
          books = value;
        })
    );
  }

  @override
  void initState() {
    getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(books == null){
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
    }else if(widget.bill.status != "success"){
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await getBooks();
          },
          child: Container(
            color: Colors.white,
            child: Center(
                child: Text(
                  "there_is_status_error".tr(),
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
        title: Text('${'bill'.tr()} #${widget.bill.id}'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await getBooks();
          },
          child: ListView.builder(
            itemCount: books!.length,
            itemBuilder: (BuildContext context, int index) {
              return BoughtBookContainer(
                  user: widget.user,
                  book: books![index]
              );},
          ),
        ),
      ),
    );
  }
}
