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
        data['sender']['username'],
        data['content'],
        data['receiver']['username'],
        data['time']
    );
  }

}