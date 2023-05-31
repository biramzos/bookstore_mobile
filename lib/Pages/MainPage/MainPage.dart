import 'package:Bookstore/Backup/DB.dart';
import 'package:Bookstore/Components/SplashScreen.dart';
import 'package:Bookstore/Pages/MainPage/BookPage/BookPage.dart';
import 'package:Bookstore/Pages/MainPage/ChatsPage/ChatsPage.dart';
import 'package:Bookstore/Pages/MainPage/FavouritesPage/FavouritesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../Backup/Data.dart';
import '../../Model/User.dart';
import 'BasketPage/BasketPage.dart';
import 'HomePage/HomePage.dart';
import 'ProfilePage/ProfilePage.dart';
import 'SearchPage/SearchPage.dart';
import 'package:easy_localization/easy_localization.dart';


class MainPage extends StatefulWidget {
  final User data;
  const MainPage({Key? key, required this.data}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late List<Widget> fragments = [
    HomePage(data: widget.data),
    BasketPage(data: widget.data),
    SearchPage(data: widget.data),
    FavouritesPage(user: widget.data),
    ProfilePage(data: widget.data)
  ];

  @override
  void initState() {
    createStateUser() async {
      if (await DB.readUser(1) == null) {
        await DB.createUser(
          Data(
            id: 1,
            username: widget.data.username!,
            token: widget.data.token!
          )
        );
      }
    }
    createStateUser();
    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('QazaqBooks'),
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
        body: fragments[index],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                  Icons.home
              ),
              label: tr("home")
            ),
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.shopping_basket
                ),
                label: tr("basket")
            ),
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.search,
                    size: 30,
                ),
                label: tr('search')
            ),
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.favorite_outline_rounded
                ),
                label: tr('favourites')
            ),
            BottomNavigationBarItem(
                icon: const Icon(
                    Icons.account_box_rounded
                ),
                label: tr("profile"),

            )
          ],
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('do_you_want_to_exit_app'.tr()),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      exit(0);
                    }
                  },
                  child: Text('yes'.tr()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('no'.tr()),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
    );
  }
}
