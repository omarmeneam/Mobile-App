class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;
  final DateTime createdAt;
  final String postedDate;
  final Seller? seller;
  final bool active;
  final int views;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.description = '',
    required this.image,
    required this.category,
    required this.createdAt,
    this.postedDate = '',
    this.seller,
    this.active = true,
    this.views = 0,
  });

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

class Seller {
  final int id;
  final String name;
  final String avatar;
  final double rating;
  final String joinedDate;
  final bool online;

  Seller({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.joinedDate,
    this.online = false,
  });
}
