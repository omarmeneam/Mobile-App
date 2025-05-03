import 'product.dart';
import 'user.dart';

class Message {
  final int id;
  final String sender;
  final String text;
  final String time;

  Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });
}

class Conversation {
  final int id;
  final User user;
  final Message lastMessage;
  final Product product;

  Conversation({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.product,
  });
}
