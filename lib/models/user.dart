class User {
  final int id;
  final String name;
  final String avatar;
  final bool online;
  final String email;
  final String bio;
  final String phone;
  final String joinedDate;
  final double rating;
  final int reviewCount;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    this.online = false,
    this.email = '',
    this.bio = '',
    this.phone = '',
    this.joinedDate = '',
    this.rating = 0.0,
    this.reviewCount = 0,
  });
}
