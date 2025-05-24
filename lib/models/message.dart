import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String sender;
  final String text;
  final DateTime time;

  Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      sender: map['sender'] as String,
      text: map['text'] as String,
      time: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'sender': sender, 'text': text, 'timestamp': time};
  }
}
