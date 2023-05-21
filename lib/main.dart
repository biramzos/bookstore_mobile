import 'package:Bookstore/Components/SplashScreen.dart';
import 'package:Bookstore/Pages/LoginPage/LoginPage.dart';
import 'package:Bookstore/Pages/MainPage/MainPage.dart';
import 'package:Bookstore/Pages/RegisterPage/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  Stripe.publishableKey = "pk_test_51Me7A1EPVuybY7HE1R5PygBrndNYKFT82fFISDdS1p5Nm4nMMltgkySXU8AMcyoAIf3h5SQbmFYC4XcA0YEyymWV0038TGLpWt";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookstore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: true,
      color: Colors.white,
    );
  }
}