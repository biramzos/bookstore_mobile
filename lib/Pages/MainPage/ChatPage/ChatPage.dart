// ignore_for_file: non_constant_identifier_names

import 'package:Bookstore/APIs/MessageService.dart';
import 'package:Bookstore/Components/MessageContainer.dart';
import 'package:Bookstore/Model/Message.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:Bookstore/Pages/MainPage/ChatsPage/ChatsPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatPage extends StatefulWidget {
  final User currentUser;
  final User user;
  const ChatPage({Key? key, required this.currentUser, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  List<Message>? messages;
  String? message;
  StompClient? client;

  @override
  void initState() {
    super.initState();
    getData();
    connectToServer();
  }

  getData() async{
    await MessageService.getMessagesToUser(widget.user.id, widget.currentUser.token).then(
            (value) => setState((){
              messages = value;
            })
    );
  }

  void connectToServer() async {
    client = StompClient(
        config: StompConfig.SockJS(
            url: '${dotenv.env['URL']}/chat',
            onConnect: onConnect,
            beforeConnect: () async {
              print('waiting to connect...');
              await Future.delayed(const Duration(milliseconds: 200));
              print('connecting...');
            },
            onWebSocketError: (dynamic error) => print(error.toString())
        )
    );
    client!.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connected to server');
    client!
        .subscribe(
        destination: '/queue/messages',
        headers: {
          'Content-Type':'application/json',
          'Access-Control-Allow-Origin':'*',
          "Authorization":"Bearer ${widget.currentUser.token}"
        },
        callback: (frame) {
          if (frame.body != null) {
            Map<String, dynamic> result = json.decode(frame.body!);
            messages!.add(Message.fromJson(result));
          }
        });
  }

  void sendMessage(String message) {
    String formattedDateTime = DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now());
    var m = jsonEncode({
      'sender': widget.currentUser.username,
      'content': message,
      'receiver': widget.user.username,
      'time': formattedDateTime
    });
    client!.send(
      destination: '/app/chat',
      body: m,
    );
  }

  @override
  void dispose() {
    client!.deactivate();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.user.username!),
          backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: messages!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageContainer(message: messages![index], isMe: (messages![index].sender! == widget.currentUser.username!),);
                  }
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "type_a_message".tr()
                      ),
                      onChanged: (value){
                        message = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green,),
                    onPressed: () {
                      sendMessage(message!);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
