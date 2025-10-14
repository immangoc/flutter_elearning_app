import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? fullName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastloginAt;
  final UserRole role;

  UserModel({
    required this.uid,
    required this.email,
    this.fullName,
    this.photoUrl,
    required this.createdAt,
    required this.lastloginAt,
    required this.role,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createAt'] as Timestamp).toDate(),
      lastloginAt: (data['lastloginAt'] as Timestamp).toDate(),
      role: UserRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => UserRole.student,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'createAt': Timestamp.fromDate(createdAt),
      'lastloginAt': Timestamp.fromDate(lastloginAt),
      'role': role.name,
    };
  }
}

enum UserRole { student, teacher }
