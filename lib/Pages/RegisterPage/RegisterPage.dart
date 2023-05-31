// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../LoginPage/LoginPage.dart';
import '../MainPage/MainPage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<Locale> options = const [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('kk', 'KZ')
  ];
  late String firstname, lastname, email, username, password;
  File? image;
  String? message = "";
  final formKey = GlobalKey<FormState>();
  submit() async {
    await UserService.register(firstname, lastname, email, username, password, image)
        .then((value) => {
        Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => const LoginPage()
          ),
        )
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      setState(() {
        image = File(croppedFile!.path);
      });
    }
  }

  void _showImageSourceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a photo'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    const IconData book = IconData(0xf02d, fontFamily: "MyFlutterApp", fontPackage: null);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
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
              height: 70,
            ),
            Text(
              tr("sign_up"),
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left:50,
                  top: 30,
                  right: 50,
                  bottom: 0),
              child: Form(
                key: formKey,
                child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'enter_name'.tr(),
                    ),
                    onChanged: (value) => firstname = value,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      return (value!.length > 2) ? (null) : ('First name is empty!');
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'enter_surname'.tr(),
                    ),
                    onChanged: (value) => lastname = value,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      return (value!.length > 1) ? (null) : ('Last name is empty!');
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'enter_email'.tr(),
                    ),
                    onChanged: (value) => email = value,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      return (EmailValidator.validate(value!)) ? (null) : ('Email is incorrect!');
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'enter_username'.tr(),
                    ),
                    onChanged: (value) => username = value,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      return (value!.length > 5) ? (null) : ('Username is incorrect!');
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'enter_password'.tr(),
                    ),
                    onChanged: (value) => password = value,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      return (value!.length > 5) ? (null) : ('Password is incorrect!');
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () => _showImageSourceModal(context),
                      child: Text(
                          "image_pick".tr(),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18
                        ),
                      )
                  )
                ],
              ),
              )
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: (() => {
                if (formKey.currentState!.validate()) {
                  submit()
                }
              }),
              child: Text(
                tr("sign_up"),
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
              height: 15,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage() ));
                },
                child: Text(
                    "already_have_an_account".tr(),
                  style: const TextStyle(
                    fontSize: 16
                  ),
                ),
            ),
            const SizedBox(
              height: 30,
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
        ),
      ),
    );
  }
}