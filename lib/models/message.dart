import 'product.dart';

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

class User {
  final int id;
  final String name;
  final String avatar;
  final bool online;
  final String email;
  final String bio;
  final String phone;
  final String joinedDate;
  final double rating;
  final int reviewCount;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    this.online = false,
    this.email = '',
    this.bio = '',
    this.phone = '',
    this.joinedDate = '',
    this.rating = 0.0,
    this.reviewCount = 0,
  });
}
