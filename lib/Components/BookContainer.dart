
import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:flutter/material.dart';
import '../Model/Book.dart';
import '../Model/User.dart';
import '../Pages/MainPage/BookPage/BookPage.dart';

class BookContainer extends StatelessWidget{
  final Book book;
  final User user;
  const BookContainer({super.key, required this.user, required this.book});

  @override
  Widget build(BuildContext context) {
    bool? data;
    getInit() async {
      data = await UserService.checkFavourites(user.token, book.id);
    }
    getInit();
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookPage(user: user, book: book, liked: data!)
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
                    BookService.getPreviewLinkById(book.id),
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
                          "${book.name}",
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
                          "${book.author}",
                          style: const TextStyle(
                              fontSize: 16
                          ),
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          "${book.cost.toInt()} ₸",
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