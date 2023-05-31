import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/SellerService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Model/Seller.dart';
import 'package:flutter/material.dart';
import '../Model/Book.dart';
import '../Model/User.dart';
import '../Pages/MainPage/BookPage/BookPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:translator/translator.dart';

class BookContainer extends StatefulWidget {
  final Book book;
  final User user;
  const BookContainer({Key? key, required this.user, required this.book}) : super(key: key);

  @override
  State<BookContainer> createState() => BookContainerState();
}

class BookContainerState extends State<BookContainer>{

  Seller? seller;
  bool? data;

  getInit() async {
    data = await UserService.checkFavourites(widget.user.token, widget.book.id);
    await SellerService.getSellerByBook(widget.book.id, widget.user.token).then(
            (value) => setState((){
          seller = value!;
        })
    );
  }

  @override
  void initState() {
    getInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(seller == null || data == null){
      return const Card(
        margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        shadowColor: Colors.black87,
        child: const Center(
            child: const CircularProgressIndicator()
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookPage(
                        user: widget.user, book: widget.book, liked: data!, seller: seller!)
            )
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        shadowColor: Colors.black87,
        child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Image.network(
                    BookService.getPreviewLinkById(widget.book.id),
                    width: 70,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 290,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '${widget.book.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          '${widget.book.author}',
                          style: const TextStyle(
                              fontSize: 16
                          ),
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          "${widget.book.cost.toInt()} ₸",
                          softWrap: false,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 15
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}