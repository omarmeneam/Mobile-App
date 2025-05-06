import '../models/message.dart';
import '../models/product.dart';
import '../models/user.dart';

class MessagingService {
  // Simulate API call to fetch conversations
  Future<List<Conversation>> getConversations() async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return dummy data for now
    return [
      Conversation(
        id: 1,
        user: User(
          uid: '2',
          name: 'Maria Garcia',
          avatar: 'assets/images/avatars/maria.jpg',
          online: true,
          email: 'maria@example.com',
        ),
        lastMessage: Message(
          id: 1,
          sender: 'Maria Garcia',
          text: 'Is this still available?',
          time: '2:30 PM',
        ),
        product: Product(
          id: 1,
          title: 'MacBook Pro',
          price: 1899.99,
          image: 'assets/images/products/macbook.jpg',
          category: 'Electronics',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ),
      Conversation(
        id: 2,
        user: User(
          uid: '3',
          name: 'James Wilson',
          avatar: 'assets/images/avatars/james.jpg',
          email: 'james@example.com',
        ),
        lastMessage: Message(
          id: 2,
          sender: 'You',
          text: 'Would you take \$40?',
          time: 'Yesterday',
        ),
        product: Product(
          id: 2,
          title: 'Calculus Textbook',
          price: 45.00,
          image: 'assets/images/products/calculus_book.jpg',
          category: 'Books',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ),
    ];
  }
  
  // Simulate API call to fetch messages for a conversation
  Future<List<Message>> getMessages(int conversationId) async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Return dummy data for a conversation
    return [
      Message(
        id: 1,
        sender: 'Maria Garcia',
        text: 'Hi, I\'m interested in your MacBook. Is it still available?',
        time: '2:30 PM',
      ),
      Message(
        id: 2,
        sender: 'You',
        text: 'Yes, it is! Are you on campus?',
        time: '2:35 PM',
      ),
      Message(
        id: 3,
        sender: 'Maria Garcia',
        text: 'Great! Yes, I\'m in Larsen Hall. When could we meet?',
        time: '2:36 PM',
      ),
      Message(
        id: 4,
        sender: 'You',
        text: 'I can meet around 4pm today near the library if that works for you?',
        time: '2:40 PM',
      ),
    ];
  }
  
  // Simulate sending a message
  Future<bool> sendMessage(int conversationId, String text) async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
