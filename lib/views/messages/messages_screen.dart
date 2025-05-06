import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/messages_viewmodel.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final int _currentIndex = 0; // Home tab

  @override
  void initState() {
    super.initState();
    // Load conversations when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessagesViewModel>(context, listen: false).loadConversations();
    });
  }

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
    return Consumer<MessagesViewModel>(
      builder: (context, viewModel, child) {
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
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.error.isNotEmpty
                  ? Center(child: Text(viewModel.error))
                  : viewModel.conversations.isEmpty
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
                          itemCount: viewModel.conversations.length,
                          itemBuilder: (context, index) {
                            final conversation = viewModel.conversations[index];
                            final isUnread = conversation.lastMessage.sender != 'You';

                            return InkWell(
                              onTap: () {
                                // Set current conversation ID and navigate to chat screen
                                viewModel.loadMessages(conversation.id);
                                Navigator.pushNamed(
                                  context,
                                  '/messages/${conversation.user.uid}',
                                );
                              },
                              child: Container(
                                color: isUnread ? AppColors.accent.withOpacity(0.1) : null,
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // User Name and Time
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      conversation.user.name,
                                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                                          ),
                                                    ),
                                                    Text(
                                                      conversation.lastMessage.time,
                                                      style: TextStyle(
                                                        color: isUnread ? AppColors.primary : Colors.grey,
                                                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),

                                                // Last Message
                                                Text(
                                                  '${conversation.lastMessage.sender == "You" ? "You: " : ""}${conversation.lastMessage.text}',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: isUnread ? Colors.black : Colors.grey[600],
                                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),

                                                // Product Info
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        image: DecorationImage(
                                                          image: AssetImage(conversation.product.image),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            conversation.product.title,
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                          Text(
                                                            'RM ${conversation.product.price.toStringAsFixed(2)}',
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                          ),
                                                        ],
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
      },
    );
  }
}
