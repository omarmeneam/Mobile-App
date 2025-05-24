import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/conversation.dart';
import '../services/messaging_service.dart';

class MessagesViewModel extends ChangeNotifier {
  final MessagingService _messagingService = MessagingService();

  List<Conversation> _conversations = [];
  List<Message> _messages = [];
  String? _currentConversationId;
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Conversation> get conversations => _conversations;
  List<Message> get messages => _messages;
  String? get currentConversationId => _currentConversationId;
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
  Future<void> loadMessages(String conversationId) async {
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
  Future<void> sendMessage(String conversationId, String text) async {
    if (text.trim().isEmpty) return;

    try {
      await _messagingService.sendMessage(conversationId, text);
      await loadMessages(conversationId); // Reload messages to show the new one
    } catch (e) {
      _error = 'Failed to send message: ${e.toString()}';
      notifyListeners();
    }
  }
}
