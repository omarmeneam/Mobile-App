import 'package:cloud_firestore/cloud_firestore.dart';

class ProductNotification {
  final String id;
  final String productId;
  final String type;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ProductNotification({
    required this.id,
    required this.productId,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  factory ProductNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductNotification(
      id: doc.id,
      productId: data['productId'] ?? '',
      type: data['type'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'type': type,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}
