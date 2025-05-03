import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/messaging_service.dart';

class MessagesViewModel extends ChangeNotifier {
  final MessagingService _messagingService = MessagingService();
  
  List<Conversation> _conversations = [];
  List<Message> _messages = [];
  int? _currentConversationId;
  bool _isLoading = false;
  String _error = '';
  
  // Getters
  List<Conversation> get conversations => _conversations;
  List<Message> get messages => _messages;
  int? get currentConversationId => _currentConversationId;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Load all conversations
  Future<void> loadConversations() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _conversations = await _messagingService.getConversations();
    } catch (e) {
      _error = 'Failed to load conversations: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Load messages for a specific conversation
  Future<void> loadMessages(int conversationId) async {
    _currentConversationId = conversationId;
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _messages = await _messagingService.getMessages(conversationId);
    } catch (e) {
      _error = 'Failed to load messages: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Send a message in the current conversation
  Future<bool> sendMessage(String text) async {
    if (_currentConversationId == null) {
      _error = 'No active conversation';
      notifyListeners();
      return false;
    }
    
    if (text.trim().isEmpty) {
      return false;
    }
    
    try {
      final success = await _messagingService.sendMessage(_currentConversationId!, text);
      
      if (success) {
        // Add message to local list for immediate display
        final newMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch, // This would be server-generated in a real app
          sender: 'You',
          text: text,
          time: 'Just now',
        );
        
        _messages.add(newMessage);
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _error = 'Failed to send message: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
