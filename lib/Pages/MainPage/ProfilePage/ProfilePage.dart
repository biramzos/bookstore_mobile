import 'dart:io';

import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Backup/DB.dart';
import 'package:Bookstore/Components/SplashScreen.dart';
import 'package:Bookstore/Pages/MainPage/PaymentPage/PaymentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Model/User.dart';

class ProfilePage extends StatefulWidget {
  final User data;
  const ProfilePage({super.key, required this.data, });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(
                        Radius.elliptical(
                            250, 250
                        )
                    ),
                    child: Image.network(
                      UserService.linkToImage(widget.data.id)!,
                      headers: {
                        "Authorization":"Bearer ${widget.data.token!}"
                      },
                      width: 100,
                    )
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  "${widget.data.fullname}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20
              ),
              child: Column(
                children: [
                  Text(
                    "Email: ${widget.data.email}\n\n"
                        "Username: ${widget.data.username}"
                        ,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              child: Text("PAYMENT PAGE"),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage()
                    )
                )
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  await DB.deleteAllUser();
                  if(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                    "Log out",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}