import 'package:Bookstore/Backup/DB.dart';
import 'package:Bookstore/Components/SplashScreen.dart';
import 'package:Bookstore/Pages/MainPage/BasketHistoryPage/BasketHostoryPage.dart';
import 'package:Bookstore/Pages/MainPage/BookPage/BookPage.dart';
import 'package:Bookstore/Pages/MainPage/FavouritesPage/FavouritesPage.dart';
import 'package:Bookstore/Pages/MainPage/PaymentPage/PaymentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../Backup/Data.dart';
import '../../Model/User.dart';
import 'BasketPage/BasketPage.dart';
import 'HomePage/HomePage.dart';
import 'ProfilePage/ProfilePage.dart';
import 'SearchPage/SearchPage.dart';

class MainPage extends StatefulWidget {
  final User data;
  const MainPage({super.key, required this.data});

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
        ),
        body: fragments[index],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.home
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.shopping_basket
                ),
                label: 'Basket'
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.search,
                    size: 30,
                ),
                label: 'Search'
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.favorite_outline_rounded
                ),
                label: 'Favourites'
            ),
            BottomNavigationBarItem(
                icon: Icon(
                    Icons.account_box_rounded
                ),
                label: "Profile"
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
              title: const Text('Do you want to exit app?'),
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
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
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
