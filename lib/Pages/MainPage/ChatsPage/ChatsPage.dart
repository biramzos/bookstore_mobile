import 'package:Bookstore/APIs/MessageService.dart';
import 'package:Bookstore/Components/UserContainer.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:Bookstore/Pages/MainPage/ChatPage/ChatPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../Backup/HexColor.dart';

class ChatsPage extends StatefulWidget {
  final User user;
  const ChatsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<User>? users;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  getUsers() async {
    await MessageService.getUsersWithChat(widget.user.token)
        .then((value) =>
        setState((){
          users = value;
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    if(users == null){
      return Scaffold(
        backgroundColor: HexColor.fromHex("#F5F7F6"),
        appBar: AppBar(
          title: const Text('QazaqBooks'),
          backgroundColor: Colors.green,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              'assets/images/loader.gif',
              width: 200,
              height: 200,
            ),
          ),
        ),
      );
    } else if(users!.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: const Text('QazaqBooks'),
          backgroundColor: Colors.green,
        ),
        backgroundColor: HexColor.fromHex("#F5F7F6"),
        body: RefreshIndicator(
          onRefresh: () async {
            await getUsers();
          },
          child: Container(
            color: Colors.white,
            child: Center(
                child: Text(
                  "there_is_no_users".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30
                  ),
                )
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('chats_seller'.tr()),
        backgroundColor: Colors.green,
      ),
      backgroundColor: HexColor.fromHex("#F5F7F6"),
      body: RefreshIndicator(
        onRefresh: () async {
          await getUsers();
        },
        child: Center(
          child: ListView.builder(
            itemCount: users!.length,
            itemBuilder: (BuildContext context, int index) {
              return UserContainer(
                user: users![index],
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(user: users![index], currentUser: widget.user,)));
                },
              );},
          ),
        ),
      ),
    );
  }
}
