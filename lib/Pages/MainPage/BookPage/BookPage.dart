import 'package:Bookstore/APIs/SellerService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Model/Seller.dart';
import 'package:Bookstore/Pages/MainPage/PreviewPage/PreviewPage.dart';
import 'package:Bookstore/Pages/MainPage/SellerPage/SellerPage.dart';
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
  const BookPage({Key? key, required this.user, required this.book,}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Basket? basket;
  bool? checker;
  String? desc;
  bool? isLiked;
  Seller? seller;

  @override
  void initState() {
    getInit();
    getData();
    super.initState();
  }

  getInit() async {
    await UserService.checkFavourites(widget.user.token, widget.book.id)
        .then(
            (value) => setState((){
              isLiked = value;
            })
    );
    await SellerService.getSellerByBook(widget.book.id, widget.user.token)
        .then(
            (value) => setState(() {
                seller = value!;
              })
      );
  }

  getData() async {
    await BasketService.getCurrentBasket(widget.user.token).then(
            (value) => (setState((){
              basket = value;
            }))
    ).onError((error, stackTrace) => null);
    await widget.book.description!.translate(to: context.locale.languageCode).then((value) => setState((){
      desc = value.text;
    })).onError((error, stackTrace) => null);
    setState(() {
      checker = basket!.books!.where((element) => (element.id == widget.book.id)).isNotEmpty;
    });
  }


  @override
  Widget build(BuildContext context) {
    getData();
    if(desc == null || basket == null || checker == null || isLiked == null || seller == null){
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
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
                                            fontSize: 18,
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
                                          fontSize: 16,
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.1 * 0.1,
                                ),
                                (isLiked!)
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.favorite_outline_rounded,
                                          size: 50,
                                        ),
                                        color: Colors.red,
                                        onPressed: (){
                                          setState(() {
                                            UserService.removeFavourites(widget.user.token, widget.book.id);
                                            isLiked = false;
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
                                          isLiked = true;
                                        });
                                      },
                                    ),
                              ],
                            ),
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
                            height: 20,
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
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SellerPage(currentUser: widget.user, seller: seller!,))
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.elliptical(
                                                250, 250
                                            )
                                        ),
                                        child: Image.network(
                                          UserService.linkToImage(seller!.seller!.id)!,
                                          width: 40,
                                        )
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      seller!.name!,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
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
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: (checker!)
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
                                  ),
                            ),
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