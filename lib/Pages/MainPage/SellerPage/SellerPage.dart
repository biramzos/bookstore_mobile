import 'package:Bookstore/APIs/SellerService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:Bookstore/Model/Book.dart';
import 'package:Bookstore/Model/Seller.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:Bookstore/Pages/MainPage/ChatPage/ChatPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SellerPage extends StatefulWidget {
  final Seller? seller;
  final User currentUser;
  const SellerPage({Key? key, required this.seller, required this.currentUser}) : super(key: key);

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {

  List<Book>? books;

  getBooks() async {
    await SellerService.getSellerBooksById(widget.seller!.id!, widget.currentUser.token).then(
            (value) => setState((){
              books = value;
            })
    ).onError((error, stackTrace) => null);
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
                expandedHeight: MediaQuery.of(context).size.height * 0.5 * 0.6,
                flexibleSpace: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          alignment: Alignment.center,
                          height: 300,
                          width: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: Image.network(
                                UserService.linkToImage(widget.seller!.seller!.id)!,
                            ),
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
                            left: 0,
                            right: 0
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 300,
                              child: Text(
                                '${widget.seller!.name}',
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
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ChatPage(currentUser: widget.currentUser, user: widget.seller!.seller!,))
                                        );
                                      },
                                      icon: const Icon(Icons.chat)
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: RefreshIndicator(
                                onRefresh: () async {

                                },
                                child: ListView.builder(
                                    itemCount: books!.length,
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return BookContainer(
                                        book: books![index],
                                        user: widget.currentUser,
                                      );}
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
