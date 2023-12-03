// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Backup/DB.dart';
import 'package:Bookstore/Components/SplashScreen.dart';
import 'package:Bookstore/Pages/MainPage/BoughtPage/BoughtPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Model/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:translator/translator.dart';

class ProfilePage extends StatefulWidget {
  final User data;
  const ProfilePage({Key? key, required this.data, }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Locale> options = const [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('kk', 'KZ')
  ];

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
                    "${'email'.tr()}:\n${widget.data.email}\n\n"
                        "${'username'.tr()}:\n${widget.data.username}"
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
            Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BoughtPage(user: widget.data)));
                    },
                    child: Text(
                        "bills".tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Colors.green
                        ),
                      textAlign: TextAlign.start,
                    )
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${'language'.tr()}:',
                      style: const TextStyle(
                        fontSize: 17
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    DropdownButton(
                        value: context.locale.languageCode,
                        items: options.map((Locale locale) {
                          return DropdownMenuItem<String>(
                            value: locale.languageCode,
                            child: Text(locale.languageCode.tr(),),
                          );
                        }).toList(),
                        onChanged: (lanCode) {
                          Locale? locale = options.where((element) => (element.languageCode == lanCode)).first;
                          setState(() {
                            context.setLocale(locale);
                          });
                        },
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    onPressed: () async {
                      await DB.deleteAllUser();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SplashScreen()));
                    },
                    child: Text(
                        "log_out".tr(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}