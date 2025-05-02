import 'package:flutter/material.dart';
import '../../models/message.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';
import '../../models/product.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final int _currentIndex = 0; // Home tab

  // Mock conversations data
  final List<Conversation> _conversations = [
    Conversation(
      id: 1,
      user: User(
        id: 101,
        name: 'Jamie Smith',
        avatar: 'assets/images/placeholder.png',
        online: true,
      ),
      lastMessage: Message(
        id: 1001,
        sender: 'them',
        text: 'Is this still available?',
        time: '10:30 AM',
      ),
      product: Product(
        id: 201,
        title: 'Desk Lamp - Adjustable LED',
        price: 25.0,
        image: 'assets/images/placeholder.png',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ),
    Conversation(
      id: 2,
      user: User(
        id: 102,
        name: 'Taylor Wilson',
        avatar: 'assets/images/placeholder.png',
        online: false,
      ),
      lastMessage: Message(
        id: 1002,
        sender: 'them',
        text: 'Great! I can meet tomorrow at the library.',
        time: 'Yesterday',
      ),
      product: Product(
        id: 202,
        title: 'Textbook - Introduction to Psychology',
        price: 45.0,
        image: 'assets/images/placeholder.png',
        category: 'Books',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ),
    Conversation(
      id: 3,
      user: User(
        id: 103,
        name: 'Jordan Lee',
        avatar: 'assets/images/placeholder.png',
        online: false,
      ),
      lastMessage: Message(
        id: 1003,
        sender: 'them',
        text: 'Would you take \$40 for it?',
        time: '2 days ago',
      ),
      product: Product(
        id: 203,
        title: 'Scientific Calculator',
        price: 30.0,
        image: 'assets/images/placeholder.png',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ),
  ];

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/create-listing');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          _conversations.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you contact a seller or receive messages, they\'ll appear here',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  final conversation = _conversations[index];
                  final isUnread =
                      conversation.lastMessage.sender == 'them' &&
                      conversation.lastMessage.time == '10:30 AM';

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/messages/${conversation.user.id}',
                      );
                    },
                    child: Container(
                      color:
                          isUnread ? AppColors.accent.withOpacity(0.1) : null,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Avatar with Online Indicator
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage(
                                        conversation.user.avatar,
                                      ),
                                    ),
                                    if (conversation.user.online)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 16),

                                // Message Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            conversation.user.name,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight:
                                                  isUnread
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              conversation.lastMessage.time,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        conversation.lastMessage.text,
                                        style: TextStyle(
                                          fontWeight:
                                              isUnread
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              isUnread
                                                  ? Colors.black
                                                  : Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),

                                      // Product Reference
                                      Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  conversation.product.image,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              conversation.product.title,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isUnread)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'New',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                        ],
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
