import 'dart:async';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Backup/DB.dart';
import '../Backup/Data.dart';
import '../Model/User.dart';
import '../Pages/LoginPage/LoginPage.dart';
import '../Pages/MainPage/MainPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    getUser() async {
      int count = (await DB.queryRowCount());
      if (count == 1) {
        Data data = await DB.readUser(1);
        await UserService.authenticate(data.token)
            .then((value) => user = value).onError((error, stackTrace) async => await DB.deleteAllUser());
        Timer(
            const Duration(seconds: 4), () =>
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage(data: user!))
            )
        );
      } else {
        Timer(
            const Duration(seconds: 4), () =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder:
                    (context) =>
                (const LoginPage())
                )
            )
        );
      }
    }
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    const IconData book = IconData(0xf02d, fontFamily: "MyFlutterApp", fontPackage: null);
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.green,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: const [
              SizedBox(
                height: 150,
              ),
              Icon(
                book,
                size: 300,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "QazaqBooks",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              )
            ],
          )
        )
    );
  }
}