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
}
enum UserRole {
  student,
  teacher,
}
