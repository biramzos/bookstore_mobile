import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Pages/MainPage/PreviewPage/PreviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';
import 'package:translator/translator.dart';
import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/APIs/BookService.dart';
import '../../../Model/Basket.dart';

class BookPage extends StatefulWidget {
  final Book book;
  final User user;
  final bool liked;
  const BookPage({Key? key, required this.user, required this.book, required this.liked}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool? liked;
  Basket? basket;
  bool checker = false;
  String? desc;

  @override
  void initState() {
    getData();
    setState(() {
      liked = widget.liked;
    });
    super.initState();
  }

  getData() async {
    await BasketService.getCurrentBasket(widget.user.token).then(
            (value) => (setState((){
              basket = value;
            })));
    await widget.book.description!.translate(to: context.locale.languageCode).then((value) => setState((){
      desc = value.text;
    }));
  }


  @override
  Widget build(BuildContext context) {
    getData();
    setState(() {
      checker = basket!.books!.where((element) => (element.id == widget.book.id)).isNotEmpty;
    });
    if(desc == null || basket == null){
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
                          Text(
                              "description".tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                              ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '$desc',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "publisher".tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              // ClipRRect(
                              //     borderRadius: const BorderRadius.all(
                              //         Radius.elliptical(
                              //             250, 250
                              //         )
                              //     ),
                              //     child: Image.network(
                              //       UserService.linkToImage()!,
                              //       headers: {
                              //         "Authorization":"Bearer ${widget.data.token!}"
                              //       },
                              //       width: 30,
                              //     )
                              // ),
                            ],
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => PreviewPage(book: widget.book, user: widget.user,))
                                );
                              }, 
                              child: Container(
                                child: Text(
                                  "preview".tr()
                                ),
                              )
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          (checker)
                              ? TextButton(
                              onPressed: (){
                                setState(() {
                                  BasketService.removeBookToBasket(basket!.id, widget.book.id, widget.user.token);
                                  checker = false;
                                });
                              },
                              child: Text("remove_from_basket".tr())
                            )
                              : TextButton(
                              onPressed: (){
                                setState(() {
                                  BasketService.addBookToBasket(basket!.id, widget.book.id, widget.user.token);
                                  checker = true;
                                });
                              },
                              child: Text("add_to_basket".tr())
                            )
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