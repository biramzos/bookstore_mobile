// ignore_for_file: non_constant_identifier_names

import 'package:Bookstore/Model/Message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  StompClient? stompClient;

  List<Message>? messages;

  @override
  void initState() {
    messages = [];
    stompClient = StompClient(
      config: StompConfig(
        url: '${dotenv.env["URL"]}/chat',
        onConnect: onStompConnect,
        onWebSocketError: onStompError,
      ),
    );
    stompClient!.activate();
    super.initState();
  }

  @override
  void dispose() {
    stompClient!.deactivate();
    super.dispose();
  }

  void onStompConnect(StompFrame frame) {
    print('Connected to STOMP server');
    stompClient!.subscribe(
      destination: '/queue/messages',
      callback: (StompFrame frame) {
        final message = Message.fromJson(jsonDecode(frame.body!));
        messages!.add(message);
      },
    );
  }

  void onStompError(dynamic error) {
    print('STOMP connection error: $error');
  }

  void send(sender, content, receiver){
    String formattedDateTime = DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now());
    var message = jsonEncode({
      'sender': sender,
      'content': content,
      'receiver': receiver,
      'time': formattedDateTime
    });
    stompClient!.send(
        destination: '/app/chat',
        body: message
    );
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
