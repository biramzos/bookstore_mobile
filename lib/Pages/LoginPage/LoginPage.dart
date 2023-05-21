// ignore_for_file: argument_type_not_assignable_to_error_handler

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../APIs/UserService.dart';
import '../MainPage/MainPage.dart';
import '../RegisterPage/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? message = "";
  final formKey = GlobalKey<FormState>();
  submit() async {
    await UserService.login(usernameController.value.text, passwordController.value.text)
        .then((value) => {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainPage(data: value!)
          ),
        )
    }, onError: (e) {
          if(e is DioError){
            setState(() {
              message = 'Something is incorrect!';
              usernameController.text = "";
              passwordController.text = "";
            });
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    const IconData book = IconData(0xf02d, fontFamily: "MyFlutterApp", fontPackage: null);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
          key: formKey,
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
                height: 100,
              ),
              const Text(
                'Sign in',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left:50,
                    top: 30,
                    right: 50,
                    bottom: 0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter username',
                  ),
                  controller: usernameController,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    return (value!.length > 5) ? (null) : ('Username is incorrect!');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left:50,
                    top: 10,
                    right: 50,
                    bottom: 0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter password',
                  ),
                  controller: passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                    validator: (value) {
                      return (value!.length > 5) ? (null) : ('Password is incorrect!');
                    }
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                message!,
                style: const TextStyle(
                    color: Colors.red
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: (() => {
                    if (formKey.currentState!.validate()) {
                      submit()
                    }
                  }),
                  child: const Text(
                      '    Sign in    ',
                    style: TextStyle(
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
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage() ));
                },
                child: const Text(
                    "Do not have an account?",
                  style: TextStyle(
                    fontSize: 15
                  ),
                ),
              ),
            ],
        )
      ),
    );
  }
}