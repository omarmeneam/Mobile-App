import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String image;
  final List<String> images;
  final String category;
  final String condition;
  final DateTime createdAt;
  final String postedDate;
  final String sellerId;
  final bool active;
  final int views;
  final User? seller;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.images,
    required this.category,
    required this.condition,
    required this.createdAt,
    this.postedDate = '',
    required this.sellerId,
    required this.active,
    required this.views,
    this.seller,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      image: map['image'] as String,
      images: List<String>.from(map['images'] as List),
      category: map['category'] as String,
      condition: map['condition'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      postedDate: map['postedDate'] ?? '',
      sellerId: map['sellerId'] as String,
      active: map['active'] as bool,
      views: map['views'] as int,
      seller:
          map['seller'] != null
              ? User.fromMap(map['seller'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'images': images,
      'category': category,
      'condition': condition,
      'createdAt': createdAt,
      'postedDate': postedDate,
      'sellerId': sellerId,
      'active': active,
      'views': views,
      if (seller != null) 'seller': seller!.toMap(),
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}
