import 'User.dart';

class Message{
  final String? sender;
  final String? content;
  final String? receiver;
  final String? time;

  Message(
      this.sender,
      this.content,
      this.receiver,
      this.time
      );

  factory Message.fromJson(Map<String, dynamic> data){
    return Message(
        User.fromJson(data['sender']).username,
        data['content'],
        User.fromJson(data['receiver']).username,
        data['time']
    );
  }

}