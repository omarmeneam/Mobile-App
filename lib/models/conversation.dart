import 'message.dart';
import 'product.dart';
import 'user.dart';

class Conversation {
  final String id;
  final User user;
  final Message lastMessage;
  final Product product;

  Conversation({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.product,
  });

  factory Conversation.fromMap(String id, Map<String, dynamic> map) {
    return Conversation(
      id: id,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      lastMessage: Message.fromMap(
        map['lastMessageId'] as String,
        map['lastMessage'] as Map<String, dynamic>,
      ),
      product: Product.fromMap(
        map['productId'] as String,
        map['product'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'lastMessageId': lastMessage.id,
      'lastMessage': lastMessage.toMap(),
      'productId': product.id,
      'product': product.toMap(),
    };
  }
}
