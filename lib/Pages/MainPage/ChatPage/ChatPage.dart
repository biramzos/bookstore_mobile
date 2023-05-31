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
  String? content;
  StompClient? client;

  @override
  void initState() {
    getData();
    connectToServer();
    super.initState();
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
            onWebSocketError: (dynamic error) => print(error.toString())
        )
    );
    client!.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connected to server');
    client!
        .subscribe(
        destination: '/user/queue/messages',
        callback: (frame) {
          if (frame.body != null) {
            Map<String, dynamic> result = json.decode(frame.body!);
            setState(() {
              messages!.add(Message.fromJson(result));
            });
            print(jsonEncode(result));
          }
        });
  }

  void sendMessage(String message) {
    var date = DateTime.now();
    var dateYear = '${date.year}';
    var dateMonth = (date.month >= 10) ? '${date.month}' : '0${date.month}';
    var dateDay = (date.day >= 10) ? '${date.day}' : '0${date.day}';
    var dateHour = (date.hour >= 10) ? '${date.hour}' : '0${date.hour}';
    var dateMinute = (date.minute >= 10) ? '${date.minute}' : '0${date.minute}';
    String formattedDateTime = '$dateYear-$dateMonth-${dateDay}T$dateHour:$dateMinute';
    var m = {
      'sender': widget.currentUser.username,
      'content': message,
      'receiver': widget.user.username
    };
    client!.send(
      destination: '/app/chat',
      body: jsonEncode(m),
    );
    setState(() {
      messages!.add(Message(widget.currentUser.username!, message, widget.user.username!, formattedDateTime));
    });
  }

  @override
  void dispose() {
    client!.deactivate();
    super.dispose();
  }

  void deactivateClient() {
    client!.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    if(messages == null){
      return WillPopScope(
        onWillPop: () async {
          deactivateClient();
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.username!),
            backgroundColor: Colors.green,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const Expanded(
                  child: CircularProgressIndicator()
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
                            content = value;
                            value = "";
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.green,),
                        onPressed: () {
                          sendMessage(content!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        deactivateClient();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
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
                      child: TextFormField(
                        initialValue: content,
                        decoration: InputDecoration(
                            hintText: "type_a_message".tr()
                        ),
                        onChanged: (value){
                          content = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.green,),
                      onPressed: () {
                        sendMessage(content!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
