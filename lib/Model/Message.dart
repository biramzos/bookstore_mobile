import 'User.dart';

class Message{
  final int id;
  final String? sender;
  final String? content;
  final String? receiver;
  final String? time;

  Message(
      this.id,
      this.sender,
      this.content,
      this.receiver,
      this.time
      );

  factory Message.fromJson(Map<String, dynamic> data){
    return Message(
        data['id'],
        data['sender'],
        data['content'],
        data['receiver'],
        data['time']
    );
  }

  Map toJson() => {
    "id": id,
    "sender": sender,
    "content": content,
    "receiver": receiver,
    "time": time
  };

}