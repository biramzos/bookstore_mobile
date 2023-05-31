import 'package:Bookstore/Model/Message.dart';
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final Message message;
  final bool isMe;
  const MessageContainer({Key? key, required this.message, required this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                '${DateTime.parse(message.time!).day}.'
                    '${DateTime.parse(message.time!).month}.'
                    '${DateTime.parse(message.time!).year} '
                    '${DateTime.parse(message.time!).hour}:${DateTime.parse(message.time!).minute}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
