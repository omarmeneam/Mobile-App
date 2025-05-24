import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/conversation.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _conversationsCollection = 'conversations';
  final String _messagesCollection = 'messages';

  // Get conversations for a user
  Future<List<Conversation>> getConversations() async {
    try {
      // TODO: Get current user ID from auth service
      const currentUserId = 'current_user_id';

      final snapshot =
          await _firestore
              .collection(_conversationsCollection)
              .where('participants', arrayContains: currentUserId)
              .orderBy('lastMessageTime', descending: true)
              .get();

      return await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();

          // Get the other participant's user data
          final otherUserId =
              (data['participants'] as List).firstWhere(
                    (id) => id != currentUserId,
                  )
                  as String;
          final userDoc =
              await _firestore.collection('users').doc(otherUserId).get();
          final userData = userDoc.data()!;

          // Get the product data
          final productDoc =
              await _firestore
                  .collection('products')
                  .doc(data['productId'])
                  .get();
          final productData = productDoc.data()!;

          return Conversation(
            id: doc.id,
            user: User.fromMap(userData),
            lastMessage: Message(
              id: data['lastMessageId'] ?? '',
              sender: data['lastMessageSender'] ?? '',
              text: data['lastMessageText'] ?? '',
              time: (data['lastMessageTime'] as Timestamp).toDate(),
            ),
            product: Product.fromMap(productDoc.id, productData),
          );
        }),
      );
    } catch (e) {
      throw Exception('Failed to get conversations: $e');
    }
  }

  // Get messages for a conversation
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final snapshot =
          await _firestore
              .collection(_conversationsCollection)
              .doc(conversationId)
              .collection(_messagesCollection)
              .orderBy('timestamp', descending: false)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Message(
          id: doc.id,
          sender: data['sender'] as String,
          text: data['text'] as String,
          time: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  // Send a message
  Future<bool> sendMessage(String conversationId, String text) async {
    try {
      // TODO: Get current user ID from auth service
      const currentUserId = 'current_user_id';

      final message = {
        'sender': currentUserId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      final messageRef = await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .collection(_messagesCollection)
          .add(message);

      // Update conversation with last message
      await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .update({
            'lastMessageId': messageRef.id,
            'lastMessageText': text,
            'lastMessageTime': message['timestamp'],
            'lastMessageSender': currentUserId,
          });

      return true;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Create a new conversation
  Future<String> createConversation(String productId, String sellerId) async {
    try {
      // TODO: Get current user ID from auth service
      const currentUserId = 'current_user_id';

      final conversation = {
        'participants': [currentUserId, sellerId],
        'productId': productId,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessageTime': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore
          .collection(_conversationsCollection)
          .add(conversation);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }
}
