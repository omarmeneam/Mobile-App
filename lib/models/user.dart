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
    joinedDate: firebaseUser.metadata.creationTime != null
        ? '${firebaseUser.metadata.creationTime!.day}/${firebaseUser.metadata.creationTime!.month}/${firebaseUser.metadata.creationTime!.year}'
        : 'Unknown',
  );
}

}
