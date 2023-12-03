import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Pages/LoginPage/LoginPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  List<Locale> options = const [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('kk', 'KZ')
  ];

  String? username;
  String message = "";

  @override
  Widget build(BuildContext context) {
    const IconData book = IconData(0xf02d, fontFamily: "MyFlutterApp", fontPackage: null);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
          child:Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 100,
                  ),
                  Icon(
                    book,
                    size: 50,
                    color: Colors.green,
                  ),
                  Text(
                    'QazaqBooks',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 140,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left:50,
                    top: 30,
                    right: 50,
                    bottom: 0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'enter_username'.tr(),
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  onChanged: (value){
                    username = value;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  String? response = await UserService.forgetPassword(username);
                  setState(() {
                    message = response!;
                  });
                },
                child: Text(
                  "send".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
                  shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.green),
                      )
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '$message',
                style: const TextStyle(
                  fontSize: 18
                ),
                selectionColor: Colors.red,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage())
                  );
                },
                child: Text(
                  "already_have_an_account".tr(),
                  style: const TextStyle(
                      fontSize: 15
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '${'language'.tr()}:'
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
            ],
          )
      ),
    );
  }
}
