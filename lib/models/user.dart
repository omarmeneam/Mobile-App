import 'package:firebase_auth/firebase_auth.dart' as firebase;

class User {
  final String uid;
  final String name;
  final String email;
  final String avatar;
  final bool online;
  final String bio;
  final String phone;
  final String joinedDate;
  final double rating;
  final int reviewCount;
  final bool isEmailVerified;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    this.online = false,
    this.bio = '',
    this.phone = '',
    this.joinedDate = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isEmailVerified = false,
  });

  // Factory constructor to create a User from Firebase user
  factory User.fromFirebaseUser(firebase.User firebaseUser) {
    final email = firebaseUser.email ?? '';
    return User(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'Anonymous User',
      email: email,
      avatar: firebaseUser.photoURL ?? 'assets/images/avatars/default.jpg',
      isEmailVerified: email.endsWith('@graduate.utm.my'),
      joinedDate:
          firebaseUser.metadata.creationTime != null
              ? '${firebaseUser.metadata.creationTime!.day}/${firebaseUser.metadata.creationTime!.month}/${firebaseUser.metadata.creationTime!.year}'
              : 'Unknown',
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      online: map['online'] as bool,
      isEmailVerified: map['isEmailVerified'] as bool,
      joinedDate: map['joinedDate'] as String,
      bio: map['bio'] as String,
      phone: map['phone'] as String,
      rating: map['rating'] as double,
      reviewCount: map['reviewCount'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatar': avatar,
      'online': online,
      'isEmailVerified': isEmailVerified,
      'joinedDate': joinedDate,
      'bio': bio,
      'phone': phone,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
