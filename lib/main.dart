import 'package:Bookstore/Backup/HexColor.dart';
import 'package:Bookstore/Components/SplashScreen.dart';
import 'package:Bookstore/Pages/LoginPage/LoginPage.dart';
import 'package:Bookstore/Pages/MainPage/MainPage.dart';
import 'package:Bookstore/Pages/RegisterPage/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey = "${dotenv.env["stripePK"]}";
  runApp(
      EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
            Locale('kk', 'KZ')
          ],
          path: 'assets/translations', // <-- change the path of the translation files
          fallbackLocale: const Locale('kk', 'KZ'),
          child: const MyApp()
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QazaqBooks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      color: Colors.white,
    );
  }
}